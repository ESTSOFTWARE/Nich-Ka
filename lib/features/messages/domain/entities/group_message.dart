class GroupMessage {
  final int id;
  final String content;
  final String senderName;
  final int senderId;
  final bool isMe;
  final DateTime sentAt;
  final String? senderImage;

  const GroupMessage({
    required this.id,
    required this.content,
    required this.senderName,
    required this.senderId,
    required this.isMe,
    required this.sentAt,
    this.senderImage,
  });

  String get time {
    final h = sentAt.hour.toString().padLeft(2, '0');
    final m = sentAt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}
