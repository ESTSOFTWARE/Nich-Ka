class FermentationSessionResponseDto {
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
  final String? interruptedBy;
  final String createdAt;

  const FermentationSessionResponseDto({
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
    required this.createdAt,
  });

  factory FermentationSessionResponseDto.fromJson(Map<String, dynamic> json) =>
      FermentationSessionResponseDto(
        id: json['id'] as int,
        circuitId: json['circuit_id'] as int,
        userId: json['user_id'] as int,
        groupId: json['group_id'] as int?,
        formulaId: json['formula_id'] as int,
        scheduledStart: json['scheduled_start'] as String,
        scheduledEnd: json['scheduled_end'] as String,
        actualStart: json['actual_start'] as String?,
        actualEnd: json['actual_end'] as String?,
        status: json['status'] as String,
        interruptedBy: json['interrupted_by'] as String?,
        createdAt: json['created_at'] as String,
      );
}
