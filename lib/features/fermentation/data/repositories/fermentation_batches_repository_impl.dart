import '../../../home/domain/entities/fermentation_item.dart';
import '../../domain/repositories/fermentation_batches_repository.dart';
import '../datasource/remote/fermentation_batches_datasource.dart';
import '../datasource/remote/mapper/fermentation_batch_mapper.dart';

class FermentationBatchesRepositoryImpl
    implements FermentationBatchesRepository {
  final FermentationBatchesDatasource _dataSource;

  const FermentationBatchesRepositoryImpl(this._dataSource);

  @override
  Future<List<FermentationItem>> fetchBatches() async {
    final models = await _dataSource.fetchBatches();
    return models.map(FermentationBatchMapper.toEntity).toList();
  }
}
