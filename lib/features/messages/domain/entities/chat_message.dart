import 'message_attachment.dart';
import 'reply_preview.dart';

class ChatMessage {
  final int id;
  final int conversationId;
  final int senderId;
  final String senderName;
  final String senderRole;
  final String? senderAvatar;
  final String? content;
  final DateTime createdAt;
  final bool read;
  final String status; // sent | delivered | read (para MIS mensajes)
  final bool deleted;
  final bool edited;
  final DateTime? editedAt;
  final bool pinned;
  final String priority; // normal | important | urgent
  final List<MessageAttachment> attachments;
  final ReplyPreview? replyTo;
  final Map<String, List<int>> reactions; // emoji → [userId, ...]

  const ChatMessage({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.senderName,
    required this.senderRole,
    required this.createdAt,
    this.senderAvatar,
    this.content,
    this.read = false,
    this.status = 'sent',
    this.deleted = false,
    this.edited = false,
    this.editedAt,
    this.pinned = false,
    this.priority = 'normal',
    this.attachments = const [],
    this.replyTo,
    this.reactions = const {},
  });

  String get time {
    final h = createdAt.hour.toString().padLeft(2, '0');
    final m = createdAt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  bool get isImportant => priority == 'important' || priority == 'urgent';
  bool get isUrgent => priority == 'urgent';

  ChatMessage copyWith({
    String? content,
    bool? edited,
    DateTime? editedAt,
    bool? deleted,
    bool? pinned,
    String? priority,
    Map<String, List<int>>? reactions,
    String? status,
  }) {
    return ChatMessage(
      id: id,
      conversationId: conversationId,
      senderId: senderId,
      senderName: senderName,
      senderRole: senderRole,
      senderAvatar: senderAvatar,
      createdAt: createdAt,
      content: content ?? this.content,
      read: read,
      status: status ?? this.status,
      deleted: deleted ?? this.deleted,
      edited: edited ?? this.edited,
      editedAt: editedAt ?? this.editedAt,
      pinned: pinned ?? this.pinned,
      priority: priority ?? this.priority,
      attachments: attachments,
      replyTo: replyTo,
      reactions: reactions ?? this.reactions,
    );
  }
}
