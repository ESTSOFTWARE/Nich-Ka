import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/reports_palette.dart';

class ReportHeader extends StatelessWidget {
  final String reportNumber;
  final String fermentationCode;
  final String batchName;
  final String date;
  final ReportsPalette palette;
  final VoidCallback? onDownloadPdf;

  const ReportHeader({
    super.key,
    required this.reportNumber,
    required this.fermentationCode,
    required this.batchName,
    required this.date,
    required this.palette,
    this.onDownloadPdf,
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Reporte #$reportNumber',
                      style: GoogleFonts.poppins(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: palette.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: ReportsPalette.accent.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: ReportsPalette.accent.withValues(alpha: 0.4),
                        ),
                      ),
                      child: Text(
                        'PDF',
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: ReportsPalette.accent,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  '$fermentationCode · $batchName · $date',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: palette.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onDownloadPdf,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: ReportsPalette.accent.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: ReportsPalette.accent.withValues(alpha: 0.4),
                ),
              ),
              child: Icon(
                Icons.download_outlined,
                size: 20,
                color: ReportsPalette.accent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
