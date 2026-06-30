double calcProgress(
  DateTime now,
  DateTime? actualStart,
  DateTime scheduledStart,
  DateTime? actualEnd,
  DateTime scheduledEnd,
) {
  final start = actualStart ?? scheduledStart;
  final end = actualEnd ?? scheduledEnd;
  final total = end.difference(start).inSeconds;
  if (total <= 0) {
    return 0.0;
  }
  final elapsed = now.difference(start).inSeconds;
  return (elapsed / total).clamp(0.0, 1.0);
}

double ringProgressFor(
  String status,
  DateTime now,
  DateTime? actualStart,
  DateTime scheduledStart,
  DateTime? actualEnd,
  DateTime scheduledEnd,
) {
  return switch (status) {
    'completed' => 1.0,
    'running' || 'interrupted' => calcProgress(
      now,
      actualStart,
      scheduledStart,
      actualEnd,
      scheduledEnd,
    ),
    _ => 0.0,
  };
}
