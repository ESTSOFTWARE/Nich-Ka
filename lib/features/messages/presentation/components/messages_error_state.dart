import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/theme/app_palette.dart';

class MessagesErrorState extends StatelessWidget {
  final String? message;
  final VoidCallback onRetry;
  final AppPalette palette;

  const MessagesErrorState({
    super.key,
    required this.onRetry,
    required this.palette,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 40, color: palette.textMuted),
            const SizedBox(height: 12),
            Text(
              message ?? 'Error al cargar mensajes.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: palette.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: onRetry,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: AppPalette.accent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppPalette.accent.withValues(alpha: 0.4),
                  ),
                ),
                child: Text(
                  'Reintentar',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppPalette.accent,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
