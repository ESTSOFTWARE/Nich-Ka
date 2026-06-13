import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/home_palette.dart';

class SuggestionChip extends StatelessWidget {
  final String label;
  final HomePalette palette;
  final VoidCallback? onTap;

  const SuggestionChip({
    super.key,
    required this.label,
    required this.palette,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: palette.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: palette.border),
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: palette.textSecondary,
            height: 1.4,
          ),
        ),
      ),
    );
  }
}
