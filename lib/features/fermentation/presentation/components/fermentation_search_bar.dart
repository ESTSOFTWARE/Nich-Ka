import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/theme/app_palette.dart';

class FermentationSearchBar extends StatelessWidget {
  final AppPalette palette;

  const FermentationSearchBar({super.key, required this.palette});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: palette.border),
      ),
      child: Row(
        children: [
          Icon(Icons.search, size: 18, color: palette.textMuted),
          const SizedBox(width: 8),
          Text(
            'Buscar fermentación, variedad...',
            style: GoogleFonts.poppins(fontSize: 13, color: palette.textMuted),
          ),
        ],
      ),
    );
  }
}
