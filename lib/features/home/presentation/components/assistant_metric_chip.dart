import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/theme/app_palette.dart';

class AssistantMetricChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final AppPalette palette;

  const AssistantMetricChip({
    super.key,
    required this.label,
    required this.value,
    required this.color,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: palette.textMuted,
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }
}
