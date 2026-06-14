import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/theme/app_palette.dart';
import 'sensor_detail_chart_painter.dart';

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
              _WindowSelector(
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

class _WindowSelector extends StatelessWidget {
  final String selected;
  final Color color;
  final AppPalette palette;
  final ValueChanged<String> onChanged;

  const _WindowSelector({
    required this.selected,
    required this.color,
    required this.palette,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: ['1m', '5m', '1h'].map((w) {
        final active = w == selected;
        return GestureDetector(
          onTap: () => onChanged(w),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            margin: const EdgeInsets.only(left: 4),
            decoration: BoxDecoration(
              color: active
                  ? color.withValues(alpha: 0.15)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: active ? color : palette.border),
            ),
            child: Text(
              w,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: active ? FontWeight.w600 : FontWeight.normal,
                color: active ? color : palette.textMuted,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
