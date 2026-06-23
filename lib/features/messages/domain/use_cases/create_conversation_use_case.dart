import '../entities/chat_conversation.dart';
import '../repositories/chat_repository.dart';

class CreateConversationUseCase {
  final ChatRepository _repository;
  const CreateConversationUseCase(this._repository);

  Future<ChatConversation> call({
    required String type,
    required List<int> memberIds,
    String? name,
  }) => _repository.createConversation(
    type: type,
    memberIds: memberIds,
    name: name,
  );
}
