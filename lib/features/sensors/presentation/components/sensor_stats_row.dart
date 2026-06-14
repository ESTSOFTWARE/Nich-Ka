import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/theme/app_palette.dart';

class SensorStatsRow extends StatelessWidget {
  final double minValue;
  final double avgValue;
  final double maxValue;
  final String unit;
  final int decimals;
  final AppPalette palette;

  const SensorStatsRow({
    super.key,
    required this.minValue,
    required this.avgValue,
    required this.maxValue,
    required this.unit,
    required this.decimals,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StatTile(
          label: 'MÍNIMO',
          value: minValue.toStringAsFixed(decimals),
          unit: unit,
          palette: palette,
        ),
        const SizedBox(width: 10),
        _StatTile(
          label: 'PROMEDIO',
          value: avgValue.toStringAsFixed(decimals),
          unit: unit,
          palette: palette,
        ),
        const SizedBox(width: 10),
        _StatTile(
          label: 'MÁXIMO',
          value: maxValue.toStringAsFixed(decimals),
          unit: unit,
          palette: palette,
        ),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final AppPalette palette;

  const _StatTile({
    required this.label,
    required this.value,
    required this.unit,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        decoration: BoxDecoration(
          color: palette.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: palette.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 9,
                fontWeight: FontWeight.w600,
                color: palette.textMuted,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 4),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: value,
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: palette.textPrimary,
                      height: 1.1,
                    ),
                  ),
                  if (unit.isNotEmpty)
                    TextSpan(
                      text: ' $unit',
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
    );
  }
}
