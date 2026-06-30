String formatDate(DateTime dt) {
  return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}';
}

String formatTimeInfo(
  String status,
  DateTime now,
  DateTime? actualStart,
  DateTime scheduledStart,
  DateTime? actualEnd,
  DateTime scheduledEnd,
) {
  switch (status) {
    case 'scheduled':
      return 'Inicia ${formatDate(scheduledStart)}';
    case 'running':
      final start = actualStart ?? scheduledStart;
      final elapsed = now.difference(start);
      if (elapsed.inDays > 0) {
        final total = scheduledEnd.difference(scheduledStart).inDays;
        return 'Día ${elapsed.inDays + 1} / ${total + 1}';
      }
      if (elapsed.inHours > 0) {
        return '${elapsed.inHours}h ${elapsed.inMinutes % 60}m';
      }
      return '${elapsed.inMinutes}m';
    case 'completed':
      final end = actualEnd ?? scheduledEnd;
      final diff = now.difference(end);
      if (diff.inDays > 0) {
        return 'Hace ${diff.inDays}d';
      }
      if (diff.inHours > 0) {
        return 'Hace ${diff.inHours}h';
      }
      return 'Ahora';
    case 'interrupted':
      return 'Interrumpido';
    default:
      return '';
  }
}
