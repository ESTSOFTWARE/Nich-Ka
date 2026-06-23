import 'dart:io';
import '../entities/chat_conversation.dart';
import '../entities/chat_message.dart';
import '../entities/message_attachment.dart';

import '../entities/chat_member.dart';

abstract class ChatRepository {
  Future<List<ChatMember>> getContacts();
  Future<ChatConversation> createConversation({
    required String type,
    required List<int> memberIds,
    String? name,
  });
  Future<List<ChatConversation>> getConversations();
  Future<List<ChatMessage>> getMessages(int conversationId, {int? cursor});
  Future<ChatMessage> sendMessage(
    int conversationId, {
    String? content,
    List<MessageAttachment> attachments,
    int? replyToId,
  });
  Future<ChatMessage> editMessage(int messageId, String content);
  Future<void> deleteMessage(int messageId);
  Future<ChatMessage> toggleReaction(int messageId, String emoji);
  Future<MessageAttachment> uploadFile(File file);
  Future<void> markRead(int conversationId);
  Future<bool> pinMessage(int messageId);
  Future<void> setPriority(int messageId, String priority);
  Future<void> leaveConversation(int conversationId);
  Future<void> updateConversation(int conversationId, {String? name, String? description});
}
