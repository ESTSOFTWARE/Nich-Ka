import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/reports_palette.dart';

class ReportMetadata extends StatelessWidget {
  final String generatedAt;
  final int downloads;
  final int views;
  final ReportsPalette palette;

  const ReportMetadata({
    super.key,
    required this.generatedAt,
    required this.downloads,
    required this.views,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: palette.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.schedule_outlined, size: 14, color: palette.textMuted),
          const SizedBox(width: 6),
          Text(
            'Generado $generatedAt',
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: palette.textSecondary,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Container(
              width: 3,
              height: 3,
              decoration: BoxDecoration(
                color: palette.textMuted,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Icon(Icons.download_outlined, size: 14, color: palette.textMuted),
          const SizedBox(width: 4),
          Text(
            '$downloads descargas',
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: palette.textSecondary,
            ),
          ),
          if (views > 0) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Container(
                width: 3,
                height: 3,
                decoration: BoxDecoration(
                  color: palette.textMuted,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Icon(Icons.visibility_outlined, size: 14, color: palette.textMuted),
            const SizedBox(width: 4),
            Text(
              '$views visualizaciones',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: palette.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
