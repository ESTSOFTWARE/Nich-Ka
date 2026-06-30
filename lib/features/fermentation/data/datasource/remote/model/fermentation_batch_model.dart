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
}
