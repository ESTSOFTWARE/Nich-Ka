String titleForType(String type) {
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
    case 'recommendation':
      return 'Recomendación IA';
    case 'anomaly':
      return 'Anomalía detectada';
    case 'general':
      return 'Notificación';
    default:
      return 'Notificación';
  }
}
