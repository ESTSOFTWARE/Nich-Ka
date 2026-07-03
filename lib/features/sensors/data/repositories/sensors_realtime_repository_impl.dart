import '../../domain/entities/sensor_realtime_reading.dart';
import '../../domain/repositories/sensors_realtime_repository.dart';
import '../datasource/remote/sensors_realtime_datasource.dart';

class SensorsRealtimeRepositoryImpl implements SensorsRealtimeRepository {
  final SensorsRealtimeDataSource _dataSource;

  const SensorsRealtimeRepositoryImpl(this._dataSource);

  @override
  Future<int?> currentCircuitId() => _dataSource.fetchCircuitId();

  @override
  Stream<SensorRealtimeReading> watch(int circuitId) =>
      _dataSource.watch(circuitId);

  @override
  Stream<void> get onFermentationStopped => _dataSource.onFermentationStopped;

  @override
  Future<void> dispose() => _dataSource.dispose();
}
