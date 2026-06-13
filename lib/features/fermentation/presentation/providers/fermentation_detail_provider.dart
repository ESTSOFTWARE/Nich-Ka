import 'package:flutter/material.dart';
import '../../../home/domain/entities/chart_point.dart';
import '../../../home/domain/entities/fermentation_metric.dart';
import '../../../home/presentation/theme/home_palette.dart';
import '../../domain/entities/fermentation_detail.dart';
import '../../domain/entities/fermentation_event.dart';

class FermentationDetailProvider extends ChangeNotifier {
  final FermentationDetail detail = const FermentationDetail(
    id: 'F-024',
    variety: 'Caturra',
    process: 'Lavado',
    tank: 'Tanque 02',
    progress: 0.78,
    elapsed: '18h 42m',
    objectiveLabel: 'de 24h objetivo · termina 21:18',
    chartPoints: [
      ChartPoint(0.0, 0.08),
      ChartPoint(0.15, 0.18),
      ChartPoint(0.3, 0.32),
      ChartPoint(0.45, 0.44),
      ChartPoint(0.6, 0.58),
      ChartPoint(0.75, 0.70),
      ChartPoint(0.88, 0.82),
      ChartPoint(1.0, 0.94),
    ],
    ph: FermentationMetric(
      label: 'PH',
      value: '4.20',
      unit: '',
      change: '-0.05/h',
      color: HomePalette.metricCyan,
    ),
    density: FermentationMetric(
      label: 'DENSIDAD',
      value: '1.024',
      unit: '',
      change: '-0.004/h',
      color: HomePalette.accent,
    ),
    alcohol: FermentationMetric(
      label: 'ALCOHOL',
      value: '6.4',
      unit: '%',
      change: '+0.3/h',
      color: HomePalette.metricRed,
    ),
    turbidity: FermentationMetric(
      label: 'TURBIDEZ',
      value: '180',
      unit: 'NTU',
      change: '+5/h',
      color: HomePalette.metricPurple,
    ),
    events: [
      FermentationEvent(
        time: '16:42',
        description: 'IA sugiere reducir 1.5°C',
        isAiSuggestion: true,
      ),
      FermentationEvent(time: '15:30', description: 'Densidad bajó a 1.024'),
      FermentationEvent(time: '14:00', description: 'pH cruzó 4.2'),
    ],
  );
}
