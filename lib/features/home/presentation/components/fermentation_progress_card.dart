import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/entities/fermentation_card.dart';
import '../../../../shared/theme/app_palette.dart';
import 'progress_ring_painter.dart';

class FermentationProgressCard extends StatelessWidget {
  final FermentationCard card;
  final AppPalette palette;

  const FermentationProgressCard({
    super.key,
    required this.card,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: card.sessionId == null
          ? null
          : () => context.push('/report-detail', extra: card.sessionId),
      child: Container(
      width: 110,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: palette.border),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 52,
            height: 52,
            child: CustomPaint(
              painter: ProgressRingPainter(
                progress: card.progress,
                color: card.ringColor,
                trackColor: palette.border,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            card.id,
            style: GoogleFonts.poppins(
              fontSize: 10,
              color: palette.textMuted,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            card.name,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: palette.textPrimary,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            card.stage,
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: palette.textSecondary,
              height: 1.2,
            ),
          ),
        ],
      ),
      ),
    );
  }
}
