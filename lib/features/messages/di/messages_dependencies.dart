import '../../../core/network/http_client.dart';
import '../data/datasource/remote/chat_remote_datasource.dart';
import '../data/repositories/chat_repository_impl.dart';
import '../domain/use_cases/create_conversation_use_case.dart';
import '../domain/use_cases/delete_message_use_case.dart';
import '../domain/use_cases/edit_message_use_case.dart';
import '../domain/use_cases/get_contacts_use_case.dart';
import '../domain/use_cases/get_conversations_use_case.dart';
import '../domain/use_cases/get_messages_use_case.dart';
import '../domain/use_cases/leave_conversation_use_case.dart';
import '../domain/use_cases/mark_read_use_case.dart';
import '../domain/use_cases/pin_message_use_case.dart';
import '../domain/use_cases/send_message_use_case.dart';
import '../domain/use_cases/set_priority_use_case.dart';
import '../domain/use_cases/toggle_reaction_use_case.dart';
import '../domain/use_cases/update_conversation_use_case.dart';
import '../domain/use_cases/upload_file_use_case.dart';

class MessagesDependencies {
  MessagesDependencies._();

  static final ChatRemoteDataSource _dataSource = ChatRemoteDataSource(
    HttpClient.instance,
  );

  static final ChatRepositoryImpl _repository = ChatRepositoryImpl(_dataSource);

  static GetConversationsUseCase get getConversations =>
      GetConversationsUseCase(_repository);

  static GetContactsUseCase get getContacts => GetContactsUseCase(_repository);

  static GetMessagesUseCase get getMessages => GetMessagesUseCase(_repository);

  static SendMessageUseCase get sendMessage => SendMessageUseCase(_repository);

  static EditMessageUseCase get editMessage => EditMessageUseCase(_repository);

  static DeleteMessageUseCase get deleteMessage =>
      DeleteMessageUseCase(_repository);

  static CreateConversationUseCase get createConversation =>
      CreateConversationUseCase(_repository);

  static MarkReadUseCase get markRead => MarkReadUseCase(_repository);

  static ToggleReactionUseCase get toggleReaction =>
      ToggleReactionUseCase(_repository);

  static PinMessageUseCase get pinMessage => PinMessageUseCase(_repository);

  static SetPriorityUseCase get setPriority => SetPriorityUseCase(_repository);

  static UpdateConversationUseCase get updateConversation =>
      UpdateConversationUseCase(_repository);

  static LeaveConversationUseCase get leaveConversation =>
      LeaveConversationUseCase(_repository);

  static UploadFileUseCase get uploadFile => UploadFileUseCase(_repository);
}
