import 'notification_type.dart';

class NotificationItem {
  final int id;
  final String title;
  final String description;
  final String time;
  final NotificationType type;
  final bool isRead;
  final int? sessionId;

  const NotificationItem({
    required this.id,
    required this.title,
    required this.description,
    required this.time,
    required this.type,
    this.isRead = false,
    this.sessionId,
  });

  NotificationItem copyWith({bool? isRead, String? time}) => NotificationItem(
    id: id,
    title: title,
    description: description,
    time: time ?? this.time,
    type: type,
    isRead: isRead ?? this.isRead,
    sessionId: sessionId,
  );
}
