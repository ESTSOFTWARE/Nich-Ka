import '../../../../domain/entities/notification_item.dart';
import '../../../../utils/format_time.dart';
import '../../../../utils/notification_type_from_string.dart';
import '../../../../utils/title_for_type.dart';

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
