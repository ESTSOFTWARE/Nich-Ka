import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/entities/fermentation_card.dart';
import '../theme/home_palette.dart';
import 'fermentation_progress_card.dart';

class FermentationProgressList extends StatelessWidget {
  final List<FermentationCard> cards;
  final HomePalette palette;
  final int total;

  const FermentationProgressList({
    super.key,
    required this.cards,
    required this.palette,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Fermentaciones en curso',
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: palette.textPrimary,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: palette.rowSurface,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: palette.border),
              ),
              child: Text(
                '$total fermentaciones',
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  color: palette.textSecondary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: cards.map((card) {
              return Padding(
                padding: EdgeInsets.only(
                  right: card == cards.last ? 0 : 10,
                ),
                child: FermentationProgressCard(card: card, palette: palette),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
