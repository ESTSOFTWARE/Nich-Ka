class GroupConversation {
  final int id;
  final String name;
  final String subject;
  final String? coverImage;
  final String lastMessage;
  final String lastSenderName;
  final String lastMessageTime;
  final int unreadCount;
  final int memberCount;

  const GroupConversation({
    required this.id,
    required this.name,
    required this.subject,
    required this.lastMessage,
    required this.lastSenderName,
    required this.lastMessageTime,
    required this.memberCount,
    this.coverImage,
    this.unreadCount = 0,
  });

  bool get hasUnread => unreadCount > 0;
}
