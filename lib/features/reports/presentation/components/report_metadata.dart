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

  Widget _dot(ReportsPalette p) => Container(
    width: 3,
    height: 3,
    decoration: BoxDecoration(color: palette.textMuted, shape: BoxShape.circle),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: palette.border),
      ),
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 8,
        runSpacing: 6,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.schedule_outlined, size: 14, color: palette.textMuted),
              const SizedBox(width: 4),
              Text(
                'Generado $generatedAt',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: palette.textSecondary,
                ),
              ),
            ],
          ),
          _dot(palette),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.download_outlined, size: 14, color: palette.textMuted),
              const SizedBox(width: 4),
              Text(
                '$downloads descargas',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: palette.textSecondary,
                ),
              ),
            ],
          ),
          if (views > 0) ...[
            _dot(palette),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.visibility_outlined,
                  size: 14,
                  color: palette.textMuted,
                ),
                const SizedBox(width: 4),
                Text(
                  '$views visualizaciones',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: palette.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
