import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/entities/chat_message.dart';
import '../../../../shared/theme/app_palette.dart';

class ChatRecommendationBubble extends StatelessWidget {
  final ChatMessage message;
  final AppPalette palette;

  const ChatRecommendationBubble({
    super.key,
    required this.message,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.78,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: palette.aiCardBg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: palette.aiCardBorder),
          ),
          child: Text(
            message.text,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: palette.textPrimary,
              height: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}
