class ClassItem {
  final String id;
  final String name;
  final String subject;
  final String professor;
  final int studentCount;
  final String lastActivity;
  final bool hasUnread;
  final int unreadCount;
  final String? imageUrl;

  const ClassItem({
    required this.id,
    required this.name,
    required this.subject,
    required this.professor,
    required this.studentCount,
    required this.lastActivity,
    this.hasUnread = false,
    this.unreadCount = 0,
    this.imageUrl,
  });
}
