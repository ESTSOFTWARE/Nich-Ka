import '../repositories/chat_repository.dart';

class MarkReadUseCase {
  final ChatRepository _repo;
  const MarkReadUseCase(this._repo);
  Future<void> call(int conversationId) => _repo.markRead(conversationId);
}
