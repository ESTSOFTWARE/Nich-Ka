import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/theme/app_palette.dart';

class EfficiencyResultCard extends StatelessWidget {
  final double? efficiency;
  final String substitutedFormula;
  final AppPalette palette;

  const EfficiencyResultCard({
    super.key,
    required this.efficiency,
    required this.substitutedFormula,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: palette.aiCardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: palette.aiCardBorder),
      ),
      child: Column(
        children: [
          Text(
            'EFICIENCIA',
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppPalette.accent,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            efficiency != null ? '${efficiency!.toStringAsFixed(1)}%' : '—',
            style: GoogleFonts.poppins(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: AppPalette.accent,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            substitutedFormula,
            style: GoogleFonts.sourceCodePro(
              fontSize: 12,
              color: palette.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
