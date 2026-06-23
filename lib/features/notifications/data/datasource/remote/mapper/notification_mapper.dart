import '../model/dto/notification_dto.dart';
import '../model/dto/notification_event_dto.dart';
import '../model/notification_model.dart';

class NotificationMapper {
  const NotificationMapper._();

  static NotificationModel fromDto(NotificationDto dto) => NotificationModel(
    id: dto.id,
    message: dto.message,
    type: dto.type,
    isRead: dto.status == 'read',
    sessionId: dto.sessionId,
    createdAt: DateTime.tryParse(dto.createdAt) ?? DateTime.now(),
  );

  static NotificationModel fromEventDto(NotificationEventDto dto) =>
      NotificationModel(
        id: dto.notificationId,
        message: dto.message,
        type: dto.type,
        isRead: false,
        sessionId: dto.sessionId,
        createdAt: DateTime.tryParse(dto.occurredAt) ?? DateTime.now(),
      );
}
