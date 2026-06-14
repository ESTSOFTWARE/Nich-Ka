import 'package:flutter/material.dart';

class SensorSparklinePainter extends CustomPainter {
  final List<double> points;
  final Color color;

  const SensorSparklinePainter({required this.points, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;

    final minVal = points.reduce((a, b) => a < b ? a : b);
    final maxVal = points.reduce((a, b) => a > b ? a : b);
    final range = maxVal - minVal;

    double norm(double v) {
      if (range == 0) return size.height / 2;
      return size.height -
          ((v - minVal) / range) * size.height * 0.8 -
          size.height * 0.1;
    }

    final path = Path();
    final step = size.width / (points.length - 1);

    for (var i = 0; i < points.length; i++) {
      final x = i * step;
      final y = norm(points[i]);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        final px = (i - 1) * step;
        final py = norm(points[i - 1]);
        final cpx = (px + x) / 2;
        path.cubicTo(cpx, py, cpx, y, x, y);
      }
    }

    canvas.drawPath(
      path,
      Paint()
        ..color = color.withValues(alpha: 0.85)
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(SensorSparklinePainter old) => true;
}
