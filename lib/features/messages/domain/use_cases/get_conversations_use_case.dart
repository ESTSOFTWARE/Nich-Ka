import '../entities/chat_conversation.dart';
import '../repositories/chat_repository.dart';

class GetConversationsUseCase {
  final ChatRepository _repo;
  const GetConversationsUseCase(this._repo);
  Future<List<ChatConversation>> call() => _repo.getConversations();
}
