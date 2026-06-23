import 'chat_member.dart';
import 'chat_message.dart';

class ChatConversation {
  final int id;
  final String type; // personal | group
  final String? name;
  final String? description;
  final String? avatar;
  final List<ChatMember> members;
  final ChatMessage? lastMessage;
  final int unreadCount;
  final DateTime createdAt;
  final int createdBy;

  const ChatConversation({
    required this.id,
    required this.type,
    required this.createdAt,
    required this.createdBy,
    this.name,
    this.description,
    this.avatar,
    this.members = const [],
    this.lastMessage,
    this.unreadCount = 0,
  });

  bool get hasUnread => unreadCount > 0;
  bool get isGroup => type == 'group';

  String displayName(int myId) {
    if (isGroup) return name ?? 'Grupo';
    final other = members.firstWhere(
      (m) => m.id != myId,
      orElse: () => members.isNotEmpty ? members.first : const ChatMember(id: 0, name: 'Chat', role: ''),
    );
    return other.name;
  }

  String? displayAvatar(int myId) {
    if (isGroup) return avatar;
    final other = members.firstWhere(
      (m) => m.id != myId,
      orElse: () => members.isNotEmpty ? members.first : const ChatMember(id: 0, name: '', role: ''),
    );
    return other.avatar;
  }

  ChatConversation copyWith({
    String? name,
    String? description,
    String? avatar,
    List<ChatMember>? members,
    ChatMessage? lastMessage,
    int? unreadCount,
  }) {
    return ChatConversation(
      id: id,
      type: type,
      name: name ?? this.name,
      description: description ?? this.description,
      avatar: avatar ?? this.avatar,
      members: members ?? this.members,
      lastMessage: lastMessage ?? this.lastMessage,
      unreadCount: unreadCount ?? this.unreadCount,
      createdAt: createdAt,
      createdBy: createdBy,
    );
  }
}
