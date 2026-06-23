import '../../../../domain/entities/chat_conversation.dart';
import '../../../../domain/entities/chat_member.dart';
import '../../../../domain/entities/chat_message.dart';
import '../../../../domain/entities/message_attachment.dart';
import '../../../../domain/entities/reply_preview.dart';
import '../model/dto/request/create_conversation_request_dto.dart';
import '../model/dto/request/edit_message_request_dto.dart';
import '../model/dto/request/send_message_request_dto.dart';
import '../model/dto/request/toggle_reaction_request_dto.dart';
import '../model/dto/response/attachment_dto.dart';
import '../model/dto/response/conversation_dto.dart';
import '../model/dto/response/message_dto.dart';

class ChatMapper {
  const ChatMapper._();

  // ── To request ───────────────────────────────────────────────────────────────

  static CreateConversationRequestDto toCreateConversationRequest({
    required String type,
    required List<int> memberIds,
    String? name,
  }) =>
      CreateConversationRequestDto(type: type, memberIds: memberIds, name: name);

  static SendMessageRequestDto toSendMessageRequest({
    String? content,
    List<AttachmentDto> attachments = const [],
    int? replyToId,
  }) =>
      SendMessageRequestDto(
        content: content,
        attachments: attachments.map((a) => a.toJson()).toList(),
        replyToId: replyToId,
      );

  static EditMessageRequestDto toEditMessageRequest(String content) =>
      EditMessageRequestDto(content: content);

  static ToggleReactionRequestDto toToggleReactionRequest(String emoji) =>
      ToggleReactionRequestDto(emoji: emoji);

  // ── From response ────────────────────────────────────────────────────────────

  static ChatMessage fromMessageDto(MessageDto dto) => ChatMessage(
        id: dto.id,
        conversationId: dto.conversationId,
        senderId: dto.senderId,
        senderName: dto.senderName,
        senderRole: dto.senderRole,
        content: dto.content,
        createdAt: dto.createdAt,
        read: dto.read,
        deleted: dto.deleted,
        edited: dto.edited,
        editedAt: dto.editedAt,
        pinned: dto.pinned,
        priority: dto.priority,
        attachments: dto.attachments.map(_fromAttachmentDto).toList(),
        replyTo: dto.replyTo != null ? _fromReplyPreviewDto(dto.replyTo!) : null,
        reactions: dto.reactions,
      );

  static ChatConversation fromConversationDto(ConversationDto dto) =>
      ChatConversation(
        id: dto.id,
        type: dto.type,
        name: dto.name,
        description: dto.description,
        avatar: dto.avatar,
        members: dto.members
            .map((m) => ChatMember(
                  id: m.id,
                  name: m.name,
                  role: m.role,
                  avatar: m.avatar,
                ))
            .toList(),
        lastMessage:
            dto.lastMessage != null ? fromMessageDto(dto.lastMessage!) : null,
        unreadCount: dto.unreadCount,
        createdAt: dto.createdAt,
        createdBy: dto.createdBy,
      );

  static MessageAttachment fromAttachmentDto(AttachmentDto dto) =>
      _fromAttachmentDto(dto);

  static MessageAttachment _fromAttachmentDto(AttachmentDto dto) =>
      MessageAttachment(
        id: dto.id,
        type: dto.type,
        name: dto.name,
        url: dto.url,
        size: dto.size,
      );

  static ReplyPreview _fromReplyPreviewDto(ReplyPreviewDto dto) => ReplyPreview(
        id: dto.id,
        content: dto.content,
        senderName: dto.senderName,
        attachment:
            dto.attachment != null ? _fromAttachmentDto(dto.attachment!) : null,
      );
}
