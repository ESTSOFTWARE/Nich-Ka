import 'dart:math' as math;
import '../../domain/entities/sensor_range.dart';
import '../../domain/entities/sensor_reading.dart';

class SensorDetailState {
  final SensorReading reading;
  final String window;
  final bool isScrolled;

  const SensorDetailState({
    required this.reading,
    this.window = '1m',
    this.isScrolled = false,
  });

  SensorRange get range => SensorRange.forId(reading.id);
  List<double> get chartPoints => reading.history;
  double get minValue => reading.history.reduce(math.min);
  double get maxValue => reading.history.reduce(math.max);
  double get avgValue {
    final sum = reading.history.fold<double>(0, (a, b) => a + b);
    return sum / reading.history.length;
  }

  bool get isInRange => range.isInRange(reading.rawValue);

  String get aiInsight => isInRange
      ? '${reading.label} se mantiene estable dentro del rango óptimo. Sin anomalías en la última hora.'
      : '${reading.label} está fuera del rango óptimo. Revisa las condiciones del tanque.';

  SensorDetailState copyWith({
    SensorReading? reading,
    String? window,
    bool? isScrolled,
  }) => SensorDetailState(
    reading: reading ?? this.reading,
    window: window ?? this.window,
    isScrolled: isScrolled ?? this.isScrolled,
  );
}
