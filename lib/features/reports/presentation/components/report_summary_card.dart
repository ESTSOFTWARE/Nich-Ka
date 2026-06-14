import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/reports_palette.dart';

class ReportSummaryCard extends StatelessWidget {
  final String label;
  final String value;
  final ReportsPalette palette;

  const ReportSummaryCard({
    super.key,
    required this.label,
    required this.value,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: palette.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: palette.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label.toUpperCase(),
              style: GoogleFonts.poppins(
                fontSize: 9,
                fontWeight: FontWeight.w600,
                color: palette.textMuted,
                letterSpacing: 0.6,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: palette.textPrimary,
                height: 1.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
