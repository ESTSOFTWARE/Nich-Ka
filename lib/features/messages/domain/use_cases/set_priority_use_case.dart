import '../repositories/chat_repository.dart';

class SetPriorityUseCase {
  final ChatRepository _repo;
  const SetPriorityUseCase(this._repo);
  Future<void> call(int messageId, String priority) =>
      _repo.setPriority(messageId, priority);
}
