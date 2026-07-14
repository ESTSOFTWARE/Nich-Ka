import 'chart_point.dart';
import 'fermentation_metric.dart';

class ActiveFermentation {
  final String id;
  final String variety;
  final String process;
  final String farm;
  final String tank;
  final Duration elapsed;
  final Duration objective;
  final double progressPercent;
  final List<ChartPoint> chartPoints;
  final FermentationMetric temperature;
  final FermentationMetric alcohol;
  final FermentationMetric conductivity;
  final FermentationMetric turbidity;
  final FermentationMetric ph;
  final FermentationMetric rpm;

  const ActiveFermentation({
    required this.id,
    required this.variety,
    required this.process,
    required this.farm,
    required this.tank,
    required this.elapsed,
    required this.objective,
    required this.progressPercent,
    required this.chartPoints,
    required this.temperature,
    required this.alcohol,
    required this.conductivity,
    required this.turbidity,
    required this.ph,
    required this.rpm,
  });

  String get title => '$variety · $process';
  String get location => '$farm · $tank';
}
