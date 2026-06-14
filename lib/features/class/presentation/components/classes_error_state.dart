import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/class_palette.dart';

class ClassesErrorState extends StatelessWidget {
  final String message;
  final ClassPalette palette;
  final VoidCallback? onRetry;

  const ClassesErrorState({
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
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: ClassPalette.error.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: ClassPalette.error.withValues(alpha: 0.25),
              ),
            ),
            child: const Center(
              child: Icon(
                Icons.error_outline,
                size: 32,
                color: ClassPalette.error,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Ocurrió un error',
            style: GoogleFonts.poppins(
              fontSize: 16,
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
            const SizedBox(height: 24),
            GestureDetector(
              onTap: onRetry,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: palette.surface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: palette.border),
                ),
                child: Text(
                  'Reintentar',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
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
