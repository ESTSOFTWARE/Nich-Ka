import '../repositories/chat_repository.dart';

class UpdateConversationUseCase {
  final ChatRepository _repo;
  const UpdateConversationUseCase(this._repo);
  Future<void> call(int conversationId, {String? name, String? description}) =>
      _repo.updateConversation(
        conversationId,
        name: name,
        description: description,
      );
}
