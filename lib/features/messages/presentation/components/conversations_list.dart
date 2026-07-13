import 'package:flutter/material.dart';
import '../../../../core/network/http_client.dart';
import '../../../../shared/theme/app_palette.dart';
import '../../domain/entities/chat_conversation.dart';
import 'conversation_card.dart';

class ConversationsList extends StatelessWidget {
  final List<ChatConversation> conversations;
  final AppPalette palette;
  final Set<int> onlineUserIds;
  final void Function(ChatConversation) onTap;

  const ConversationsList({
    super.key,
    required this.conversations,
    required this.palette,
    required this.onTap,
    this.onlineUserIds = const {},
  });

  @override
  Widget build(BuildContext context) {
    final myId = HttpClient.instance.userId;
    return Column(
      children: conversations.map((c) {
        final isLast = c == conversations.last;
        final otherId = c.members
            .where((m) => m.id != myId)
            .map((m) => m.id)
            .firstOrNull;
        final isOnline =
            !c.isGroup && otherId != null && onlineUserIds.contains(otherId);
        return Padding(
          padding: EdgeInsets.only(bottom: isLast ? 0 : 10),
          child: ConversationCard(
            conversation: c,
            myUserId: myId,
            palette: palette,
            isOnline: isOnline,
            onTap: () => onTap(c),
          ),
        );
      }).toList(),
    );
  }
}
