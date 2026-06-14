import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/reports_palette.dart';

class ReportsErrorState extends StatelessWidget {
  final String message;
  final ReportsPalette palette;
  final VoidCallback? onRetry;

  const ReportsErrorState({
    super.key,
    required this.message,
    required this.palette,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: ReportsPalette.error.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: ReportsPalette.error.withValues(alpha: 0.25),
              ),
            ),
            child: const Center(
              child: Icon(
                Icons.error_outline,
                size: 28,
                color: ReportsPalette.error,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Ocurrió un error',
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: palette.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: palette.textSecondary,
              height: 1.6,
            ),
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 20),
            GestureDetector(
              onTap: onRetry,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: palette.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: palette.border),
                ),
                child: Text(
                  'Reintentar',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: palette.textPrimary,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
