import '../../../../../home/domain/entities/fermentation_item.dart';
import '../../../../utils/fermentation_progress.dart';
import '../../../../utils/fermentation_time_info.dart';
import '../../../../utils/status_color.dart';
import '../../../../utils/status_label.dart';
import '../model/dto/fermentation_batch_dto.dart';
import '../model/fermentation_batch_model.dart';

class FermentationBatchMapper {
  const FermentationBatchMapper._();

  static FermentationBatchModel fromDto(
    FermentationBatchDto dto,
  ) => FermentationBatchModel(
    id: dto.id,
    circuitId: dto.circuitId,
    status: dto.status,
    scheduledStart: DateTime.tryParse(dto.scheduledStart) ?? DateTime.now(),
    scheduledEnd: DateTime.tryParse(dto.scheduledEnd) ?? DateTime.now(),
    actualStart: dto.actualStart != null
        ? DateTime.tryParse(dto.actualStart!)
        : null,
    actualEnd: dto.actualEnd != null ? DateTime.tryParse(dto.actualEnd!) : null,
    createdAt: dto.createdAt != null ? DateTime.tryParse(dto.createdAt!) : null,
  );

  static FermentationItem toEntity(FermentationBatchModel model) {
    final now = DateTime.now();
    final displayId = 'F-${model.id}';

    final label = statusLabelFor(model.status);
    final color = statusColorFor(model.status);

    return FermentationItem(
      id: displayId,
      name: displayId,
      process: '',
      farm: '',
      statusLabel: label,
      statusColor: color,
      timeInfo: formatTimeInfo(
        model.status,
        now,
        model.actualStart,
        model.scheduledStart,
        model.actualEnd,
        model.scheduledEnd,
      ),
      ringProgress: ringProgressFor(
        model.status,
        now,
        model.actualStart,
        model.scheduledStart,
        model.actualEnd,
        model.scheduledEnd,
      ),
      ringColor: color,
      sessionId: model.id,
    );
  }
}
