import '../repositories/chat_repository.dart';

class DeleteMessageUseCase {
  final ChatRepository _repo;
  const DeleteMessageUseCase(this._repo);
  Future<void> call(int messageId) => _repo.deleteMessage(messageId);
}
