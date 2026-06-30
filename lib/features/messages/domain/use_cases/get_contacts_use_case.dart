import '../entities/chat_member.dart';
import '../repositories/chat_repository.dart';

class GetContactsUseCase {
  final ChatRepository _repository;
  const GetContactsUseCase(this._repository);
  Future<List<ChatMember>> call() => _repository.getContacts();
}
