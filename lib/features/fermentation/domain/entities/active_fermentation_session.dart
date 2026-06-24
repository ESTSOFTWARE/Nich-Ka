/// Sesión de fermentación activa (lo que devuelve GET /fermentation/active).
/// El backend solo entrega metadata de la sesión; los datos en vivo
/// (temperatura, pH, alcohol, etc.) llegan por el WebSocket de sensores.
class ActiveFermentationSession {
  final int id;
  final int circuitId;
  final int? groupId;
  final DateTime scheduledStart; // UTC
  final DateTime scheduledEnd; // UTC
  final DateTime? actualStart; // UTC
  final String status;

  const ActiveFermentationSession({
    required this.id,
    required this.circuitId,
    this.groupId,
    required this.scheduledStart,
    required this.scheduledEnd,
    this.actualStart,
    required this.status,
  });

  /// Identificador del lote que se muestra en la UI (ej. "Lote #24").
  String get loteLabel => 'Lote #$id';

  DateTime get _start => actualStart ?? scheduledStart;

  /// Tiempo transcurrido desde que arrancó la fermentación.
  Duration get elapsed {
    final now = DateTime.now().toUtc();
    return now.isAfter(_start) ? now.difference(_start) : Duration.zero;
  }

  /// Duración objetivo (de inicio real/programado a fin programado).
  Duration get objective {
    final diff = scheduledEnd.difference(_start);
    return diff.isNegative ? Duration.zero : diff;
  }

  /// Progreso 0.0–1.0 respecto al objetivo.
  double get progress {
    final total = objective.inSeconds;
    if (total <= 0) return 0;
    return (elapsed.inSeconds / total).clamp(0.0, 1.0);
  }

  bool get isRunning => status == 'running';
}
