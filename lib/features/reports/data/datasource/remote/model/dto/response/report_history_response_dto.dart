class ReportHistoryResponseDto {
  final int id;
  final int reportId;
  final int userId;
  final String action;
  final String occurredAt;

  const ReportHistoryResponseDto({
    required this.id,
    required this.reportId,
    required this.userId,
    required this.action,
    required this.occurredAt,
  });

  factory ReportHistoryResponseDto.fromJson(Map<String, dynamic> json) =>
      ReportHistoryResponseDto(
        id: json['id'] as int,
        reportId: json['report_id'] as int,
        userId: json['user_id'] as int,
        action: json['action'] as String,
        occurredAt: json['occurred_at'] as String,
      );
}
