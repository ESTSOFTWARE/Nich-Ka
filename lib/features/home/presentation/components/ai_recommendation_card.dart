import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/entities/ai_recommendation.dart';
import '../theme/home_palette.dart';

class AiRecommendationCard extends StatelessWidget {
  final AiRecommendation recommendation;
  final HomePalette palette;
  final VoidCallback? onAction;

  const AiRecommendationCard({
    super.key,
    required this.recommendation,
    required this.palette,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: palette.aiCardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: palette.aiCardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: HomePalette.accent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    'assets/icons/ia.svg',
                    width: 18,
                    height: 18,
                    colorFilter: const ColorFilter.mode(
                      HomePalette.accent,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'RECOMENDACIÓN IA',
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: HomePalette.accent,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            recommendation.body,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: palette.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: onAction,
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: palette.border),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              recommendation.actionLabel,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: palette.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
