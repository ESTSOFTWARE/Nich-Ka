import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/theme/app_palette.dart';
import '../../domain/entities/sensor_range.dart';
import 'sensor_range_bar_painter.dart';

class SensorRangeBar extends StatelessWidget {
  final SensorRange range;
  final double currentValue;
  final String unit;
  final Color color;
  final AppPalette palette;

  const SensorRangeBar({
    super.key,
    required this.range,
    required this.currentValue,
    required this.unit,
    required this.color,
    required this.palette,
  });

  String _fmt(double v) =>
      v % 1 == 0 ? '${v.toInt()}$unit' : '${v.toStringAsFixed(1)}$unit';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 10,
          width: double.infinity,
          child: CustomPaint(
            painter: SensorRangeBarPainter(
              min: range.min,
              max: range.max,
              optimalMin: range.optimalMin,
              optimalMax: range.optimalMax,
              currentValue: currentValue,
              color: color,
              trackColor: palette.border,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _fmt(range.min),
              style: GoogleFonts.poppins(
                fontSize: 11,
                color: palette.textMuted,
              ),
            ),
            Text(
              range.optimalLabel,
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
            Text(
              _fmt(range.max),
              style: GoogleFonts.poppins(
                fontSize: 11,
                color: palette.textMuted,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
