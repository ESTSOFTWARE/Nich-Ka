import '../../../home/domain/entities/fermentation_item.dart';

abstract class FermentationBatchesRepository {
  Future<List<FermentationItem>> fetchBatches();
}
