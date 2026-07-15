import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../home/domain/entities/chart_point.dart';
import '../../../home/domain/entities/fermentation_metric.dart';
import '../../../sensors/domain/entities/sensor_realtime_reading.dart';
import '../../../sensors/domain/repositories/sensors_realtime_repository.dart';
import '../../../sensors/domain/use_cases/watch_sensors_use_case.dart';
import '../../../../shared/theme/app_palette.dart';
import '../../di/fermentation_dependencies.dart';
import '../../domain/entities/fermentation_detail.dart';
import 'fermentation_detail_state.dart';

class FermentationDetailNotifier
    extends AutoDisposeNotifier<FermentationDetailState> {
  StreamSubscription<SensorRealtimeReading>? _sub;
  StreamSubscription<void>? _stopSub;
  Timer? _ticker;

  @override
  FermentationDetailState build() {
    ref.onDispose(_cleanup);
    return const FermentationDetailState();
  }

  void _cleanup() {
    _sub?.cancel();
    _stopSub?.cancel();
    _ticker?.cancel();
  }

  Future<void> load() async {
    try {
      final session = await FermentationDependencies.getActive();
      state = state.copyWith(
        session: session,
        isLoading: false,
        clearError: true,
      );
      if (session != null) _startSensors(session.circuitId);
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        error: 'Error al cargar la fermentación',
      );
    }

    _stopSub?.cancel();
    _stopSub = _sensorsRepo.onFermentationStopped.listen((_) {
      if (state.session != null) {
        _sub?.cancel();
        _sub = null;
        state = state.copyWith(
          clearSession: true,
          liveData: {},
          tempHistory: [],
        );
      }
    });

    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 20), (_) => _refresh());
  }

  void _startSensors(int circuitId) {
    _sub = _watchSensors(circuitId).listen(_applyReading);
  }

  SensorsRealtimeRepository get _sensorsRepo =>
      FermentationDependencies.sensorsRepository;

  WatchSensorsUseCase get _watchSensors =>
      FermentationDependencies.watchSensors;

  Future<void> _refresh() async {
    if (state.session != null) return;
    try {
      final active = await FermentationDependencies.getActive();
      if (active != null) {
        state = state.copyWith(session: active);
        _startSensors(active.circuitId);
      }
    } catch (_) {}
  }

  void _applyReading(SensorRealtimeReading r) {
    final newLive = Map<String, double>.from(state.liveData);
    newLive[r.sensorType] = r.value;

    List<double> newHistory = state.tempHistory;
    if (r.sensorType == 'temperature') {
      newHistory = List<double>.from(state.tempHistory)..add(r.value);
      if (newHistory.length > 24) newHistory.removeAt(0);
    }

    state = state.copyWith(liveData: newLive, tempHistory: newHistory);
  }

  FermentationMetric _metric(
    String label,
    String type,
    String unit,
    Color color, {
    int decimals = 1,
  }) {
    final v = state.liveData[type];
    return FermentationMetric(
      label: label,
      value: v != null ? v.toStringAsFixed(decimals) : '—',
      unit: unit,
      change: v != null ? 'en vivo' : 'sin datos',
      color: color,
    );
  }

  List<ChartPoint> get _tempChart {
    final history = state.tempHistory;
    if (history.isEmpty) return const [];
    final maxV = history.reduce((a, b) => a > b ? a : b);
    final minV = history.reduce((a, b) => a < b ? a : b);
    final range = (maxV - minV).abs() < 0.001 ? 1.0 : (maxV - minV);
    final n = history.length;
    return [
      for (var i = 0; i < n; i++)
        ChartPoint(
          n == 1 ? 0.0 : i / (n - 1),
          ((history[i] - minV) / range).clamp(0.0, 1.0),
        ),
    ];
  }

  static String _fmt(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes % 60;
    return h > 0 ? '${h}h ${m}m' : '${m}m';
  }

  bool get hasActive => state.session != null;

  FermentationDetail get detail {
    final s = state.session;
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
      events: const [],
    );
  }
}

final fermentationDetailProvider =
    NotifierProvider.autoDispose<
      FermentationDetailNotifier,
      FermentationDetailState
    >(FermentationDetailNotifier.new);
