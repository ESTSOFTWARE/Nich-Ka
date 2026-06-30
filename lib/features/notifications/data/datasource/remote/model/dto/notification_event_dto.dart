class NotificationEventDto {
  final String type;
  final int notificationId;
  final String message;
  final int? sessionId;
  final String occurredAt;

  const NotificationEventDto({
    required this.type,
    required this.notificationId,
    required this.message,
    this.sessionId,
    required this.occurredAt,
  });

  factory NotificationEventDto.fromJson(Map<String, dynamic> json) =>
      NotificationEventDto(
        type: json['type'] as String? ?? '',
        notificationId: json['notification_id'] as int? ?? 0,
        message: json['message'] as String? ?? '',
        sessionId: json['session_id'] as int?,
        occurredAt: json['occurred_at'] as String? ?? '',
      );
}
