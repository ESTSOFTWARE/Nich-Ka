import 'package:flutter/material.dart';

class SensorRangeBarPainter extends CustomPainter {
  final double min;
  final double max;
  final double optimalMin;
  final double optimalMax;
  final double currentValue;
  final Color color;
  final Color trackColor;

  const SensorRangeBarPainter({
    required this.min,
    required this.max,
    required this.optimalMin,
    required this.optimalMax,
    required this.currentValue,
    required this.color,
    required this.trackColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final totalRange = max - min;
    if (totalRange == 0) return;

    final h = size.height;
    final r = Radius.circular(h / 2);

    double toX(double v) =>
        ((v - min) / totalRange).clamp(0.0, 1.0) * size.width;

    canvas.drawRRect(
      RRect.fromLTRBR(0, 0, size.width, h, r),
      Paint()..color = trackColor,
    );

    final optLeft = toX(optimalMin);
    final optRight = toX(optimalMax);
    canvas.drawRRect(
      RRect.fromLTRBR(optLeft, 0, optRight, h, r),
      Paint()..color = color.withValues(alpha: 0.45),
    );

    final cx = toX(currentValue).clamp(h / 2, size.width - h / 2);
    final cy = h / 2;
    canvas.drawCircle(Offset(cx, cy), h / 2 + 2, Paint()..color = Colors.white);
    canvas.drawCircle(Offset(cx, cy), h / 2, Paint()..color = color);
  }

  @override
  bool shouldRepaint(SensorRangeBarPainter old) =>
      old.currentValue != currentValue || old.color != color;
}
