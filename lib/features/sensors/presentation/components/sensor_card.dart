import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/theme/app_palette.dart';
import '../../domain/entities/sensor_reading.dart';
import 'sensor_sparkline_painter.dart';

class SensorCard extends StatelessWidget {
  final SensorReading reading;
  final AppPalette palette;
  final VoidCallback? onTap;

  const SensorCard({
    super.key,
    required this.reading,
    required this.palette,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = reading.color;
    final isDark = palette.isDark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              color.withValues(alpha: isDark ? 0.22 : 0.14),
              color.withValues(alpha: isDark ? 0.06 : 0.03),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withValues(alpha: isDark ? 0.25 : 0.18),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: isDark ? 0.25 : 0.18),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(reading.icon, color: color, size: 17),
                ),
                const SizedBox(width: 6),
                Icon(
                  reading.trendUp ? Icons.arrow_upward : Icons.arrow_downward,
                  color: palette.textMuted,
                  size: 14,
                ),
                const Spacer(),
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppPalette.accent,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              reading.label,
              style: GoogleFonts.poppins(
                fontSize: 11,
                color: palette.textSecondary,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  reading.displayValue,
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: color,
                    height: 1.1,
                  ),
                ),
                if (reading.unit.isNotEmpty) ...[
                  const SizedBox(width: 3),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 3),
                    child: Text(
                      reading.unit,
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: palette.textSecondary,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 30,
              child: CustomPaint(
                size: const Size(double.infinity, 30),
                painter: SensorSparklinePainter(
                  points: reading.history,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
