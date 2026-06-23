import '../repositories/chat_repository.dart';

class PinMessageUseCase {
  final ChatRepository _repo;
  const PinMessageUseCase(this._repo);
  Future<bool> call(int messageId) => _repo.pinMessage(messageId);
}
