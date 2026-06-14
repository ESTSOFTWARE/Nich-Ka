import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/theme/app_palette.dart';
import 'assistant_metric_chip.dart';

class ActiveFermentationSummary extends StatelessWidget {
  final AppPalette palette;

  const ActiveFermentationSummary({super.key, required this.palette});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: palette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
              const SizedBox(width: 8),
              Text(
                'F-024 · Caturra',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: palette.textPrimary,
                ),
              ),
              const Spacer(),
              Text(
                '18h 42m',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: palette.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              AssistantMetricChip(
                label: 'TEMP',
                value: '22.4°',
                color: AppPalette.metricOrange,
                palette: palette,
              ),
              AssistantMetricChip(
                label: 'PH',
                value: '4.20',
                color: AppPalette.metricCyan,
                palette: palette,
              ),
              AssistantMetricChip(
                label: 'DENS',
                value: '1.024',
                color: AppPalette.accent,
                palette: palette,
              ),
              AssistantMetricChip(
                label: 'ALC',
                value: '6.4%',
                color: AppPalette.metricRed,
                palette: palette,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
