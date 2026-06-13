import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/home_palette.dart';

class ChatInputField extends StatelessWidget {
  final HomePalette palette;

  const ChatInputField({super.key, required this.palette});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: palette.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: palette.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: 'Pregunta a Nich-Ka...',
                hintStyle: GoogleFonts.poppins(
                  fontSize: 13,
                  color: palette.textMuted,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Icon(
              Icons.south_rounded,
              size: 18,
              color: palette.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
