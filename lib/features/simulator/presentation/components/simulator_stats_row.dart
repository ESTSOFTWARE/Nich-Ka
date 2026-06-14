import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/theme/app_palette.dart';

class SimulatorStatsRow extends StatelessWidget {
  final double efficiency;
  final double finalProduct;
  final AppPalette palette;

  const SimulatorStatsRow({
    super.key,
    required this.efficiency,
    required this.finalProduct,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'EFICIENCIA ESTIMADA',
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: palette.textSecondary,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${efficiency.toStringAsFixed(1)}%',
                style: GoogleFonts.poppins(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: AppPalette.accent,
                  height: 1.0,
                ),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'Producto final',
              style: GoogleFonts.poppins(
                fontSize: 11,
                color: palette.textSecondary,
              ),
            ),
            const SizedBox(height: 2),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: finalProduct.toStringAsFixed(1),
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: palette.textPrimary,
                    ),
                  ),
                  TextSpan(
                    text: ' g/L',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: palette.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
