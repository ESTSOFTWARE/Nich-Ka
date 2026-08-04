import '../../domain/entities/chat_conversation.dart';
import '../../domain/entities/chat_member.dart';
import '../providers/messages_ui_state.dart';

class MessagesState {
  final bool isScrolled;
  final MessagesUiState uiState;
  final List<ChatConversation> allConversations;
  final String search;
  final List<ChatMember> contacts;
  final bool loadingContacts;
  final String? error;
  final Set<int> onlineUserIds;

  const MessagesState({
    this.isScrolled = false,
    this.uiState = MessagesUiState.loading,
    this.allConversations = const [],
    this.search = '',
    this.contacts = const [],
    this.loadingContacts = false,
    this.error,
    this.onlineUserIds = const {},
  });

  /// Conversaciones filtradas por el texto de búsqueda.
  List<ChatConversation> get conversations {
    if (search.isEmpty) return allConversations;
    final q = search.toLowerCase();
    return allConversations
        .where(
          (c) =>
              c.name?.toLowerCase().contains(q) == true ||
              c.members.any((m) => m.name.toLowerCase().contains(q)),
        )
        .toList();
  }

  int get totalUnread => allConversations.fold(0, (s, c) => s + c.unreadCount);
  int get totalConversations => allConversations.length;

  static const Object _keep = Object();

  MessagesState copyWith({
    bool? isScrolled,
    MessagesUiState? uiState,
    List<ChatConversation>? allConversations,
    String? search,
    List<ChatMember>? contacts,
    bool? loadingContacts,
    Object? error = _keep,
    Set<int>? onlineUserIds,
  }) => MessagesState(
    isScrolled: isScrolled ?? this.isScrolled,
    uiState: uiState ?? this.uiState,
    allConversations: allConversations ?? this.allConversations,
    search: search ?? this.search,
    contacts: contacts ?? this.contacts,
    loadingContacts: loadingContacts ?? this.loadingContacts,
    error: identical(error, _keep) ? this.error : error as String?,
    onlineUserIds: onlineUserIds ?? this.onlineUserIds,
  );
}
