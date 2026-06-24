import '../entities/active_fermentation_session.dart';
import '../repositories/active_fermentation_repository.dart';

class GetActiveFermentationUseCase {
  final ActiveFermentationRepository _repository;

  const GetActiveFermentationUseCase(this._repository);

  Future<ActiveFermentationSession?> call() => _repository.getActive();
}
