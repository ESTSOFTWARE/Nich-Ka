import 'package:flutter/material.dart';
import '../../domain/entities/chart_point.dart';
import 'chart_painter.dart';

class FermentationChart extends StatelessWidget {
  final List<ChartPoint> points;
  final double height;

  const FermentationChart({super.key, required this.points, this.height = 80});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: CustomPaint(
        painter: ChartPainter(points: points),
        size: Size.infinite,
      ),
    );
  }
}
