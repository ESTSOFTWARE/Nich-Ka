import 'package:flutter/material.dart';
import '../../../../core/network/http_client.dart';
import '../../../../shared/theme/app_palette.dart';
import '../../domain/entities/chat_conversation.dart';
import 'conversation_card.dart';

class ConversationsList extends StatelessWidget {
  final List<ChatConversation> conversations;
  final AppPalette palette;
  final void Function(ChatConversation) onTap;

  const ConversationsList({
    super.key,
    required this.conversations,
    required this.palette,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: conversations.map((c) {
        final isLast = c == conversations.last;
        return Padding(
          padding: EdgeInsets.only(bottom: isLast ? 0 : 10),
          child: ConversationCard(
            conversation: c,
            myUserId: HttpClient.instance.userId,
            palette: palette,
            onTap: () => onTap(c),
          ),
        );
      }).toList(),
    );
  }
}
