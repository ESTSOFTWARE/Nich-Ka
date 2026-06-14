import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/entities/sensor_metric.dart';
import '../theme/reports_palette.dart';

class SensorsMetricsCard extends StatelessWidget {
  final List<SensorMetric> metrics;
  final ReportsPalette palette;

  const SensorsMetricsCard({
    super.key,
    required this.metrics,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: palette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'SENSORES',
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
              color: palette.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          _buildHeaderRow(),
          const SizedBox(height: 8),
          for (var i = 0; i < metrics.length; i++) ...[
            _buildMetricRow(metrics[i]),
            if (i < metrics.length - 1) const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }

  Widget _buildHeaderRow() {
    final headerStyle = GoogleFonts.poppins(
      fontSize: 10,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.6,
      color: palette.textMuted,
    );

    return Row(
      children: [
        Expanded(flex: 3, child: Text('SENSOR', style: headerStyle)),
        Expanded(
          flex: 2,
          child: Text(
            'INICIAL',
            textAlign: TextAlign.right,
            style: headerStyle,
          ),
        ),
        Expanded(
          flex: 2,
          child: Text('FINAL', textAlign: TextAlign.right, style: headerStyle),
        ),
        Expanded(
          flex: 2,
          child: Text('ÚLTIMA', textAlign: TextAlign.right, style: headerStyle),
        ),
      ],
    );
  }

  Widget _buildMetricRow(SensorMetric metric) {
    final valueStyle = GoogleFonts.poppins(
      fontSize: 13,
      color: palette.textPrimary,
    );
    final boldValueStyle = GoogleFonts.poppins(
      fontSize: 13,
      fontWeight: FontWeight.w700,
      color: palette.textPrimary,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 3,
          child: Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: metric.valueColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  metric.label,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: palette.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            metric.initialValue,
            textAlign: TextAlign.right,
            style: valueStyle,
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            metric.finalValue,
            textAlign: TextAlign.right,
            style: valueStyle,
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            metric.lastValue,
            textAlign: TextAlign.right,
            style: boldValueStyle,
          ),
        ),
      ],
    );
  }
}
