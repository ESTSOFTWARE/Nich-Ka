import 'dart:io';
import '../../domain/entities/chat_conversation.dart';
import '../../domain/entities/chat_member.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/entities/message_attachment.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasource/remote/chat_remote_datasource.dart';
import '../datasource/remote/mapper/chat_mapper.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource _ds;

  const ChatRepositoryImpl(this._ds);

  @override
  Future<List<ChatMember>> getContacts() async {
    final dtos = await _ds.getContacts();
    return dtos
        .map(
          (m) => ChatMember(
            id: m.id,
            name: m.name,
            role: m.role,
            avatar: m.avatar,
          ),
        )
        .toList();
  }

  @override
  Future<ChatConversation> createConversation({
    required String type,
    required List<int> memberIds,
    String? name,
  }) async {
    final request = ChatMapper.toCreateConversationRequest(
      type: type,
      memberIds: memberIds,
      name: name,
    );
    final dto = await _ds.createConversation(request);
    return ChatMapper.fromConversationDto(dto);
  }

  @override
  Future<List<ChatConversation>> getConversations() async {
    final dtos = await _ds.getConversations();
    return dtos.map(ChatMapper.fromConversationDto).toList();
  }

  @override
  Future<List<ChatMessage>> getMessages(
    int conversationId, {
    int? cursor,
  }) async {
    final dtos = await _ds.getMessages(conversationId, cursor: cursor);
    return dtos.map(ChatMapper.fromMessageDto).toList();
  }

  @override
  Future<ChatMessage> sendMessage(
    int conversationId, {
    String? content,
    List<MessageAttachment> attachments = const [],
    int? replyToId,
    List<int> mentions = const [],
  }) async {
    final request = ChatMapper.toSendMessageRequest(
      content: content,
      attachments: attachments,
      replyToId: replyToId,
      mentions: mentions,
    );
    final dto = await _ds.sendMessage(conversationId, request);
    return ChatMapper.fromMessageDto(dto);
  }

  @override
  Future<ChatMessage> editMessage(int messageId, String content) async {
    final request = ChatMapper.toEditMessageRequest(content);
    final dto = await _ds.editMessage(messageId, request);
    return ChatMapper.fromMessageDto(dto);
  }

  @override
  Future<void> deleteMessage(int messageId) => _ds.deleteMessage(messageId);

  @override
  Future<ChatMessage> toggleReaction(int messageId, String emoji) async {
    final request = ChatMapper.toToggleReactionRequest(emoji);
    final dto = await _ds.toggleReaction(messageId, request);
    return ChatMapper.fromMessageDto(dto);
  }

  @override
  Future<MessageAttachment> uploadFile(File file) async {
    final dto = await _ds.uploadFile(file);
    return ChatMapper.fromAttachmentDto(dto);
  }

  @override
  Future<void> markRead(int conversationId) => _ds.markRead(conversationId);

  @override
  Future<bool> pinMessage(int messageId) => _ds.pinMessage(messageId);

  @override
  Future<void> setPriority(int messageId, String priority) =>
      _ds.setPriority(messageId, priority);

  @override
  Future<void> leaveConversation(int conversationId) =>
      _ds.leaveConversation(conversationId);

  @override
  Future<void> updateConversation(
    int conversationId, {
    String? name,
    String? description,
  }) => _ds.updateConversation(
    conversationId,
    name: name,
    description: description,
  );
}
