import 'package:flutter/material.dart';
import '../theme/home_palette.dart';
import 'suggestion_chip.dart';

class SuggestionsGrid extends StatelessWidget {
  final List<String> suggestions;
  final HomePalette palette;

  const SuggestionsGrid({
    super.key,
    required this.suggestions,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: SuggestionChip(label: suggestions[0], palette: palette),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: SuggestionChip(label: suggestions[1], palette: palette),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: SuggestionChip(label: suggestions[2], palette: palette),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: SuggestionChip(label: suggestions[3], palette: palette),
            ),
          ],
        ),
      ],
    );
  }
}
