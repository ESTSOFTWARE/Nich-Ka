import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/theme/app_palette.dart';
import 'sensor_detail_chart_painter.dart';
import 'sensor_window_selector.dart';

class SensorDetailChart extends StatelessWidget {
  final List<double> points;
  final Color color;
  final String selectedWindow;
  final ValueChanged<String> onWindowChanged;
  final AppPalette palette;

  const SensorDetailChart({
    super.key,
    required this.points,
    required this.color,
    required this.selectedWindow,
    required this.onWindowChanged,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
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
                'Tiempo real',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: palette.textPrimary,
                ),
              ),
              SensorWindowSelector(
                selected: selectedWindow,
                color: color,
                palette: palette,
                onChanged: onWindowChanged,
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 120,
            width: double.infinity,
            child: CustomPaint(
              painter: SensorDetailChartPainter(
                points: points,
                color: color,
                gridColor: palette.border,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
