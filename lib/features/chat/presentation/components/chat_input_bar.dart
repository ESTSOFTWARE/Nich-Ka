import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/theme/app_palette.dart';

class ChatInputBar extends StatelessWidget {
  final AppPalette palette;

  const ChatInputBar({super.key, required this.palette});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 6, 6, 6),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: palette.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Pregunta a Nich-Ka...',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: palette.textMuted,
              ),
            ),
          ),
          Container(
            width: 34,
            height: 34,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppPalette.accent,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.arrow_forward,
              color: Colors.white,
              size: 16,
            ),
          ),
        ],
      ),
    );
  }
}
