class NotificationDto {
  final int id;
  final int userId;
  final String message;
  final String type;
  final String status;
  final int? sessionId;
  final String createdAt;

  const NotificationDto({
    required this.id,
    required this.userId,
    required this.message,
    required this.type,
    required this.status,
    this.sessionId,
    required this.createdAt,
  });

  factory NotificationDto.fromJson(Map<String, dynamic> json) =>
      NotificationDto(
        id: json['id'] as int? ?? 0,
        userId: json['user_id'] as int? ?? 0,
        message: json['message'] as String? ?? '',
        type: json['type'] as String? ?? '',
        status: json['status'] as String? ?? 'unread',
        sessionId: json['session_id'] as int?,
        createdAt: json['created_at'] as String? ?? '',
      );
}
