import 'attachment_dto.dart';

class ReplyPreviewDto {
  final int id;
  final String? content;
  final String senderName;
  final AttachmentDto? attachment;

  const ReplyPreviewDto({
    required this.id,
    required this.senderName,
    this.content,
    this.attachment,
  });

  factory ReplyPreviewDto.fromJson(Map<String, dynamic> json) =>
      ReplyPreviewDto(
        id: json['id'] as int,
        senderName: json['senderName'] as String,
        content: json['content'] as String?,
        attachment: json['attachment'] != null
            ? AttachmentDto.fromJson(json['attachment'] as Map<String, dynamic>)
            : null,
      );
}

class MessageDto {
  final int id;
  final int conversationId;
  final int senderId;
  final String senderName;
  final String senderRole;
  final String? content;
  final DateTime createdAt;
  final bool read;
  final bool deleted;
  final bool edited;
  final DateTime? editedAt;
  final bool pinned;
  final String priority;
  final List<AttachmentDto> attachments;
  final ReplyPreviewDto? replyTo;
  final Map<String, List<int>> reactions;

  const MessageDto({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.senderName,
    required this.senderRole,
    required this.createdAt,
    this.content,
    this.read = false,
    this.deleted = false,
    this.edited = false,
    this.editedAt,
    this.pinned = false,
    this.priority = 'normal',
    this.attachments = const [],
    this.replyTo,
    this.reactions = const {},
  });

  factory MessageDto.fromJson(Map<String, dynamic> json) {
    final rawReactions = (json['reactions'] as Map<String, dynamic>?) ?? {};
    final reactions = rawReactions.map(
      (emoji, ids) => MapEntry(
        emoji,
        (ids as List<dynamic>).map((id) => id as int).toList(),
      ),
    );
    return MessageDto(
      id: json['id'] as int,
      conversationId: json['conversationId'] as int,
      senderId: json['senderId'] as int,
      senderName: json['senderName'] as String,
      senderRole: json['senderRole'] as String,
      content: json['content'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      read: json['read'] as bool? ?? false,
      deleted: json['deleted'] as bool? ?? false,
      edited: json['edited'] as bool? ?? false,
      editedAt: json['editedAt'] != null
          ? DateTime.parse(json['editedAt'] as String)
          : null,
      pinned: json['pinned'] as bool? ?? false,
      priority: json['priority'] as String? ?? 'normal',
      attachments: (json['attachments'] as List<dynamic>? ?? [])
          .map((a) => AttachmentDto.fromJson(a as Map<String, dynamic>))
          .toList(),
      replyTo: json['replyTo'] != null
          ? ReplyPreviewDto.fromJson(json['replyTo'] as Map<String, dynamic>)
          : null,
      reactions: reactions,
    );
  }
}
