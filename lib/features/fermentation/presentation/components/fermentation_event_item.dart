import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/entities/fermentation_event.dart';
import '../../../home/presentation/theme/home_palette.dart';

class FermentationEventItem extends StatelessWidget {
  final FermentationEvent event;
  final HomePalette palette;

  const FermentationEventItem({
    super.key,
    required this.event,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          SizedBox(
            width: 40,
            child: Text(
              event.time,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: palette.textMuted,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: event.isAiSuggestion
                  ? HomePalette.accent
                  : palette.textMuted,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              event.description,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: palette.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
