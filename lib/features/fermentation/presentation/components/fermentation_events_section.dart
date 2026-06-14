import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/entities/fermentation_event.dart';
import '../../../../shared/theme/app_palette.dart';
import 'fermentation_event_item.dart';

class FermentationEventsSection extends StatelessWidget {
  final List<FermentationEvent> events;
  final AppPalette palette;

  const FermentationEventsSection({
    super.key,
    required this.events,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Eventos recientes',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: palette.textPrimary,
          ),
        ),
        for (int i = 0; i < events.length; i++) ...[
          FermentationEventItem(event: events[i], palette: palette),
          if (i < events.length - 1) Divider(color: palette.border, height: 1),
        ],
      ],
    );
  }
}
