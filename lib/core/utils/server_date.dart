/// Convierte una fecha del backend a hora local.
///
/// El backend envía las fechas en UTC; si vienen sin zona horaria las
/// interpretamos como UTC (agregando 'Z') antes de pasar a local. Así la hora
/// mostrada coincide con la del dispositivo (antes salía 6 horas adelantada).
DateTime parseServerDate(String s) {
  final hasTz = s.endsWith('Z') || RegExp(r'[+-]\d{2}:?\d{2}$').hasMatch(s);
  return DateTime.parse(hasTz ? s : '${s}Z').toLocal();
}

/// Formatea una hora local en 12 horas con a. m. / p. m. (ej. "12:04 a. m.").
String formatTime12h(DateTime local) {
  final minute = local.minute.toString().padLeft(2, '0');
  final suffix = local.hour < 12 ? 'a. m.' : 'p. m.';
  var hour = local.hour % 12;
  if (hour == 0) hour = 12;
  return '$hour:$minute $suffix';
}
