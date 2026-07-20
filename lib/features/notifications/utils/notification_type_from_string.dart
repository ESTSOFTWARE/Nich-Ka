import '../domain/entities/notification_type.dart';

NotificationType notificationTypeFromString(String type) {
  switch (type) {
    case 'fermentation_started':
      return NotificationType.fermentation;
    case 'fermentation_complete':
      return NotificationType.completed;
    case 'experiment_complete':
      return NotificationType.analysis;
    case 'fermentation_interrupted':
    case 'high_temperature':
    case 'member_removed':
    case 'anomaly':
      return NotificationType.alert;
    case 'sensor_failure':
      return NotificationType.sensor;
    case 'recommendation':
      return NotificationType.recommendation;
    case 'efficiency':
      return NotificationType.prediction;
    case 'member_added':
      return NotificationType.group;
    case 'new_announcement':
      return NotificationType.announcement;
    case 'user_registered':
      return NotificationType.user;
    default:
      return NotificationType.general;
  }
}
