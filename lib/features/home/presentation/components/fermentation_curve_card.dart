import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/entities/chart_point.dart';
import '../theme/home_palette.dart';
import 'chart_legend_item.dart';
import 'fermentation_chart.dart';
import 'time_range.dart';
import 'time_range_selector.dart';

class FermentationCurveCard extends StatelessWidget {
  final List<ChartPoint> points;
  final TimeRange selectedRange;
  final HomePalette palette;
  final ValueChanged<TimeRange> onRangeSelected;

  const FermentationCurveCard({
    super.key,
    required this.points,
    required this.selectedRange,
    required this.palette,
    required this.onRangeSelected,
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Curva de fermentación',
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: palette.textMuted,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Fermentación #F-024',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: palette.textPrimary,
                    ),
                  ),
                ],
              ),
              TimeRangeSelector(
                selected: selectedRange,
                palette: palette,
                onSelected: onRangeSelected,
              ),
            ],
          ),
          const SizedBox(height: 16),
          FermentationChart(points: points, height: 120),
          const SizedBox(height: 14),
          Row(
            children: [
              ChartLegendItem(
                dotColor: HomePalette.metricOrange,
                label: 'Temp 22.4°C',
                palette: palette,
              ),
              const SizedBox(width: 14),
              ChartLegendItem(
                dotColor: HomePalette.accent,
                label: 'Densidad 1.024',
                palette: palette,
              ),
              const SizedBox(width: 14),
              ChartLegendItem(
                dotColor: HomePalette.metricCyan,
                label: 'pH 4.20',
                palette: palette,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
