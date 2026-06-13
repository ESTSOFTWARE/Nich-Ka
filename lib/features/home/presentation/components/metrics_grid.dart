import 'package:flutter/material.dart';
import '../../domain/entities/active_fermentation.dart';
import '../theme/home_palette.dart';
import 'metric_tile.dart';

class MetricsGrid extends StatelessWidget {
  final ActiveFermentation fermentation;
  final HomePalette palette;

  const MetricsGrid({
    super.key,
    required this.fermentation,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: MetricTile(
                metric: fermentation.temperature,
                palette: palette,
                rightBorder: true,
                bottomBorder: true,
              ),
            ),
            Expanded(
              child: MetricTile(
                metric: fermentation.ph,
                palette: palette,
                bottomBorder: true,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: MetricTile(
                metric: fermentation.density,
                palette: palette,
                rightBorder: true,
                bottomBorder: true,
              ),
            ),
            Expanded(
              child: MetricTile(
                metric: fermentation.alcohol,
                palette: palette,
                bottomBorder: true,
              ),
            ),
          ],
        ),
        MetricTile(
          metric: fermentation.conductivity,
          palette: palette,
        ),
      ],
    );
  }
}
