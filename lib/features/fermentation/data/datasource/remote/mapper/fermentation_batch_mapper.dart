import '../model/dto/fermentation_batch_dto.dart';
import '../model/fermentation_batch_model.dart';

class FermentationBatchMapper {
  const FermentationBatchMapper._();

  static FermentationBatchModel fromDto(FermentationBatchDto dto) =>
      FermentationBatchModel.fromDto(dto);
}
