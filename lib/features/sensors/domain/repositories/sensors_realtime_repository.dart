import '../entities/sensor_realtime_reading.dart';

abstract class SensorsRealtimeRepository {
  Future<int?> currentCircuitId();

  Stream<SensorRealtimeReading> watch(int circuitId);
  
  Future<void> dispose();
}
