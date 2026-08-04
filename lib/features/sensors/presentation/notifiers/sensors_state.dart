import '../../domain/entities/sensor_reading.dart';
import '../../domain/entities/sensors_status.dart';

class SensorsState {
  final bool isScrolled;
  final List<SensorReading> readings;
  final SensorsStatus status;

  const SensorsState({
    this.isScrolled = false,
    this.readings = const [],
    this.status = const SensorsStatus(
      online: 6,
      total: 6,
      allInRange: true,
      statusLabel: 'Todo en rango óptimo',
      fermentationId: 'F-024',
      variety: 'Caturra',
    ),
  });

  SensorsState copyWith({bool? isScrolled, List<SensorReading>? readings}) =>
      SensorsState(
        isScrolled: isScrolled ?? this.isScrolled,
        readings: readings ?? this.readings,
        status: status,
      );
}
