import 'package:flutter/material.dart';
import '../../../../shared/theme/app_palette.dart';
import 'ai_card_header.dart';
import 'ai_card_message.dart';
import 'ai_card_welcome_message.dart';
import 'chat_input_field.dart';
import 'suggestions_grid.dart';

class AiMessageCard extends StatelessWidget {
  final List<String> suggestions;
  final AppPalette palette;
  final bool hasActiveFermentation;

  const AiMessageCard({
    super.key,
    this.suggestions = const [],
    required this.palette,
    this.hasActiveFermentation = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppPalette.accent.withValues(alpha: 0.55),
            palette.aiCardBorder,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(1.5),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: palette.aiCardBg,
          borderRadius: BorderRadius.circular(14.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AiCardHeader(palette: palette),
            const SizedBox(height: 14),
            if (hasActiveFermentation)
              AiCardMessage(palette: palette)
            else
              AiCardWelcomeMessage(palette: palette),
            const SizedBox(height: 14),
            if (hasActiveFermentation)
              SuggestionsGrid(suggestions: suggestions, palette: palette),
            if (hasActiveFermentation) const SizedBox(height: 12),
            ChatInputField(palette: palette),
          ],
        ),
      ),
    );
  }
}
