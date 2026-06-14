import 'nlp_analysis.dart';
import 'sensor_metric.dart';

class ReportDetail {
  final String reportNumber;
  final String fermentationCode;
  final String batchName;
  final String date;
  final double efficiency;
  final double ethanolDetected;
  final double ethanolTheoretical;
  final String duration;
  final NlpAnalysis nlpAnalysis;
  final List<SensorMetric> sensorMetrics;
  final String generatedAt;
  final int downloads;
  final int views;

  const ReportDetail({
    required this.reportNumber,
    required this.fermentationCode,
    required this.batchName,
    required this.date,
    required this.efficiency,
    required this.ethanolDetected,
    required this.ethanolTheoretical,
    required this.duration,
    required this.nlpAnalysis,
    required this.sensorMetrics,
    required this.generatedAt,
    required this.downloads,
    required this.views,
  });
}
