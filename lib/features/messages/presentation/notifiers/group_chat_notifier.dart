import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/chat_conversation.dart';
import '../providers/group_chat_provider.dart';

export '../providers/group_chat_provider.dart';

/// Argumentos de la family: la conversación abierta + el mensaje a resaltar.
/// Igualdad por id de conversación para que Riverpod cachee correctamente.
class GroupChatArgs {
  final ChatConversation conversation;
  final int? highlightMessageId;

  const GroupChatArgs(this.conversation, {this.highlightMessageId});

  @override
  bool operator ==(Object other) =>
      other is GroupChatArgs &&
      other.conversation.id == conversation.id &&
      other.highlightMessageId == highlightMessageId;

  @override
  int get hashCode => Object.hash(conversation.id, highlightMessageId);
}

/// El chat de grupo mantiene mucho estado mutable (mensajes, typing, WebSocket,
/// reacciones, edición…). Se expone vía ChangeNotifierProvider de Riverpod para
/// conservar la lógica existente. autoDispose: se libera al salir del chat.
final groupChatProvider = ChangeNotifierProvider.autoDispose
    .family<GroupChatProvider, GroupChatArgs>(
      (ref, args) => GroupChatProvider(
        args.conversation,
        highlightMessageId: args.highlightMessageId,
      ),
    );
