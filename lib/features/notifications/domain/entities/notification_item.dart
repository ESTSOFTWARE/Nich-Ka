import 'notification_type.dart';

class NotificationItem {
  final String id;
  final String title;
  final String description;
  final String time;
  final NotificationType type;
  final bool isRead;

  const NotificationItem({
    required this.id,
    required this.title,
    required this.description,
    required this.time,
    required this.type,
    this.isRead = false,
  });

  NotificationItem copyWith({bool? isRead}) => NotificationItem(
    id: id,
    title: title,
    description: description,
    time: time,
    type: type,
    isRead: isRead ?? this.isRead,
  );
}
