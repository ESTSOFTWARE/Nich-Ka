import '../../../home/domain/entities/fermentation_item.dart';
import '../repositories/fermentation_batches_repository.dart';

class GetFermentationBatchesUseCase {
  final FermentationBatchesRepository _repository;

  const GetFermentationBatchesUseCase(this._repository);

  Future<List<FermentationItem>> call() => _repository.fetchBatches();
}
