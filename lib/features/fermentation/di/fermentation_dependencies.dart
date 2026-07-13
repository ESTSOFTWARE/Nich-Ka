import '../../../core/network/http_client.dart';
import '../data/datasource/remote/active_fermentation_datasource.dart';
import '../data/datasource/remote/fermentation_batches_datasource.dart';
import '../data/repositories/active_fermentation_repository_impl.dart';
import '../data/repositories/fermentation_batches_repository_impl.dart';
import '../domain/use_cases/get_active_fermentation_use_case.dart';
import '../domain/use_cases/get_fermentation_batches_use_case.dart';

class FermentationDependencies {
  FermentationDependencies._();

  static final ActiveFermentationDatasource _activeDatasource =
      ActiveFermentationDatasource(HttpClient.instance);

  static final FermentationBatchesDatasource _batchesDatasource =
      FermentationBatchesDatasource(HttpClient.instance);

  static final ActiveFermentationRepositoryImpl _activeRepository =
      ActiveFermentationRepositoryImpl(_activeDatasource);

  static final FermentationBatchesRepositoryImpl _batchesRepository =
      FermentationBatchesRepositoryImpl(_batchesDatasource);

  static GetActiveFermentationUseCase get getActive =>
      GetActiveFermentationUseCase(_activeRepository);

  static GetFermentationBatchesUseCase get getBatches =>
      GetFermentationBatchesUseCase(_batchesRepository);
}
