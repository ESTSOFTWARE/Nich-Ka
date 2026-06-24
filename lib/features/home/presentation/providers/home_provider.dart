import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/network/http_client.dart';
import '../../../../features/fermentation/data/datasource/remote/active_fermentation_datasource.dart';
import '../../../../features/fermentation/data/repositories/active_fermentation_repository_impl.dart';
import '../../../../features/fermentation/domain/entities/active_fermentation_session.dart';
import '../../../../features/fermentation/domain/use_cases/get_active_fermentation_use_case.dart';
import '../../../../features/sensors/data/datasource/remote/sensors_realtime_datasource.dart';
import '../../../../features/sensors/data/repositories/sensors_realtime_repository_impl.dart';
import '../../../../features/sensors/domain/entities/sensor_realtime_reading.dart';
import '../../../../features/sensors/domain/repositories/sensors_realtime_repository.dart';
import '../../../../features/sensors/domain/use_cases/watch_sensors_use_case.dart';
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

  final GetActiveFermentationUseCase _getActive;
  final SensorsRealtimeRepository _sensorsRepo;
  late final WatchSensorsUseCase _watchSensors;
  StreamSubscription? _sub;
  Timer? _ticker;

  bool _loading = true;
  bool get isLoading => _loading;

  ActiveFermentationSession? _session;
  ActiveFermentationSession? get session => _session;
  bool get hasActive => _session != null;

  // Últimos valores en vivo por tipo de sensor (del WebSocket).
  final Map<String, double> _live = {};
  final List<double> _alcoholHistory = [];

  HomeProvider({
    GetActiveFermentationUseCase? getActive,
    SensorsRealtimeRepository? sensorsRepo,
  })  : _getActive = getActive ??
            GetActiveFermentationUseCase(
              ActiveFermentationRepositoryImpl(
                ActiveFermentationDatasource(HttpClient.instance),
              ),
            ),
        _sensorsRepo = sensorsRepo ??
            SensorsRealtimeRepositoryImpl(
              SensorsRealtimeDataSource(HttpClient.instance),
            ) {
    _watchSensors = WatchSensorsUseCase(_sensorsRepo);
    scrollController.addListener(_onScroll);
    _init();
  }

  Future<void> _init() async {
    try {
      _session = await _getActive();
    } catch (_) {
      _session = null;
    }
    _loading = false;
    notifyListeners();

    if (_session != null) {
      _sub = _watchSensors(_session!.circuitId).listen(_applyReading);
    }
    // Re-consulta la sesión activa para detectar cuando termina y refrescar tiempo.
    _ticker = Timer.periodic(const Duration(seconds: 15), (_) => _refresh());
  }

  Future<void> _refresh() async {
    try {
      final active = await _getActive();
      if (active == null) {
        if (_session != null) {
          _session = null;
          await _sub?.cancel();
          _sub = null;
        }
      } else {
        final wasNull = _session == null;
        _session = active;
        if (wasNull) {
          _sub = _watchSensors(active.circuitId).listen(_applyReading);
        }
      }
      notifyListeners();
    } catch (_) {/* reintenta luego */}
  }

  void _applyReading(SensorRealtimeReading r) {
    _live[r.sensorType] = r.value;
    if (r.sensorType == 'alcohol') {
      _alcoholHistory.add(r.value);
      if (_alcoholHistory.length > 24) _alcoholHistory.removeAt(0);
    }
    notifyListeners();
  }

  void _onScroll() {
    final scrolled = scrollController.offset > 4;
    if (scrolled != _isScrolled) {
      _isScrolled = scrolled;
      notifyListeners();
    }
  }

  FermentationMetric _metric(
    String label,
    String type,
    String unit,
    Color color, {
    int decimals = 1,
  }) {
    final v = _live[type];
    return FermentationMetric(
      label: label,
      value: v != null ? v.toStringAsFixed(decimals) : '—',
      unit: unit,
      change: v != null ? 'en vivo' : 'sin datos',
      color: color,
    );
  }

  List<ChartPoint> get _liveChart {
    if (_alcoholHistory.isEmpty) return const [];
    final maxV = _alcoholHistory.reduce((a, b) => a > b ? a : b);
    final denom = maxV <= 0 ? 1.0 : maxV;
    final n = _alcoholHistory.length;
    return [
      for (var i = 0; i < n; i++)
        ChartPoint(n == 1 ? 0.0 : i / (n - 1),
            (_alcoholHistory[i] / denom).clamp(0.0, 1.0)),
    ];
  }

  /// Fermentación activa construida con datos REALES (sesión + sensores en vivo).
  /// Los campos descriptivos que el backend no tiene se reemplazan por el lote,
  /// el circuito y el grupo (lo que sí existe).
  ActiveFermentation get activeFermentation {
    final s = _session;
    final temperature =
        _metric('TEMPERATURA', 'temperature', '°C', AppPalette.metricOrange);
    final ph = _metric('PH', 'ph', '', AppPalette.metricCyan, decimals: 2);
    final density =
        _metric('DENSIDAD', 'density', 'g/mL', AppPalette.accent, decimals: 3);
    final alcohol =
        _metric('ALCOHOL', 'alcohol', '%v/v', AppPalette.metricRed);
    final conductivity =
        _metric('CONDUCTIVIDAD', 'conductivity', 'mS/cm', AppPalette.metricCyan);

    if (s == null) {
      return ActiveFermentation(
        id: '—',
        variety: 'Sin fermentación',
        process: 'activa',
        farm: '',
        tank: '',
        elapsed: Duration.zero,
        objective: Duration.zero,
        progressPercent: 0,
        chartPoints: const [],
        temperature: temperature,
        ph: ph,
        density: density,
        alcohol: alcohol,
        conductivity: conductivity,
      );
    }

    return ActiveFermentation(
      id: 'F-${s.id}',
      variety: s.loteLabel, // "Lote #12"
      process: s.isRunning ? 'En fermentación' : s.status,
      farm: s.groupId != null ? 'Grupo ${s.groupId}' : '',
      tank: 'Circuito #${s.circuitId}',
      elapsed: s.elapsed,
      objective: s.objective,
      progressPercent: s.progress,
      chartPoints: _liveChart,
      temperature: temperature,
      ph: ph,
      density: density,
      alcohol: alcohol,
      conductivity: conductivity,
    );
  }

  final AiRecommendation recommendation = const AiRecommendation(
    body:
        'Mantén la temperatura estable para una fermentación uniforme.',
    actionLabel: 'Ver análisis',
  );

  // Sin datos mock: la lista de "otras fermentaciones" se llena aparte si se requiere.
  final List<FermentationItem> fermentations = const [];

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
    _sub?.cancel();
    _ticker?.cancel();
    _sensorsRepo.dispose();
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.dispose();
  }
}
