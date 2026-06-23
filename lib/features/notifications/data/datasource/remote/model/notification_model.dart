import '../../../../domain/entities/notification_item.dart';
import '../../../../domain/entities/notification_type.dart';

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
      title: _titleForType(type),
      description: message,
      time: _formatTime(createdAt),
      type: _notificationTypeFromString(type),
      isRead: isRead,
      sessionId: sessionId,
    );
  }

  static String _titleForType(String type) {
    switch (type) {
      case 'fermentation_complete':
        return 'Fermentación completada';
      case 'fermentation_interrupted':
        return 'Fermentación interrumpida';
      case 'high_temperature':
        return 'Alerta de temperatura';
      case 'sensor_failure':
        return 'Fallo de sensor';
      case 'new_announcement':
        return 'Nuevo anuncio';
      case 'member_added':
        return 'Miembro agregado';
      case 'member_removed':
        return 'Miembro eliminado';
      case 'user_registered':
        return 'Usuario registrado';
      case 'experiment_complete':
        return 'Experimento completado';
      case 'general':
        return 'Notificación';
      default:
        return 'Notificación';
    }
  }

  static NotificationType _notificationTypeFromString(String type) {
    switch (type) {
      case 'fermentation_complete':
        return NotificationType.completed;
      case 'experiment_complete':
        return NotificationType.analysis;
      case 'fermentation_interrupted':
      case 'high_temperature':
      case 'member_removed':
        return NotificationType.alert;
      case 'sensor_failure':
        return NotificationType.sensor;
      case 'new_announcement':
      case 'member_added':
      case 'user_registered':
      case 'general':
        return NotificationType.recommendation;
      default:
        return NotificationType.recommendation;
    }
  }

  static String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inSeconds < 60) return 'ahora';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    if (diff.inDays < 7) return '${diff.inDays}d';
    return '${diff.inDays ~/ 7}s';
  }
}
