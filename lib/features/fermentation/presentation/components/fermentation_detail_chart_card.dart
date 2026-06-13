import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../home/domain/entities/chart_point.dart';
import '../../../home/presentation/theme/home_palette.dart';
import '../../../home/presentation/components/fermentation_chart.dart';

class FermentationDetailChartCard extends StatelessWidget {
  final List<ChartPoint> points;
  final HomePalette palette;

  const FermentationDetailChartCard({
    super.key,
    required this.points,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: palette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Temperatura',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: palette.textPrimary,
                ),
              ),
              Text(
                'últimas 18h',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: palette.textMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          FermentationChart(points: points, height: 100),
        ],
      ),
    );
  }
}
