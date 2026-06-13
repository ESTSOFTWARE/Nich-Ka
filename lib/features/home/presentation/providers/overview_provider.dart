import 'package:flutter/material.dart';
import '../../domain/entities/chart_point.dart';
import '../../domain/entities/dashboard_stat.dart';
import '../../domain/entities/fermentation_card.dart';
import '../components/time_range.dart';
import '../theme/home_palette.dart';

class OverviewProvider extends ChangeNotifier {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController scrollController = ScrollController();

  bool _isScrolled = false;
  bool get isScrolled => _isScrolled;

  TimeRange _selectedRange = TimeRange.twentyFourHours;
  TimeRange get selectedRange => _selectedRange;

  OverviewProvider() {
    scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final scrolled = scrollController.offset > 4;
    if (scrolled != _isScrolled) {
      _isScrolled = scrolled;
      notifyListeners();
    }
  }

  String get greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return '¡Buenos días!';
    if (hour < 19) return '¡Buenas tardes!';
    return '¡Buenas noches!';
  }

  void selectRange(TimeRange range) {
    if (_selectedRange == range) return;
    _selectedRange = range;
    notifyListeners();
  }

  final List<DashboardStat> stats = const [
    DashboardStat(
      label: 'FERMENTACIONES ACTIVAS',
      value: '3',
      subtitle: '+1 esta semana',
      color: Color(0xFF75D079),
    ),
    DashboardStat(
      label: 'TIEMPO TOTAL',
      value: '62h',
      subtitle: 'fermentación',
      color: HomePalette.metricOrange,
    ),
    DashboardStat(
      label: 'CALIDAD SCA',
      value: '86.4',
      subtitle: 'promedio mes',
      color: HomePalette.metricCyan,
    ),
    DashboardStat(
      label: 'ALERTAS',
      value: '2',
      subtitle: 'requieren atención',
      color: HomePalette.metricRed,
    ),
  ];

  static const List<ChartPoint> _chartPoints = [
    ChartPoint(0.0, 0.02),
    ChartPoint(0.1, 0.05),
    ChartPoint(0.2, 0.10),
    ChartPoint(0.3, 0.18),
    ChartPoint(0.4, 0.28),
    ChartPoint(0.5, 0.40),
    ChartPoint(0.6, 0.52),
    ChartPoint(0.65, 0.58),
    ChartPoint(0.7, 0.64),
    ChartPoint(0.8, 0.72),
    ChartPoint(0.9, 0.78),
    ChartPoint(1.0, 0.82),
  ];

  List<ChartPoint> get chartPoints => _chartPoints;

  final List<FermentationCard> fermentationCards = [
    FermentationCard(
      id: 'F-024',
      name: 'Caturra',
      stage: 'Fermentación',
      progress: 0.78,
      ringColor: HomePalette.accent,
    ),
    FermentationCard(
      id: 'F-023',
      name: 'Geisha',
      stage: 'Secado',
      progress: 0.45,
      ringColor: HomePalette.metricOrange,
    ),
    FermentationCard(
      id: 'F-022',
      name: 'Bourbon',
      stage: 'Reposo',
      progress: 0.90,
      ringColor: HomePalette.metricCyan,
    ),
  ];

  @override
  void dispose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.dispose();
  }
}
