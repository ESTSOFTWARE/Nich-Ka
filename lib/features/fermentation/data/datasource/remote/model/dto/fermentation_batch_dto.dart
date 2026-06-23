class FermentationBatchDto {
  final int id;
  final int circuitId;
  final int userId;
  final int? groupId;
  final int formulaId;
  final String scheduledStart;
  final String scheduledEnd;
  final String? actualStart;
  final String? actualEnd;
  final String status;
  final int? interruptedBy;
  final String? createdAt;

  const FermentationBatchDto({
    required this.id,
    required this.circuitId,
    required this.userId,
    this.groupId,
    required this.formulaId,
    required this.scheduledStart,
    required this.scheduledEnd,
    this.actualStart,
    this.actualEnd,
    required this.status,
    this.interruptedBy,
    this.createdAt,
  });

  factory FermentationBatchDto.fromJson(Map<String, dynamic> json) =>
      FermentationBatchDto(
        id: json['id'] as int? ?? 0,
        circuitId: json['circuit_id'] as int? ?? 0,
        userId: json['user_id'] as int? ?? 0,
        groupId: json['group_id'] as int?,
        formulaId: json['formula_id'] as int? ?? 0,
        scheduledStart: json['scheduled_start'] as String? ?? '',
        scheduledEnd: json['scheduled_end'] as String? ?? '',
        actualStart: json['actual_start'] as String?,
        actualEnd: json['actual_end'] as String?,
        status: json['status'] as String? ?? '',
        interruptedBy: json['interrupted_by'] as int?,
        createdAt: json['created_at'] as String?,
      );
}
