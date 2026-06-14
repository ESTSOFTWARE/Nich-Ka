import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/theme/app_palette.dart';

class SensorAiInsight extends StatelessWidget {
  final String text;
  final bool inRange;
  final AppPalette palette;

  const SensorAiInsight({
    super.key,
    required this.text,
    required this.inRange,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = inRange
        ? AppPalette.accent.withValues(alpha: palette.isDark ? 0.25 : 0.3)
        : Colors.red.withValues(alpha: 0.3);
    final bgColor = inRange
        ? AppPalette.accent.withValues(alpha: palette.isDark ? 0.08 : 0.1)
        : Colors.red.withValues(alpha: palette.isDark ? 0.08 : 0.06);
    final iconColor = inRange ? AppPalette.accent : Colors.red[400]!;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.auto_awesome, color: iconColor, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: palette.textPrimary,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
