import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/reports_palette.dart';

class ReportsEmptyState extends StatelessWidget {
  final ReportsPalette palette;

  const ReportsEmptyState({super.key, required this.palette});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.45,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: ReportsPalette.accent.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: ReportsPalette.accent.withValues(alpha: 0.25),
              ),
            ),
            child: const Center(
              child: Icon(
                Icons.description_outlined,
                size: 28,
                color: ReportsPalette.accent,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Sin reportes en este período',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: palette.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Cuando completes una fermentación\nse generará su reporte aquí.',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: palette.textSecondary,
              height: 1.6,
            ),
          ),
          ],
        ),
      ),
    );
  }
}
