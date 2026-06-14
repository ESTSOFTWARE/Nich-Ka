import 'package:flutter/material.dart';
import '../../domain/entities/active_fermentation.dart';
import '../../domain/entities/ai_recommendation.dart';
import '../../domain/entities/chart_point.dart';
import '../../domain/entities/fermentation_item.dart';
import '../../domain/entities/fermentation_metric.dart';
import '../../../../shared/theme/app_palette.dart';

class HomeProvider extends ChangeNotifier {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController scrollController = ScrollController();

  bool _isScrolled = false;
  bool get isScrolled => _isScrolled;

  HomeProvider() {
    scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final scrolled = scrollController.offset > 4;
    if (scrolled != _isScrolled) {
      _isScrolled = scrolled;
      notifyListeners();
    }
  }

  final ActiveFermentation activeFermentation = ActiveFermentation(
    id: 'F-024',
    variety: 'Caturra',
    process: 'Lavado',
    farm: 'Finca La Esperanza',
    tank: 'Tanque 02',
    elapsed: const Duration(hours: 18, minutes: 42),
    objective: const Duration(hours: 24),
    progressPercent: 0.78,
    chartPoints: const [
      ChartPoint(0.0, 0.05),
      ChartPoint(0.1, 0.08),
      ChartPoint(0.2, 0.12),
      ChartPoint(0.3, 0.20),
      ChartPoint(0.4, 0.28),
      ChartPoint(0.5, 0.38),
      ChartPoint(0.6, 0.50),
      ChartPoint(0.7, 0.60),
      ChartPoint(0.8, 0.68),
      ChartPoint(0.9, 0.74),
      ChartPoint(1.0, 0.78),
    ],
    temperature: FermentationMetric(
      label: 'TEMPERATURA',
      value: '22.4',
      unit: '°C',
      change: 'estable',
      color: AppPalette.metricOrange,
    ),
    ph: FermentationMetric(
      label: 'PH',
      value: '4.20',
      unit: '',
      change: '-0.05 / h',
      color: AppPalette.metricCyan,
    ),
    density: FermentationMetric(
      label: 'DENSIDAD',
      value: '1.024',
      unit: 'g/mL',
      change: '-0.004 / h',
      color: AppPalette.accent,
    ),
    alcohol: FermentationMetric(
      label: 'ALCOHOL',
      value: '6.4',
      unit: '%v/v',
      change: '+0.3 / h',
      color: AppPalette.metricRed,
    ),
    conductivity: FermentationMetric(
      label: 'CONDUCTIVIDAD',
      value: '2.8',
      unit: 'mS/cm',
      change: '+0.1 / h',
      color: AppPalette.metricCyan,
    ),
  );

  final AiRecommendation recommendation = const AiRecommendation(
    body:
        'Reduce 1.5 °C en las próximas 2 h para favorecer notas florales y cítricas.',
    actionLabel: 'Ver análisis',
  );

  final List<FermentationItem> fermentations = const [
    FermentationItem(
      id: 'F-023',
      name: 'Geisha',
      process: 'Honey',
      farm: 'El Mirador',
      statusLabel: 'Secado',
      statusColor: AppPalette.metricOrange,
      timeInfo: 'Día 3 / 12',
      ringProgress: 0.40,
      ringColor: AppPalette.metricOrange,
    ),
  ];

  String get greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return '¡Buenos días!';
    if (hour < 19) return '¡Buenas tardes!';
    return '¡Buenas noches!';
  }

  String _formatDuration(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes.remainder(60);
    return '${h}h ${m}m';
  }

  String get elapsedFormatted => _formatDuration(activeFermentation.elapsed);
  String get objectiveFormatted =>
      _formatDuration(activeFermentation.objective);

  @override
  void dispose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.dispose();
  }
}
