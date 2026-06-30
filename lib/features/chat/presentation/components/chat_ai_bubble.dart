import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/entities/chat_message.dart';
import '../../../../shared/theme/app_palette.dart';

class ChatAiBubble extends StatelessWidget {
  final ChatMessage message;
  final AppPalette palette;

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
          child: MarkdownBody(
            data: message.text,
            shrinkWrap: true,
            styleSheet: MarkdownStyleSheet(
              p: GoogleFonts.poppins(
                fontSize: 14,
                color: palette.textPrimary,
                height: 1.5,
              ),
              strong: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppPalette.accent,
                height: 1.5,
              ),
              em: GoogleFonts.poppins(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: palette.textPrimary,
                height: 1.5,
              ),
              listBullet: GoogleFonts.poppins(
                fontSize: 14,
                color: AppPalette.accent,
                height: 1.5,
              ),
              code: GoogleFonts.poppins(
                fontSize: 13,
                color: AppPalette.accent,
                backgroundColor: AppPalette.accent.withValues(alpha: 0.1),
              ),
              blockquoteDecoration: BoxDecoration(
                border: Border(
                  left: BorderSide(color: AppPalette.accent, width: 3),
                ),
              ),
              blockquote: GoogleFonts.poppins(
                fontSize: 14,
                color: palette.textSecondary,
                height: 1.5,
              ),
              h1: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: palette.textPrimary,
              ),
              h2: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: palette.textPrimary,
              ),
              h3: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: palette.textPrimary,
              ),
              pPadding: EdgeInsets.zero,
              blockSpacing: 6,
            ),
          ),
        ),
      ),
    );
  }
}
