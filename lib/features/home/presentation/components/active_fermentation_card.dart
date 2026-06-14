import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/entities/active_fermentation.dart';
import '../../../../shared/theme/app_palette.dart';
import 'circular_progress_ring.dart';
import 'fermentation_chart.dart';
import 'metrics_grid.dart';
import 'time_label.dart';

class ActiveFermentationCard extends StatelessWidget {
  final ActiveFermentation fermentation;
  final AppPalette palette;
  final String elapsedFormatted;
  final String objectiveFormatted;

  const ActiveFermentationCard({
    super.key,
    required this.fermentation,
    required this.palette,
    required this.elapsedFormatted,
    required this.objectiveFormatted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: palette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppPalette.accent,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'EN FERMENTACIÓN',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppPalette.accent,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
                Text(
                  'Fermentación #${fermentation.id}',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: palette.textMuted,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        fermentation.title,
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: palette.textPrimary,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        fermentation.location,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: palette.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          TimeLabel(
                            label: 'TIEMPO',
                            value: elapsedFormatted,
                            palette: palette,
                          ),
                          const SizedBox(width: 24),
                          TimeLabel(
                            label: 'OBJETIVO',
                            value: objectiveFormatted,
                            palette: palette,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                CircularProgressRing(
                  progress: fermentation.progressPercent,
                  palette: palette,
                  size: 76,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: FermentationChart(points: fermentation.chartPoints),
          ),
          const SizedBox(height: 4),
          Divider(color: palette.border, height: 1),
          MetricsGrid(fermentation: fermentation, palette: palette),
        ],
      ),
    );
  }
}
