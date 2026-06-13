import 'package:flutter/material.dart';
import '../../domain/entities/fermentation_detail.dart';
import '../../../home/presentation/theme/home_palette.dart';
import 'fermentation_detail_metric_card.dart';

class FermentationDetailMetricsGrid extends StatelessWidget {
  final FermentationDetail detail;
  final HomePalette palette;

  const FermentationDetailMetricsGrid({
    super.key,
    required this.detail,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: FermentationDetailMetricCard(
                metric: detail.ph,
                palette: palette,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: FermentationDetailMetricCard(
                metric: detail.density,
                palette: palette,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: FermentationDetailMetricCard(
                metric: detail.alcohol,
                palette: palette,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: FermentationDetailMetricCard(
                metric: detail.turbidity,
                palette: palette,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
