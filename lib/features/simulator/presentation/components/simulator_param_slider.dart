import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/theme/app_palette.dart';

class SimulatorParamSlider extends StatelessWidget {
  final String symbol;
  final String subscript;
  final String description;
  final double value;
  final double min;
  final double max;
  final String unit;
  final int decimals;
  final AppPalette palette;
  final ValueChanged<double> onChanged;

  const SimulatorParamSlider({
    super.key,
    required this.symbol,
    required this.subscript,
    required this.description,
    required this.value,
    required this.min,
    required this.max,
    required this.unit,
    required this.decimals,
    required this.palette,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: symbol,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: palette.textPrimary,
                    ),
                  ),
                  WidgetSpan(
                    alignment: PlaceholderAlignment.bottom,
                    child: Text(
                      subscript,
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: palette.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                description,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: palette.textSecondary,
                ),
              ),
            ),
            Text(
              '${value.toStringAsFixed(decimals)} $unit',
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppPalette.accent,
              ),
            ),
          ],
        ),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: AppPalette.accent,
            inactiveTrackColor: palette.border,
            thumbColor: AppPalette.accent,
            trackHeight: 4,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
            overlayColor: AppPalette.accent.withValues(alpha: 0.15),
          ),
          child: Slider(
            value: value.clamp(min, max),
            min: min,
            max: max,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
