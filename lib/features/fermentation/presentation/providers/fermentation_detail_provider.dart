import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/network/http_client.dart';
import '../../../home/domain/entities/chart_point.dart';
import '../../../home/domain/entities/fermentation_metric.dart';
import '../../../sensors/data/datasource/remote/sensors_realtime_datasource.dart';
import '../../../sensors/data/repositories/sensors_realtime_repository_impl.dart';
import '../../../sensors/domain/entities/sensor_realtime_reading.dart';
import '../../../sensors/domain/repositories/sensors_realtime_repository.dart';
import '../../../sensors/domain/use_cases/watch_sensors_use_case.dart';
import '../../../../shared/theme/app_palette.dart';
import '../../data/datasource/remote/active_fermentation_datasource.dart';
import '../../data/repositories/active_fermentation_repository_impl.dart';
import '../../domain/entities/active_fermentation_session.dart';
import '../../domain/use_cases/get_active_fermentation_use_case.dart';
import '../../domain/entities/fermentation_detail.dart';

class FermentationDetailProvider extends ChangeNotifier {
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
  bool get hasActive => _session != null;

  final Map<String, double> _live = {};
  final List<double> _tempHistory = [];

  FermentationDetailProvider({
    GetActiveFermentationUseCase? getActive,
    SensorsRealtimeRepository? sensorsRepo,
  }) : _getActive =
           getActive ??
           GetActiveFermentationUseCase(
             ActiveFermentationRepositoryImpl(
               ActiveFermentationDatasource(HttpClient.instance),
             ),
           ),
       _sensorsRepo =
           sensorsRepo ??
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
    } catch (_) {
      /* reintenta luego */
    }
  }

  void _applyReading(SensorRealtimeReading r) {
    _live[r.sensorType] = r.value;
    if (r.sensorType == 'temperature') {
      _tempHistory.add(r.value);
      if (_tempHistory.length > 24) _tempHistory.removeAt(0);
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

  List<ChartPoint> get _tempChart {
    if (_tempHistory.isEmpty) return const [];
    final maxV = _tempHistory.reduce((a, b) => a > b ? a : b);
    final minV = _tempHistory.reduce((a, b) => a < b ? a : b);
    final range = (maxV - minV).abs() < 0.001 ? 1.0 : (maxV - minV);
    final n = _tempHistory.length;
    return [
      for (var i = 0; i < n; i++)
        ChartPoint(
          n == 1 ? 0.0 : i / (n - 1),
          ((_tempHistory[i] - minV) / range).clamp(0.0, 1.0),
        ),
    ];
  }

  static String _fmt(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes % 60;
    return h > 0 ? '${h}h ${m}m' : '${m}m';
  }

  /// Detalle del lote con datos REALES (sesión activa + sensores en vivo).
  FermentationDetail get detail {
    final s = _session;
    final ph = _metric('PH', 'ph', '', AppPalette.metricCyan, decimals: 2);
    final density = _metric(
      'DENSIDAD',
      'density',
      '',
      AppPalette.accent,
      decimals: 3,
    );
    final alcohol = _metric('ALCOHOL', 'alcohol', '%', AppPalette.metricRed);
    final turbidity = _metric(
      'TURBIDEZ',
      'turbidity',
      'NTU',
      AppPalette.metricPurple,
      decimals: 0,
    );

    if (s == null) {
      return FermentationDetail(
        id: '—',
        variety: 'Sin fermentación',
        process: 'activa',
        tank: '',
        progress: 0,
        elapsed: '0h 0m',
        objectiveLabel: '',
        chartPoints: const [],
        ph: ph,
        density: density,
        alcohol: alcohol,
        turbidity: turbidity,
        events: const [],
      );
    }

    return FermentationDetail(
      id: 'F-${s.id.toString().padLeft(3, '0')}',
      variety: s.groupId != null ? 'Grupo ${s.groupId}' : 'Fermentación',
      process: s.isRunning ? 'En fermentación' : s.status,
      tank: 'Circuito #${s.circuitId}',
      progress: s.progress,
      elapsed: _fmt(s.elapsed),
      objectiveLabel: 'de ${_fmt(s.objective)} objetivo',
      chartPoints: _tempChart,
      ph: ph,
      density: density,
      alcohol: alcohol,
      turbidity: turbidity,
      events: const [], // sin endpoint de eventos en el backend
    );
  }

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
