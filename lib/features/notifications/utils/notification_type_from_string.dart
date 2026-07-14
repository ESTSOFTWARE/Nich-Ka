import '../domain/entities/notification_type.dart';

NotificationType notificationTypeFromString(String type) {
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
    case 'recommendation':
      return NotificationType.recommendation;
    case 'anomaly':
      return NotificationType.alert;
    case 'new_announcement':
    case 'member_added':
    case 'user_registered':
    case 'general':
      return NotificationType.recommendation;
    default:
      return NotificationType.recommendation;
  }
}
