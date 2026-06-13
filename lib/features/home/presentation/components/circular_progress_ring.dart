import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/home_palette.dart';
import 'ring_painter.dart';

class CircularProgressRing extends StatelessWidget {
  final double progress;
  final HomePalette palette;
  final double size;

  const CircularProgressRing({
    super.key,
    required this.progress,
    required this.palette,
    this.size = 72,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: RingPainter(progress: progress, palette: palette),
        child: Center(
          child: Text(
            '${(progress * 100).round()}%',
            style: GoogleFonts.poppins(
              fontSize: size * 0.2,
              fontWeight: FontWeight.bold,
              color: palette.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
