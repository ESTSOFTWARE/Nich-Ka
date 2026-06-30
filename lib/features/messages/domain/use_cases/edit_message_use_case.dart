import '../entities/chat_message.dart';
import '../repositories/chat_repository.dart';

class EditMessageUseCase {
  final ChatRepository _repo;
  const EditMessageUseCase(this._repo);
  Future<ChatMessage> call(int messageId, String content) =>
      _repo.editMessage(messageId, content);
}
