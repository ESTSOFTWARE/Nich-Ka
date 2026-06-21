import '../entities/sensor_realtime_reading.dart';
import '../repositories/sensors_realtime_repository.dart';

class WatchSensorsUseCase {
  final SensorsRealtimeRepository _repository;

  const WatchSensorsUseCase(this._repository);

  Stream<SensorRealtimeReading> call(int circuitId) =>
      _repository.watch(circuitId);
}
