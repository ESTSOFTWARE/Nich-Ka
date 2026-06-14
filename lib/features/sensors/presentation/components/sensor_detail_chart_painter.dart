import 'package:flutter/material.dart';

class SensorDetailChartPainter extends CustomPainter {
  final List<double> points;
  final Color color;
  final Color gridColor;

  const SensorDetailChartPainter({
    required this.points,
    required this.color,
    required this.gridColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;

    final minVal = points.reduce((a, b) => a < b ? a : b);
    final maxVal = points.reduce((a, b) => a > b ? a : b);
    final range = maxVal - minVal;
    final pad = range == 0 ? 1.0 : range * 0.15;
    final lo = minVal - pad;
    final hi = maxVal + pad;

    double norm(double v) {
      if (hi == lo) return size.height / 2;
      return size.height -
          ((v - lo) / (hi - lo)) * size.height * 0.85 -
          size.height * 0.075;
    }

    final gridPaint = Paint()
      ..color = gridColor
      ..strokeWidth = 0.8;
    for (var i = 1; i <= 3; i++) {
      final y = size.height * i / 4;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final step = size.width / (points.length - 1);
    final path = Path();
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

    final fillPath = Path()
      ..addPath(path, Offset.zero)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(
      fillPath,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [color.withValues(alpha: 0.22), color.withValues(alpha: 0)],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
        ..style = PaintingStyle.fill,
    );

    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    final lastX = (points.length - 1) * step;
    final lastY = norm(points.last);
    canvas.drawCircle(Offset(lastX, lastY), 4.5, Paint()..color = color);
    canvas.drawCircle(
      Offset(lastX, lastY),
      4.5,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.9)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
  }

  @override
  bool shouldRepaint(SensorDetailChartPainter _) => true;
}
