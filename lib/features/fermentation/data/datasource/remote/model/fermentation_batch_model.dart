import '../../../../../home/domain/entities/fermentation_item.dart';
import '../../../../utils/fermentation_progress.dart';
import '../../../../utils/fermentation_time_info.dart';
import '../../../../utils/status_color.dart';
import '../../../../utils/status_label.dart';
import 'dto/fermentation_batch_dto.dart';

class FermentationBatchModel {
  final int id;
  final int circuitId;
  final String status;
  final DateTime scheduledStart;
  final DateTime scheduledEnd;
  final DateTime? actualStart;
  final DateTime? actualEnd;
  final DateTime? createdAt;

  const FermentationBatchModel({
    required this.id,
    required this.circuitId,
    required this.status,
    required this.scheduledStart,
    required this.scheduledEnd,
    this.actualStart,
    this.actualEnd,
    this.createdAt,
  });

  factory FermentationBatchModel.fromDto(
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

  FermentationItem toEntity() {
    final now = DateTime.now();
    final displayId = 'F-$id';

    final label = statusLabelFor(status);
    final color = statusColorFor(status);

    return FermentationItem(
      id: displayId,
      name: displayId,
      process: '',
      farm: '',
      statusLabel: label,
      statusColor: color,
      timeInfo: formatTimeInfo(
        status,
        now,
        actualStart,
        scheduledStart,
        actualEnd,
        scheduledEnd,
      ),
      ringProgress: ringProgressFor(
        status,
        now,
        actualStart,
        scheduledStart,
        actualEnd,
        scheduledEnd,
      ),
      ringColor: color,
    );
  }
}
