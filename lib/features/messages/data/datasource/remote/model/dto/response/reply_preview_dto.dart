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
