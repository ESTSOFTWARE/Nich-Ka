import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/reports_palette.dart';
import 'efficiency_ring_painter.dart';

class EfficiencyCard extends StatelessWidget {
  final double efficiency;
  final double ethanolDetected;
  final double ethanolTheoretical;
  final String duration;
  final ReportsPalette palette;

  const EfficiencyCard({
    super.key,
    required this.efficiency,
    required this.ethanolDetected,
    required this.ethanolTheoretical,
    required this.duration,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (efficiency / 100).clamp(0.0, 1.0);

    final baseStyle = GoogleFonts.poppins(
      fontSize: 12,
      color: palette.textSecondary,
    );
    final boldStyle = GoogleFonts.poppins(
      fontSize: 12,
      fontWeight: FontWeight.w700,
      color: palette.textPrimary,
    );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: palette.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 72,
            height: 72,
            child: CustomPaint(
              painter: EfficiencyRingPainter(
                progress: progress,
                color: ReportsPalette.accent,
                backgroundColor: palette.border,
              ),
              child: Center(
                child: Text(
                  '${efficiency.toStringAsFixed(1)}%',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: palette.textPrimary,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'EFICIENCIA',
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.8,
                    color: palette.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${efficiency.toStringAsFixed(1)}%',
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: palette.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                RichText(
                  text: TextSpan(
                    style: baseStyle,
                    children: [
                      const TextSpan(text: 'Etanol detectado '),
                      TextSpan(
                        text: '${ethanolDetected.toStringAsFixed(1)} %v/v',
                        style: boldStyle,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 2),
                RichText(
                  text: TextSpan(
                    style: baseStyle,
                    children: [
                      const TextSpan(text: 'Teórico '),
                      TextSpan(
                        text: '${ethanolTheoretical.toStringAsFixed(1)} %v/v',
                        style: boldStyle,
                      ),
                      const TextSpan(text: ' · Duración '),
                      TextSpan(text: duration, style: boldStyle),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
