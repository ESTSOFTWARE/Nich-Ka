import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/theme/app_palette.dart';

class AiCardWelcomeMessage extends StatelessWidget {
  final AppPalette palette;

  const AiCardWelcomeMessage({super.key, required this.palette});

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
          const TextSpan(text: '¡Hola! Cuando inicies tu primera '),
          TextSpan(
            text: 'fermentación',
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppPalette.accent,
              height: 1.5,
            ),
          ),
          const TextSpan(text: ' te acompañaré en tiempo real.'),
        ],
      ),
    );
  }
}
