import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../domain/entities/sensor_metric.dart';
import '../theme/reports_palette.dart';

class MetricTile extends StatelessWidget {
  final SensorMetric metric;
  final ReportsPalette palette;

  const MetricTile({required this.metric, required this.palette});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: palette.rowSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: palette.border),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: metric.valueColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(metric.icon, size: 18, color: metric.valueColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  metric.label,
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
                        text: metric.lastValue,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: palette.textPrimary,
                          height: 1.2,
                        ),
                      ),
                      TextSpan(
                        text: ' ${metric.unit}',
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: palette.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
