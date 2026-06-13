import '../../../home/domain/entities/chart_point.dart';
import '../../../home/domain/entities/fermentation_metric.dart';
import 'fermentation_event.dart';

class FermentationDetail {
  final String id;
  final String variety;
  final String process;
  final String tank;
  final double progress;
  final String elapsed;
  final String objectiveLabel;
  final List<ChartPoint> chartPoints;
  final FermentationMetric ph;
  final FermentationMetric density;
  final FermentationMetric alcohol;
  final FermentationMetric turbidity;
  final List<FermentationEvent> events;

  const FermentationDetail({
    required this.id,
    required this.variety,
    required this.process,
    required this.tank,
    required this.progress,
    required this.elapsed,
    required this.objectiveLabel,
    required this.chartPoints,
    required this.ph,
    required this.density,
    required this.alcohol,
    required this.turbidity,
    required this.events,
  });

  String get title => 'Fermentación #$id';
  String get subtitle => '$variety · $process · $tank';
}
