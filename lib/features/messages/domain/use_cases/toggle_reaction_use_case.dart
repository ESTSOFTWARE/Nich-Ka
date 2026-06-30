import '../entities/chat_message.dart';
import '../repositories/chat_repository.dart';

class ToggleReactionUseCase {
  final ChatRepository _repo;
  const ToggleReactionUseCase(this._repo);
  Future<ChatMessage> call(int messageId, String emoji) =>
      _repo.toggleReaction(messageId, emoji);
}
