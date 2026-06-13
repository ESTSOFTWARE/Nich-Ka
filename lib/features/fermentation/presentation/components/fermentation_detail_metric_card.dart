import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../home/domain/entities/fermentation_metric.dart';
import '../../../home/presentation/theme/home_palette.dart';

class FermentationDetailMetricCard extends StatelessWidget {
  final FermentationMetric metric;
  final HomePalette palette;

  const FermentationDetailMetricCard({
    super.key,
    required this.metric,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: palette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            metric.label,
            style: GoogleFonts.poppins(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: palette.textMuted,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 4),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: metric.value,
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: metric.color,
                    height: 1.1,
                  ),
                ),
                if (metric.unit.isNotEmpty)
                  TextSpan(
                    text: ' ${metric.unit}',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: palette.textSecondary,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 2),
          Text(
            metric.change,
            style: GoogleFonts.poppins(fontSize: 11, color: palette.textMuted),
          ),
        ],
      ),
    );
  }
}
