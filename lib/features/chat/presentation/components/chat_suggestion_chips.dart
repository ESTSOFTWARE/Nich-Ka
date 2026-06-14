import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/theme/app_palette.dart';

class ChatSuggestionChips extends StatelessWidget {
  final List<String> chips;
  final AppPalette palette;

  const ChatSuggestionChips({
    super.key,
    required this.chips,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: chips.map((chip) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: palette.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: palette.border),
              ),
              child: Text(
                chip,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: palette.textSecondary,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
