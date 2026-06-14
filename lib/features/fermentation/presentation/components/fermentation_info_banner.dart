import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/theme/app_palette.dart';

class FermentationInfoBanner extends StatelessWidget {
  final AppPalette palette;

  const FermentationInfoBanner({super.key, required this.palette});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: palette.border),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, size: 16, color: palette.textMuted),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Solo visualización. Los controles los gestiona el supervisor.',
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: palette.textSecondary,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
