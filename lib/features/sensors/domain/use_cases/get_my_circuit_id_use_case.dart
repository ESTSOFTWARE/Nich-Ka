import '../repositories/sensors_realtime_repository.dart';

class GetMyCircuitIdUseCase {
  final SensorsRealtimeRepository _repository;

  const GetMyCircuitIdUseCase(this._repository);

  Future<int?> call() => _repository.currentCircuitId();
}
