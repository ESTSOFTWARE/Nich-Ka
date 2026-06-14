import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/theme/app_palette.dart';

class FormulaCard extends StatelessWidget {
  final AppPalette palette;

  const FormulaCard({super.key, required this.palette});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: palette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Fórmula activa',
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: palette.textSecondary,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: palette.aiCardBg,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: palette.aiCardBorder),
            ),
            child: Text(
              'eficiencia = (etanol / (azúcar_inicial × 0.51)) × 100',
              style: GoogleFonts.sourceCodePro(
                fontSize: 13,
                color: AppPalette.accent,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
