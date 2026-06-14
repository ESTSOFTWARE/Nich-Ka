import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/theme/app_palette.dart';

class AssistantEmptyState extends StatelessWidget {
  final AppPalette palette;

  const AssistantEmptyState({super.key, required this.palette});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppPalette.accent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppPalette.accent.withValues(alpha: 0.25),
              ),
            ),
            child: Center(
              child: SvgPicture.asset(
                'assets/icons/ia.svg',
                width: 32,
                height: 32,
                colorFilter: const ColorFilter.mode(
                  AppPalette.accent,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'Sin fermentaciones activas',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: palette.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Inicia una fermentación para recibir\nanálisis y recomendaciones en tiempo real.',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: palette.textSecondary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
