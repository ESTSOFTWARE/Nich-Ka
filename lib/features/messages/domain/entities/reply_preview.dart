import 'message_attachment.dart';

class ReplyPreview {
  final int id;
  final String? content;
  final String senderName;
  final MessageAttachment? attachment;

  const ReplyPreview({
    required this.id,
    required this.senderName,
    this.content,
    this.attachment,
  });
}
