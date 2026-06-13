import 'package:flutter/material.dart';
import '../../domain/entities/chart_point.dart';

class ChartPainter extends CustomPainter {
  final List<ChartPoint> points;

  ChartPainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    final linePath = Path();
    final fillPath = Path();

    Offset toOffset(ChartPoint p) => Offset(
      p.x * size.width,
      size.height - (p.y * size.height * 0.9) - size.height * 0.05,
    );

    final first = toOffset(points.first);
    linePath.moveTo(first.dx, first.dy);
    fillPath.moveTo(first.dx, size.height);
    fillPath.lineTo(first.dx, first.dy);

    for (int i = 1; i < points.length; i++) {
      final prev = toOffset(points[i - 1]);
      final curr = toOffset(points[i]);
      final cp1 = Offset((prev.dx + curr.dx) / 2, prev.dy);
      final cp2 = Offset((prev.dx + curr.dx) / 2, curr.dy);
      linePath.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, curr.dx, curr.dy);
      fillPath.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, curr.dx, curr.dy);
    }

    final last = toOffset(points.last);
    fillPath.lineTo(last.dx, size.height);
    fillPath.close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFFF0A646).withValues(alpha: 0.35),
          const Color(0xFFF0A646).withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final linePaint = Paint()
      ..color = const Color(0xFFF0A646)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(linePath, linePaint);
  }

  @override
  bool shouldRepaint(ChartPainter old) => old.points != points;
}
