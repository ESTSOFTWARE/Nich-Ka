import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/entities/nlp_analysis.dart';
import '../theme/reports_palette.dart';

class NlpAnalysisCard extends StatelessWidget {
  final NlpAnalysis analysis;
  final ReportsPalette palette;

  const NlpAnalysisCard({
    super.key,
    required this.analysis,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ReportsPalette.accent.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: ReportsPalette.accent.withValues(alpha: 0.35),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.auto_awesome, size: 16, color: ReportsPalette.accent),
              const SizedBox(width: 8),
              Text(
                'ANÁLISIS NLP',
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                  color: ReportsPalette.accent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _buildRichText(analysis.summary),
        ],
      ),
    );
  }

  /// Renders text with **bold** markers as inline bold spans.
  Widget _buildRichText(String content) {
    final spans = <TextSpan>[];
    final regex = RegExp(r'\*\*(.*?)\*\*');
    int lastEnd = 0;

    for (final match in regex.allMatches(content)) {
      if (match.start > lastEnd) {
        spans.add(TextSpan(text: content.substring(lastEnd, match.start)));
      }
      spans.add(
        TextSpan(
          text: match.group(1),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      );
      lastEnd = match.end;
    }
    if (lastEnd < content.length) {
      spans.add(TextSpan(text: content.substring(lastEnd)));
    }

    return RichText(
      text: TextSpan(
        style: GoogleFonts.poppins(
          fontSize: 13,
          color: palette.textPrimary,
          height: 1.6,
        ),
        children: spans,
      ),
    );
  }
}
