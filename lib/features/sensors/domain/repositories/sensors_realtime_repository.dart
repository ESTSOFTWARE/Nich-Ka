import '../entities/sensor_realtime_reading.dart';

abstract class SensorsRealtimeRepository {
  Future<int?> currentCircuitId();

  Stream<SensorRealtimeReading> watch(int circuitId);

  /// Emite cuando el backend detiene la fermentación (WS, sin polling).
  Stream<void> get onFermentationStopped;

  Future<void> dispose();
}
