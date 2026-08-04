import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../../../core/audio/active_chat.dart';
import '../../../../core/audio/sound_service.dart';
import '../../../../core/network/http_client.dart';
import '../../data/datasource/remote/chat_remote_datasource.dart';
import '../../data/datasource/remote/mapper/chat_mapper.dart';
import '../../data/datasource/remote/model/dto/response/conversation_dto.dart';
import '../../data/datasource/remote/model/dto/response/message_dto.dart';
import '../../data/repositories/chat_repository_impl.dart';
import '../../domain/entities/chat_conversation.dart';
import '../../domain/use_cases/create_conversation_use_case.dart';
import '../../domain/use_cases/get_contacts_use_case.dart';
import '../../domain/use_cases/get_conversations_use_case.dart';
import '../providers/messages_ui_state.dart';
import 'messages_state.dart';

class MessagesNotifier extends Notifier<MessagesState> {
  final ScrollController scrollController = ScrollController();
  final TextEditingController searchController = TextEditingController();

  late final GetConversationsUseCase _getConversations;
  late final GetContactsUseCase _getContacts;
  late final CreateConversationUseCase _createConversation;
  late final ChatRemoteDataSource _ds;

  WebSocketChannel? _channel;
  StreamSubscription<dynamic>? _wsSub;
  Timer? _retryTimer;
  bool _disposed = false;

  @override
  MessagesState build() {
    final repo = ChatRepositoryImpl(ChatRemoteDataSource(HttpClient.instance));
    _getConversations = GetConversationsUseCase(repo);
    _getContacts = GetContactsUseCase(repo);
    _createConversation = CreateConversationUseCase(repo);
    _ds = ChatRemoteDataSource(HttpClient.instance);

    scrollController.addListener(_onScroll);
    ref.onDispose(() {
      _disposed = true;
      _retryTimer?.cancel();
      _wsSub?.cancel();
      _channel?.sink.close();
      scrollController.removeListener(_onScroll);
      scrollController.dispose();
      searchController.dispose();
    });

    _load();
    _connectWs();
    return const MessagesState();
  }

  void _onScroll() {
    final scrolled = scrollController.offset > 4;
    if (scrolled != state.isScrolled) {
      state = state.copyWith(isScrolled: scrolled);
    }
  }

  void setSearch(String value) => state = state.copyWith(search: value);

  // ── WebSocket ──────────────────────────────────────────────────────────────
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
            if (!state.allConversations.any((c) => c.id == conv.id)) {
              state = state.copyWith(
                allConversations: [conv, ...state.allConversations],
                uiState: MessagesUiState.success,
              );
            }
          }

        case 'message:new':
          if (data['message'] != null) {
            final msg = ChatMapper.fromMessageDto(
              MessageDto.fromJson(data['message'] as Map<String, dynamic>),
            );
            final myId = HttpClient.instance.userId;
            final list = state.allConversations;
            final idx = list.indexWhere((c) => c.id == msg.conversationId);
            if (idx != -1) {
              final conv = list[idx];
              final seen =
                  msg.senderId == myId ||
                  msg.conversationId == ActiveChat.conversationId;
              final next = List<ChatConversation>.from(list)
                ..[idx] = conv.copyWith(
                  lastMessage: msg,
                  unreadCount: seen ? conv.unreadCount : conv.unreadCount + 1,
                );
              state = state.copyWith(allConversations: _sorted(next));
            }
            if (msg.senderId != myId &&
                msg.conversationId != ActiveChat.conversationId) {
              SoundService.instance.message();
            }
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
            final list = state.allConversations;
            final idx = list.indexWhere((c) => c.id == conv.id);
            if (idx != -1) {
              state = state.copyWith(
                allConversations: List<ChatConversation>.from(list)
                  ..[idx] = conv,
              );
            }
          }

        case 'presence:init':
          final ids = (data['onlineUserIds'] as List<dynamic>)
              .map((e) => e as int)
              .toSet();
          state = state.copyWith(onlineUserIds: ids);

        case 'user:online':
          final uid = data['userId'] as int?;
          if (uid != null) {
            state = state.copyWith(
              onlineUserIds: {...state.onlineUserIds, uid},
            );
          }

        case 'user:offline':
          final uid = data['userId'] as int?;
          if (uid != null) {
            state = state.copyWith(
              onlineUserIds: {...state.onlineUserIds}..remove(uid),
            );
          }
      }
    } catch (_) {}
  }

  /// Chat con actividad más reciente primero.
  List<ChatConversation> _sorted(List<ChatConversation> list) {
    final copy = List<ChatConversation>.from(list);
    copy.sort((a, b) {
      final da = a.lastMessage?.createdAt ?? a.createdAt;
      final db = b.lastMessage?.createdAt ?? b.createdAt;
      return db.compareTo(da);
    });
    return copy;
  }

  Future<void> _load() async {
    state = state.copyWith(uiState: MessagesUiState.loading, error: null);
    try {
      final conversations = await _getConversations();
      final sorted = _sorted(conversations);
      state = state.copyWith(
        allConversations: sorted,
        uiState: sorted.isEmpty
            ? MessagesUiState.empty
            : MessagesUiState.success,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString().replaceFirst('Exception: ', ''),
        uiState: MessagesUiState.error,
      );
    }
  }

  Future<void> refresh() => _load();

  void markReadLocally(int conversationId) {
    final list = state.allConversations;
    final idx = list.indexWhere((c) => c.id == conversationId);
    if (idx != -1 && list[idx].unreadCount > 0) {
      state = state.copyWith(
        allConversations: List<ChatConversation>.from(list)
          ..[idx] = list[idx].copyWith(unreadCount: 0),
      );
    }
  }

  Future<void> loadContacts() async {
    if (state.loadingContacts) return;
    state = state.copyWith(loadingContacts: true);
    try {
      final contacts = await _getContacts();
      state = state.copyWith(contacts: contacts, loadingContacts: false);
    } catch (_) {
      state = state.copyWith(contacts: [], loadingContacts: false);
    }
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
      if (!state.allConversations.any((c) => c.id == conv.id)) {
        state = state.copyWith(
          allConversations: [conv, ...state.allConversations],
          uiState: MessagesUiState.success,
        );
      }
      return conv;
    } catch (e) {
      state = state.copyWith(
        error: e.toString().replaceFirst('Exception: ', ''),
      );
      return null;
    }
  }
}

final messagesProvider = NotifierProvider<MessagesNotifier, MessagesState>(
  MessagesNotifier.new,
);
