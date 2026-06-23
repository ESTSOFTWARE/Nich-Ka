import '../entities/chat_message.dart';
import '../repositories/chat_repository.dart';

class GetMessagesUseCase {
  final ChatRepository _repo;
  const GetMessagesUseCase(this._repo);
  Future<List<ChatMessage>> call(int conversationId, {int? cursor}) =>
      _repo.getMessages(conversationId, cursor: cursor);
}
