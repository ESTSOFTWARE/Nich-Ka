import '../repositories/chat_repository.dart';

class LeaveConversationUseCase {
  final ChatRepository _repo;
  const LeaveConversationUseCase(this._repo);
  Future<void> call(int conversationId) =>
      _repo.leaveConversation(conversationId);
}
