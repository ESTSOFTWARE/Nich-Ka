import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../../core/audio/active_chat.dart';
import '../../../../core/audio/sound_service.dart';
import '../../../../core/network/http_client.dart';
import '../../data/datasource/remote/chat_remote_datasource.dart';
import '../../data/datasource/remote/mapper/chat_mapper.dart';
import '../../data/datasource/remote/model/dto/response/conversation_dto.dart';
import '../../data/datasource/remote/model/dto/response/message_dto.dart';
import '../../data/repositories/chat_repository_impl.dart';
import '../../domain/entities/chat_conversation.dart';
import '../../domain/entities/chat_member.dart';
import '../../domain/use_cases/create_conversation_use_case.dart';
import '../../domain/use_cases/get_contacts_use_case.dart';
import '../../domain/use_cases/get_conversations_use_case.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'messages_ui_state.dart';

export 'messages_ui_state.dart';

class MessagesProvider extends ChangeNotifier {
  final GetConversationsUseCase _getConversations;
  final GetContactsUseCase _getContacts;
  final CreateConversationUseCase _createConversation;
  late final ChatRemoteDataSource _ds;
  final ScrollController scrollController = ScrollController();
  final TextEditingController searchController = TextEditingController();

  bool _isScrolled = false;
  bool get isScrolled => _isScrolled;

  MessagesUiState _state = MessagesUiState.loading;
  MessagesUiState get state => _state;

  List<ChatConversation> _conversations = [];
  List<ChatConversation> get conversations {
    if (_search.isEmpty) return _conversations;
    final q = _search.toLowerCase();
    return _conversations
        .where(
          (c) =>
              c.name?.toLowerCase().contains(q) == true ||
              c.members.any((m) => m.name.toLowerCase().contains(q)),
        )
        .toList();
  }

  String _search = '';
  String get search => _search;

  void setSearch(String value) {
    _search = value;
    notifyListeners();
  }

  List<ChatMember> _contacts = [];
  List<ChatMember> get contacts => _contacts;

  bool _loadingContacts = false;
  bool get loadingContacts => _loadingContacts;

  String? _error;
  String? get error => _error;

  int get totalUnread => _conversations.fold(0, (s, c) => s + c.unreadCount);
  int get totalConversations => _conversations.length;

  // WebSocket for real-time conversation updates
  WebSocketChannel? _channel;
  StreamSubscription<dynamic>? _wsSub;
  Timer? _retryTimer;
  bool _disposed = false;

  MessagesProvider({
    GetConversationsUseCase? getConversations,
    GetContactsUseCase? getContacts,
    CreateConversationUseCase? createConversation,
  }) : _getConversations =
           getConversations ??
           GetConversationsUseCase(
             ChatRepositoryImpl(ChatRemoteDataSource(HttpClient.instance)),
           ),
       _getContacts =
           getContacts ??
           GetContactsUseCase(
             ChatRepositoryImpl(ChatRemoteDataSource(HttpClient.instance)),
           ),
       _createConversation =
           createConversation ??
           CreateConversationUseCase(
             ChatRepositoryImpl(ChatRemoteDataSource(HttpClient.instance)),
           ) {
    _ds = ChatRemoteDataSource(HttpClient.instance);
    scrollController.addListener(_onScroll);
    _load();
    _connectWs();
  }

  void _onScroll() {
    final scrolled = scrollController.offset > 4;
    if (scrolled != _isScrolled) {
      _isScrolled = scrolled;
      notifyListeners();
    }
  }

  // ── WebSocket ────────────────────────────────────────────────────────────────

  void _connectWs() {
    if (_disposed) return;
    try {
      final channel = _ds.connectChat();
      channel.ready.timeout(const Duration(seconds: 8)).catchError((_) {
        _scheduleRetry();
      });
      _channel = channel;
      _wsSub = channel.stream.listen(
        _onWsEvent,
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
    _retryTimer = Timer(const Duration(seconds: 5), _connectWs);
  }

  void _onWsEvent(dynamic raw) {
    try {
      final data = jsonDecode(raw as String) as Map<String, dynamic>;
      final type = data['type'] as String?;

      switch (type) {
        case 'conversation:new':
          if (data['conversation'] != null) {
            final conv = ChatMapper.fromConversationDto(
              ConversationDto.fromJson(
                data['conversation'] as Map<String, dynamic>,
              ),
            );
            if (!_conversations.any((c) => c.id == conv.id)) {
              _conversations = [conv, ..._conversations];
              _state = MessagesUiState.success;
              notifyListeners();
            }
          }

        case 'message:new':
          if (data['message'] != null) {
            final msg = ChatMapper.fromMessageDto(
              MessageDto.fromJson(data['message'] as Map<String, dynamic>),
            );
            final myId = HttpClient.instance.userId;
            final idx = _conversations.indexWhere(
              (c) => c.id == msg.conversationId,
            );
            if (idx != -1) {
              final conv = _conversations[idx];
              _conversations = List.from(_conversations)
                ..[idx] = conv.copyWith(
                  lastMessage: msg,
                  unreadCount: msg.senderId == myId
                      ? conv.unreadCount
                      : conv.unreadCount + 1,
                );
              notifyListeners();
            }
            // Sonido: mensaje nuevo en otra conversación (si no es mío y no estoy dentro de ella;
            // si estoy dentro, GroupChatProvider reproduce sound_response_message).
            if (msg.senderId != myId &&
                msg.conversationId != ActiveChat.conversationId) {
              SoundService.instance.message();
            }
            // Ack de entrega: me llegó (aunque no esté dentro del chat) → doble flecha gris.
            if (msg.senderId != myId) {
              _ds.markDelivered(msg.conversationId).catchError((_) {});
            }
          }

        case 'conversation:updated':
          if (data['conversation'] != null) {
            final conv = ChatMapper.fromConversationDto(
              ConversationDto.fromJson(
                data['conversation'] as Map<String, dynamic>,
              ),
            );
            final idx = _conversations.indexWhere((c) => c.id == conv.id);
            if (idx != -1) {
              _conversations = List.from(_conversations)..[idx] = conv;
              notifyListeners();
            }
          }
      }
    } catch (_) {}
  }

  // ── Conversations ────────────────────────────────────────────────────────────

  Future<void> _load() async {
    _state = MessagesUiState.loading;
    _error = null;
    notifyListeners();
    try {
      _conversations = await _getConversations();
      _state = _conversations.isEmpty
          ? MessagesUiState.empty
          : MessagesUiState.success;
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
      _state = MessagesUiState.error;
    }
    notifyListeners();
  }

  Future<void> refresh() => _load();

  /// Marca la conversación como leída localmente (antes de navegar al chat).
  /// El servidor confirma el read cuando GroupChatProvider llama markRead.
  void markReadLocally(int conversationId) {
    final idx = _conversations.indexWhere((c) => c.id == conversationId);
    if (idx != -1 && _conversations[idx].unreadCount > 0) {
      _conversations = List.from(_conversations)
        ..[idx] = _conversations[idx].copyWith(unreadCount: 0);
      notifyListeners();
    }
  }

  Future<void> loadContacts() async {
    if (_loadingContacts) return;
    _loadingContacts = true;
    notifyListeners();
    try {
      _contacts = await _getContacts();
    } catch (_) {
      _contacts = [];
    }
    _loadingContacts = false;
    notifyListeners();
  }

  Future<ChatConversation?> createConversation({
    required String type,
    required List<int> memberIds,
    String? name,
  }) async {
    try {
      final conv = await _createConversation(
        type: type,
        memberIds: memberIds,
        name: name,
      );
      if (!_conversations.any((c) => c.id == conv.id)) {
        _conversations = [conv, ..._conversations];
        _state = MessagesUiState.success;
        notifyListeners();
      }
      return conv;
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return null;
    }
  }

  @override
  void dispose() {
    _disposed = true;
    _retryTimer?.cancel();
    _wsSub?.cancel();
    _channel?.sink.close();
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    searchController.dispose();
    super.dispose();
  }
}
