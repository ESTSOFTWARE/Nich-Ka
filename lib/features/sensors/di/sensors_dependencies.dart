import '../../../core/network/http_client.dart';
import '../data/datasource/remote/sensors_realtime_datasource.dart';
import '../data/repositories/sensors_realtime_repository_impl.dart';
import '../domain/use_cases/get_my_circuit_id_use_case.dart';
import '../domain/use_cases/watch_sensors_use_case.dart';

class SensorsDependencies {
  SensorsDependencies._();

  static final SensorsRealtimeDataSource _dataSource =
      SensorsRealtimeDataSource(HttpClient.instance);

  static final SensorsRealtimeRepositoryImpl _repository =
      SensorsRealtimeRepositoryImpl(_dataSource);

  static GetMyCircuitIdUseCase get getCircuitId =>
      GetMyCircuitIdUseCase(_repository);

  static WatchSensorsUseCase get watch => WatchSensorsUseCase(_repository);
}
