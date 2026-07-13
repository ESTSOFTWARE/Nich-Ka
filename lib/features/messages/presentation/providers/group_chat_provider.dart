import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../../../core/audio/active_chat.dart';
import '../../../../core/utils/server_date.dart';
import '../../../../core/audio/sound_service.dart';
import '../../../../core/network/http_client.dart';
import '../../data/datasource/remote/chat_remote_datasource.dart';
import '../../data/datasource/remote/mapper/chat_mapper.dart';
import '../../data/datasource/remote/model/dto/response/conversation_dto.dart';
import '../../data/datasource/remote/model/dto/response/message_dto.dart';
import '../../data/repositories/chat_repository_impl.dart';
import '../../domain/entities/chat_conversation.dart';
import '../../domain/entities/chat_member.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/entities/message_attachment.dart';
import '../../domain/entities/reply_preview.dart';
import '../../domain/use_cases/delete_message_use_case.dart';
import '../../domain/use_cases/edit_message_use_case.dart';
import '../../domain/use_cases/get_messages_use_case.dart';
import '../../domain/use_cases/leave_conversation_use_case.dart';
import '../../domain/use_cases/mark_read_use_case.dart';
import '../../domain/use_cases/pin_message_use_case.dart';
import '../../domain/use_cases/send_message_use_case.dart';
import '../../domain/use_cases/set_priority_use_case.dart';
import '../../domain/use_cases/toggle_reaction_use_case.dart';
import '../../domain/use_cases/update_conversation_use_case.dart';
import '../../domain/use_cases/upload_file_use_case.dart';
import 'typing_user.dart';

export 'typing_user.dart';

class GroupChatProvider extends ChangeNotifier {
  ChatConversation conversation;
  final int myUserId;

  late final ChatRemoteDataSource _ds;
  late final GetMessagesUseCase _getMessages;
  late final SendMessageUseCase _sendMessage;
  late final EditMessageUseCase _editMessage;
  late final DeleteMessageUseCase _deleteMessage;
  late final ToggleReactionUseCase _toggleReaction;
  late final UploadFileUseCase _uploadFile;
  late final PinMessageUseCase _pinMessage;
  late final SetPriorityUseCase _setPriority;
  late final LeaveConversationUseCase _leaveConversation;
  late final UpdateConversationUseCase _updateConversation;
  late final MarkReadUseCase _markRead;

  final ScrollController scrollController = ScrollController();
  bool _isScrolled = false;
  bool get isScrolled => _isScrolled;

  // Messages
  final List<ChatMessage> _messages = [];
  List<ChatMessage> get messages =>
      List.unmodifiable(_messages.where((m) => !m.deleted));
  bool _loadingMessages = true;
  bool get loadingMessages => _loadingMessages;

  // Pinned
  ChatMessage? get pinnedMessage =>
      _messages.where((m) => m.pinned && !m.deleted).lastOrNull;

  // Importantes/urgentes (para el banner de arriba, estilo fijado).
  List<ChatMessage> get importantMessages =>
      _messages.where((m) => !m.deleted && m.isImportant).toList();

  /// Desplaza la lista hasta el mensaje dado (aproximado por índice).
  void scrollToMessage(int id) {
    final list = messages;
    final idx = list.indexWhere((m) => m.id == id);
    if (idx < 0 || !scrollController.hasClients) return;
    final max = scrollController.position.maxScrollExtent;
    final target = list.length <= 1 ? max : (idx / (list.length - 1)) * max;
    scrollController.animateTo(
      target,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  // Reply / Edit
  ChatMessage? _replyTarget;
  ChatMessage? get replyTarget => _replyTarget;

  ChatMessage? _editTarget;
  ChatMessage? get editTarget => _editTarget;

  // Typing
  final List<TypingUser> _typingUsers = [];
  List<TypingUser> get typingUsers => List.unmodifiable(_typingUsers);
  Timer? _stopTypingTimer;
  bool _amTyping = false;

  // Upload
  bool _isUploading = false;
  bool get isUploading => _isUploading;

  // Leave
  bool _hasLeft = false;
  bool get hasLeft => _hasLeft;

  // WebSocket
  WebSocketChannel? _channel;
  StreamSubscription<dynamic>? _wsSub;
  Timer? _retryTimer;
  bool _disposed = false;

  // Mensaje a resaltar/saltar al abrir (viene de un push de mención).
  final int? highlightMessageId;

  GroupChatProvider(this.conversation, {int? myUserId, this.highlightMessageId})
    : myUserId = myUserId ?? HttpClient.instance.userId {
    final repo = ChatRepositoryImpl(ChatRemoteDataSource(HttpClient.instance));
    _ds = ChatRemoteDataSource(HttpClient.instance);
    _getMessages = GetMessagesUseCase(repo);
    _sendMessage = SendMessageUseCase(repo);
    _editMessage = EditMessageUseCase(repo);
    _deleteMessage = DeleteMessageUseCase(repo);
    _toggleReaction = ToggleReactionUseCase(repo);
    _uploadFile = UploadFileUseCase(repo);
    _pinMessage = PinMessageUseCase(repo);
    _setPriority = SetPriorityUseCase(repo);
    _leaveConversation = LeaveConversationUseCase(repo);
    _updateConversation = UpdateConversationUseCase(repo);
    _markRead = MarkReadUseCase(repo);

    scrollController.addListener(_onScroll);
    ActiveChat.conversationId =
        conversation.id; // estoy dentro de esta conversación
    _init();
  }

  void _onScroll() {
    final scrolled = scrollController.offset > 4;
    if (scrolled != _isScrolled) {
      _isScrolled = scrolled;
      notifyListeners();
    }
    // Cerca del inicio (subiendo por el historial) → cargar más viejos.
    // Pedimos que haya contenido desplazable para no auto-cargar al abrir.
    if (scrollController.hasClients &&
        scrollController.position.maxScrollExtent > 400 &&
        scrollController.offset <=
            scrollController.position.minScrollExtent + 200) {
      loadOlder();
    }
  }

  // Paginación hacia atrás (mensajes viejos).
  bool _loadingOlder = false;
  bool _hasMoreOlder = true;
  bool get loadingOlder => _loadingOlder;

  Future<void> loadOlder() async {
    if (_loadingOlder || !_hasMoreOlder || _messages.isEmpty || _disposed) {
      return;
    }
    _loadingOlder = true;
    notifyListeners();
    try {
      final cursor = _messages.first.id;
      final older = await _getMessages(conversation.id, cursor: cursor);
      final nuevos = older
          .where((m) => !_messages.any((e) => e.id == m.id))
          .toList();
      if (nuevos.isEmpty) {
        _hasMoreOlder = false;
      } else {
        // Preservamos la posición: medimos el alto antes y saltamos por el
        // delta tras insertar, para que la vista no brinque.
        final before = scrollController.hasClients
            ? scrollController.position.maxScrollExtent
            : 0.0;
        final offset = scrollController.hasClients
            ? scrollController.offset
            : 0.0;
        _messages.insertAll(0, nuevos);
        if (older.length < 40) _hasMoreOlder = false;
        notifyListeners();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!scrollController.hasClients) return;
          final after = scrollController.position.maxScrollExtent;
          scrollController.jumpTo(offset + (after - before));
        });
      }
    } catch (_) {
    } finally {
      _loadingOlder = false;
      if (!_disposed) notifyListeners();
    }
  }

  Future<void> _init() async {
    _refreshConversation(); // trae avatar/nombre/miembros actuales (no bloquea)
    await _loadMessages();
    _markRead(conversation.id).catchError((_) {});
    _connectWs();
    // Si venimos de un push de mención, salta a ese mensaje.
    if (highlightMessageId != null) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => scrollToMessage(highlightMessageId!),
      );
    }
  }

  /// Recarga los datos de la conversación (avatar/nombre/miembros) por si
  /// cambiaron desde otro dispositivo mientras la app estaba cerrada.
  Future<void> _refreshConversation() async {
    try {
      final dto = await _ds.getConversationDetail(conversation.id);
      conversation = ChatMapper.fromConversationDto(dto);
      notifyListeners();
    } catch (_) {}
  }

  List<ChatMember> _contacts = [];
  List<ChatMember> get contacts => _contacts;

  Future<void> loadContacts() async {
    try {
      final dtos = await _ds.getContacts();
      _contacts = dtos
          .map(
            (m) => ChatMember(
              id: m.id,
              name: m.name,
              role: m.role,
              avatar: m.avatar,
            ),
          )
          .toList();
      notifyListeners();
    } catch (_) {}
  }

  Future<void> addMembers(List<int> userIds) async {
    if (userIds.isEmpty) return;
    try {
      final dto = await _ds.addMembers(conversation.id, userIds);
      conversation = ChatMapper.fromConversationDto(dto);
      notifyListeners();
    } catch (_) {}
  }

  Future<void> _loadMessages() async {
    _loadingMessages = true;
    notifyListeners();
    try {
      final msgs = await _getMessages(conversation.id);
      _messages
        ..clear()
        ..addAll(msgs);
    } catch (_) {}
    _loadingMessages = false;
    notifyListeners();
    _jumpToBottomStable();
  }

  Future<void> _connectWs() async {
    if (_disposed) return;
    try {
      final channel = _ds.connectChat();

      // Use a short timeout to detect failed handshakes without blocking.
      // On success the subscription handles all events; on failure we retry.
      channel.ready.timeout(const Duration(seconds: 8)).catchError((_) {
        _scheduleRetry();
      });

      if (_disposed) {
        channel.sink.close();
        return;
      }
      _channel = channel;
      _wsSub = channel.stream.listen(
        _onWsMessage,
        onDone: _scheduleRetry,
        onError: (_) => _scheduleRetry(),
        cancelOnError: true,
      );
    } catch (_) {
      _scheduleRetry();
    }
  }

  void _scheduleRetry() {
    if (_disposed) return;
    _retryTimer?.cancel();
    _retryTimer = Timer(const Duration(seconds: 4), _connectWs);
  }

  void _onWsMessage(dynamic raw) {
    try {
      final data = jsonDecode(raw as String) as Map<String, dynamic>;
      final type = data['type'] as String?;

      switch (type) {
        case 'message:new':
          final msg = ChatMapper.fromMessageDto(
            MessageDto.fromJson(data['message'] as Map<String, dynamic>),
          );
          if (msg.conversationId == conversation.id) {
            if (!_messages.any((m) => m.id == msg.id)) {
              _messages.add(msg);
              notifyListeners();
              _scrollToBottom();
              // Estoy dentro de la conversación → sonido + marcar leído (lo
              // estoy viendo), así no queda como no leído al salir.
              if (msg.senderId != myUserId) {
                SoundService.instance.responseMessage();
                _markRead(conversation.id).catchError((_) {});
              }
            }
          }

        case 'conversation:delivered':
          if ((data['conversationId'] as int?) == conversation.id &&
              (data['userId'] as int?) != myUserId) {
            // En grupos el estado depende de TODOS los miembros: recargamos
            // del backend (que aplica la regla). En 1:1 basta el evento.
            if (conversation.isGroup) {
              _scheduleStatusReload();
            } else {
              _applyStatusUpTo(
                parseServerDate(data['deliveredAt'] as String),
                'delivered',
              );
            }
          }

        case 'conversation:read':
          if ((data['conversationId'] as int?) == conversation.id &&
              (data['userId'] as int?) != myUserId) {
            if (conversation.isGroup) {
              _scheduleStatusReload();
            } else {
              _applyStatusUpTo(
                parseServerDate(data['readAt'] as String),
                'read',
              );
            }
          }

        case 'message:edited':
          _applyEdit(
            data['messageId'] as int,
            data['content'] as String,
            data['editedAt'] as String?,
          );

        case 'message:deleted':
          _applyPatch(data['messageId'] as int, deleted: true);

        case 'message:priority':
          _applyPatch(
            data['messageId'] as int,
            priority: data['priority'] as String?,
          );

        case 'reaction:updated':
          final rawReactions = data['reactions'] as Map<String, dynamic>;
          _applyReactions(
            data['messageId'] as int,
            rawReactions.map(
              (emoji, ids) => MapEntry(
                emoji,
                (ids as List<dynamic>).map((id) => id as int).toList(),
              ),
            ),
          );

        case 'message:pinned':
          final convId = data['conversationId'] as int?;
          final pinnedId = data['messageId'] as int?;
          if (convId == conversation.id) {
            for (var i = 0; i < _messages.length; i++) {
              _messages[i] = _messages[i].copyWith(
                pinned: _messages[i].id == pinnedId,
              );
            }
            notifyListeners();
          }

        case 'conversation:updated':
          if (data['conversation'] != null) {
            final dto = ConversationDto.fromJson(
              data['conversation'] as Map<String, dynamic>,
            );
            if (dto.id == conversation.id) {
              conversation = ChatMapper.fromConversationDto(dto);
              notifyListeners();
            }
          }

        case 'member:left':
          final convId = data['conversationId'] as int?;
          final userId = data['userId'] as int?;
          if (convId == conversation.id && userId == myUserId) {
            _hasLeft = true;
            notifyListeners();
          }

        case 'typing':
          final userId = data['userId'] as int?;
          final userName = data['userName'] as String? ?? '';
          final isTyping = data['typing'] as bool? ?? false;
          final convId = data['conversationId'] as int?;
          if (userId != myUserId && convId == conversation.id) {
            _typingUsers.removeWhere((t) => t.userId == userId);
            if (isTyping && userId != null) {
              final avatar = conversation.members
                  .where((m) => m.id == userId)
                  .map((m) => m.avatar)
                  .firstOrNull;
              _typingUsers.add(TypingUser(userId, userName, avatar: avatar));
            }
            notifyListeners();
          }
      }
    } catch (_) {}
  }

  void _applyEdit(int id, String content, String? editedAtRaw) {
    final idx = _messages.indexWhere((m) => m.id == id);
    if (idx == -1) return;
    _messages[idx] = _messages[idx].copyWith(
      content: content,
      edited: true,
      editedAt: editedAtRaw != null ? DateTime.tryParse(editedAtRaw) : null,
    );
    notifyListeners();
  }

  void _applyPatch(int id, {bool? deleted, String? priority}) {
    final idx = _messages.indexWhere((m) => m.id == id);
    if (idx == -1) return;
    _messages[idx] = _messages[idx].copyWith(
      deleted: deleted,
      priority: priority,
    );
    notifyListeners();
  }

  // En grupos, el status "leído/entregado" solo aplica cuando TODOS los
  // miembros leyeron/recibieron. Un evento de un solo miembro no basta, así
  // que recargamos los estados del backend (que ya aplica la regla), con un
  // pequeño debounce para no golpear la red por cada evento.
  Timer? _statusReloadTimer;

  void _scheduleStatusReload() {
    _statusReloadTimer?.cancel();
    _statusReloadTimer = Timer(
      const Duration(milliseconds: 600),
      _reloadStatuses,
    );
  }

  Future<void> _reloadStatuses() async {
    if (_disposed) return;
    try {
      final fresh = await _getMessages(conversation.id);
      final statusById = {for (final m in fresh) m.id: m.status};
      var changed = false;
      for (var i = 0; i < _messages.length; i++) {
        final s = statusById[_messages[i].id];
        if (s != null && s != _messages[i].status) {
          _messages[i] = _messages[i].copyWith(status: s);
          changed = true;
        }
      }
      if (changed && !_disposed) notifyListeners();
    } catch (_) {}
  }

  // Marca MIS mensajes hasta `ts` con el estado dado (entregado/leído).
  void _applyStatusUpTo(DateTime ts, String status) {
    var changed = false;
    for (var i = 0; i < _messages.length; i++) {
      final m = _messages[i];
      if (m.senderId != myUserId || m.createdAt.isAfter(ts)) continue;
      if (m.status == status) continue;
      // No degradar: si ya está leído, no volver a 'delivered'.
      if (status == 'delivered' && m.status == 'read') continue;
      _messages[i] = m.copyWith(status: status);
      changed = true;
    }
    if (changed) notifyListeners();
  }

  void _applyReactions(int id, Map<String, List<int>> reactions) {
    final idx = _messages.indexWhere((m) => m.id == id);
    if (idx == -1) return;
    _messages[idx] = _messages[idx].copyWith(reactions: reactions);
    notifyListeners();
  }

  void onInputChanged(String value) {
    if (value.isEmpty && _amTyping) {
      _notifyTyping(false);
    } else if (value.isNotEmpty && !_amTyping) {
      _notifyTyping(true);
    }
    _stopTypingTimer?.cancel();
    if (value.isNotEmpty) {
      _stopTypingTimer = Timer(const Duration(seconds: 3), () {
        _notifyTyping(false);
      });
    }
  }

  void _notifyTyping(bool typing) {
    _amTyping = typing;
    final ch = _channel;
    if (ch != null) {
      try {
        _ds.sendTyping(ch, conversation.id, typing);
      } catch (_) {}
    }
  }

  void setReplyTarget(ChatMessage? msg) {
    _replyTarget = msg;
    _editTarget = null;
    notifyListeners();
  }

  void setEditTarget(ChatMessage? msg) {
    _editTarget = msg;
    _replyTarget = null;
    notifyListeners();
  }

  void clearActionTargets() {
    _replyTarget = null;
    _editTarget = null;
    notifyListeners();
  }

  Future<void> sendText(String text, {List<int> mentions = const []}) async {
    if (text.trim().isEmpty) return;
    _notifyTyping(false);
    _stopTypingTimer?.cancel();

    if (_editTarget != null) {
      final target = _editTarget!;
      clearActionTargets();
      try {
        final updated = await _editMessage(target.id, text.trim());
        _applyEdit(updated.id, updated.content ?? '', null);
      } catch (_) {}
      return;
    }

    final replyToId = _replyTarget?.id;
    clearActionTargets();
    SoundService.instance.sent(); // sonido al enviar
    try {
      final sent = await _sendMessage(
        conversation.id,
        content: text.trim(),
        replyToId: replyToId,
        mentions: mentions,
      );
      _addIfNew(sent);
    } catch (_) {}
  }

  Future<void> sendImage(File file) async {
    await sendFile(file);
  }

  Future<void> sendFile(File file) async {
    _isUploading = true;
    notifyListeners();
    SoundService.instance.sent();
    final replyTarget = _replyTarget;
    try {
      final attachment = await _uploadFile(file);
      final sent = await _sendMessage(
        conversation.id,
        attachments: [attachment],
        replyToId: replyTarget?.id,
      );
      clearActionTargets();
      _addIfNew(_withReply(sent, replyTarget));
    } catch (_) {}
    _isUploading = false;
    notifyListeners();
  }

  Future<void> sendSticker(File file) async {
    _isUploading = true;
    notifyListeners();
    SoundService.instance.sent();
    final replyTarget = _replyTarget;
    try {
      final attachment = await _uploadFile(file);
      final sent = await _sendMessage(
        conversation.id,
        attachments: [
          MessageAttachment(
            id: attachment.id,
            type: 'sticker',
            name: attachment.name,
            url: attachment.url,
            size: attachment.size,
          ),
        ],
        replyToId: replyTarget?.id,
      );
      clearActionTargets();
      _addIfNew(_withReply(sent, replyTarget));
    } catch (_) {}
    _isUploading = false;
    notifyListeners();
  }

  ChatMessage _withReply(ChatMessage msg, ChatMessage? replyTarget) {
    if (replyTarget == null || msg.replyTo != null) return msg;
    return msg.copyWith(replyTo: buildReplyPreview(replyTarget));
  }

  Future<void> react(int messageId, String emoji) async {
    try {
      final updated = await _toggleReaction(messageId, emoji);
      _applyReactions(updated.id, updated.reactions);
    } catch (_) {}
  }

  Future<void> deleteMessage(int messageId) async {
    try {
      await _deleteMessage(messageId);
      _applyPatch(messageId, deleted: true);
    } catch (_) {}
  }

  Future<bool?> pinMessage(int messageId) async {
    try {
      final pinned = await _pinMessage(messageId);
      for (var i = 0; i < _messages.length; i++) {
        _messages[i] = _messages[i].copyWith(
          pinned: pinned && _messages[i].id == messageId,
        );
      }
      notifyListeners();
      return pinned;
    } catch (_) {
      return null;
    }
  }

  Future<void> setPriority(int messageId, String priority) async {
    try {
      await _setPriority(messageId, priority);
      _applyPatch(messageId, priority: priority);
    } catch (_) {}
  }

  Future<bool> leaveConversation() async {
    try {
      await _leaveConversation(conversation.id);
      _hasLeft = true;
      notifyListeners();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> updateGroup({String? name, String? description}) async {
    try {
      await _updateConversation(
        conversation.id,
        name: name,
        description: description,
      );
      if (name != null) {
        conversation = conversation.copyWith(name: name);
        notifyListeners();
      }
    } catch (_) {}
  }

  void _addIfNew(ChatMessage msg) {
    if (_messages.any((m) => m.id == msg.id)) return;
    _messages.add(msg);
    notifyListeners();
    _scrollToBottom();
  }

  bool canEdit(ChatMessage msg) =>
      msg.senderId == myUserId &&
      (msg.content != null && msg.content!.isNotEmpty) &&
      DateTime.now().difference(msg.createdAt).inMinutes < 20;

  bool get isCreator => conversation.createdBy == myUserId;

  bool isMyMessage(ChatMessage msg) => msg.senderId == myUserId;

  ReplyPreview buildReplyPreview(ChatMessage msg) => ReplyPreview(
    id: msg.id,
    content: msg.content,
    senderName: msg.senderName,
    attachment: msg.attachments.isNotEmpty ? msg.attachments.first : null,
  );

  void _scrollToBottom({bool immediate = false}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: immediate ? 0 : 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  /// Al abrir el chat, re-ancla al fondo varias veces durante un momento. Así
  /// cae al último mensaje aunque las imágenes carguen después (crecen y, si
  /// no, te dejarían a media conversación).
  void _jumpToBottomStable() {
    var attempts = 0;
    void snap() {
      if (_disposed || !scrollController.hasClients) return;
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
      attempts++;
      if (attempts < 6) {
        Future.delayed(const Duration(milliseconds: 120), snap);
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) => snap());
  }

  @override
  void dispose() {
    _disposed = true;
    // Al salir, marca leído todo lo visto (mis mensajes y los que llegaron
    // mientras estaba dentro), para no quedar como "no leído" en la lista.
    _markRead(conversation.id).catchError((_) {});
    if (ActiveChat.conversationId == conversation.id) {
      ActiveChat.conversationId = null; // salí de la conversación
    }
    _stopTypingTimer?.cancel();
    _retryTimer?.cancel();
    _statusReloadTimer?.cancel();
    _notifyTyping(false);
    _wsSub?.cancel();
    _channel?.sink.close();
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.dispose();
  }
}
