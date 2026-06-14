import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/entities/fermentation_item.dart';
import '../../../../shared/theme/app_palette.dart';
import 'progress_ring_painter.dart';

class FermentationListItem extends StatelessWidget {
  final FermentationItem item;
  final AppPalette palette;
  final VoidCallback? onTap;

  const FermentationListItem({
    super.key,
    required this.item,
    required this.palette,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: palette.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: palette.border),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 44,
              height: 44,
              child: CustomPaint(
                painter: ProgressRingPainter(
                  progress: item.ringProgress,
                  color: item.ringColor,
                  trackColor: palette.border,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '${item.name} · ${item.process}',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: palette.textPrimary,
                          ),
                        ),
                        TextSpan(
                          text: ' · ${item.id}',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: palette.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.farm,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: palette.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  item.statusLabel,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: item.statusColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.timeInfo,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: palette.textMuted,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
