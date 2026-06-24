import '../../../../domain/entities/notification_item.dart';
import '../../../../utils/notification_utils.dart';

class NotificationModel {
  final int id;
  final String message;
  final String type;
  final bool isRead;
  final int? sessionId;
  final DateTime createdAt;

  const NotificationModel({
    required this.id,
    required this.message,
    required this.type,
    required this.isRead,
    this.sessionId,
    required this.createdAt,
  });

  NotificationItem toEntity() {
    return NotificationItem(
      id: id,
      title: titleForType(type),
      description: message,
      time: formatTime(createdAt),
      type: notificationTypeFromString(type),
      isRead: isRead,
      sessionId: sessionId,
    );
  }
}
