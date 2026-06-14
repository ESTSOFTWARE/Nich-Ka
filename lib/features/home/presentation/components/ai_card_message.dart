import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/theme/app_palette.dart';

class AiCardMessage extends StatelessWidget {
  final AppPalette palette;

  const AiCardMessage({super.key, required this.palette});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: GoogleFonts.poppins(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: palette.textPrimary,
          height: 1.5,
        ),
        children: [
          const TextSpan(text: 'Tu fermentación '),
          TextSpan(
            text: 'F-024',
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppPalette.accent,
              height: 1.5,
            ),
          ),
          const TextSpan(text: ' está en '),
          TextSpan(
            text: 'fase pico',
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppPalette.metricOrange,
              height: 1.5,
            ),
          ),
          const TextSpan(text: '. Revisa la temperatura.'),
        ],
      ),
    );
  }
}
