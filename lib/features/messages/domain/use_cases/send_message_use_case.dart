import '../entities/chat_message.dart';
import '../entities/message_attachment.dart';
import '../repositories/chat_repository.dart';

class SendMessageUseCase {
  final ChatRepository _repo;
  const SendMessageUseCase(this._repo);
  Future<ChatMessage> call(
    int conversationId, {
    String? content,
    List<MessageAttachment> attachments = const [],
    int? replyToId,
    List<int> mentions = const [],
  }) => _repo.sendMessage(
    conversationId,
    content: content,
    attachments: attachments,
    replyToId: replyToId,
    mentions: mentions,
  );
}
