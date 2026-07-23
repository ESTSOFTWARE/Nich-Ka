import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/entities/class_fermentation.dart';
import '../theme/class_palette.dart';

class ClassFermentationItem extends StatelessWidget {
  final ClassFermentation fermentation;
  final ClassPalette palette;

  /// En curso → overview en vivo; completada → reporte de la sesión.
  final VoidCallback? onTap;

  const ClassFermentationItem({
    super.key,
    required this.fermentation,
    required this.palette,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: fermentation.isActive
                    ? ClassPalette.accent
                    : palette.textMuted,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${fermentation.variety} · ${fermentation.process}',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: palette.textPrimary,
                    ),
                  ),
                  Text(
                    fermentation.id,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: palette.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (fermentation.isActive)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: ClassPalette.accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'En curso',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: ClassPalette.accent,
                  ),
                ),
              )
            else
              Text(
                'Completada',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: palette.textMuted,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
