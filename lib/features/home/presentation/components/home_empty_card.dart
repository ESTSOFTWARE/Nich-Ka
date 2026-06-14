import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/theme/app_palette.dart';

class HomeEmptyCard extends StatelessWidget {
  final AppPalette palette;
  final VoidCallback? onJoinClass;

  const HomeEmptyCard({super.key, required this.palette, this.onJoinClass});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DashedBorderPainter(color: palette.border),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Image.asset('assets/img/nich-ka-animado.png', height: 150),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: const BoxDecoration(
                      color: AppPalette.accent,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.add, size: 16, color: Colors.black),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Aún no hay fermentaciones',
              style: GoogleFonts.poppins(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: palette.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Únete a una clase con el código que te dio tu '
              'profesor para empezar a monitorear las fermentaciones '
              'en tiempo real.',
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: palette.textSecondary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: onJoinClass ?? () {},
                icon: const Icon(Icons.add, size: 18),
                label: Text(
                  'Unirme a una clase',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: AppPalette.accent,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  final Color color;
  _DashedBorderPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    const radius = Radius.circular(16);
    const dashLen = 6.0;
    const gapLen = 4.0;

    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          radius,
        ),
      );

    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final a = metric.getTangentForOffset(distance);
        final b = metric.getTangentForOffset(distance + dashLen);
        if (a != null && b != null) {
          canvas.drawLine(a.position, b.position, paint);
        }
        distance += dashLen + gapLen;
      }
    }
  }

  @override
  bool shouldRepaint(_DashedBorderPainter old) => old.color != color;
}
