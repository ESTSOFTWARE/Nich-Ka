import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/entities/chat_message.dart';
import '../../../home/presentation/theme/home_palette.dart';

class ChatAiBubble extends StatelessWidget {
  final ChatMessage message;
  final HomePalette palette;

  const ChatAiBubble({super.key, required this.message, required this.palette});

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
            color: palette.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: palette.border),
          ),
          child: _buildText(),
        ),
      ),
    );
  }

  Widget _buildText() {
    final base = GoogleFonts.poppins(
      fontSize: 14,
      color: palette.textPrimary,
      height: 1.5,
    );
    if (message.highlightId == null) {
      return Text(message.text, style: base);
    }
    final parts = message.text.split(message.highlightId!);
    return RichText(
      text: TextSpan(
        style: base,
        children: [
          for (int i = 0; i < parts.length; i++) ...[
            TextSpan(text: parts[i]),
            if (i < parts.length - 1)
              TextSpan(
                text: message.highlightId!,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: HomePalette.accent,
                  height: 1.5,
                ),
              ),
          ],
        ],
      ),
    );
  }
}
