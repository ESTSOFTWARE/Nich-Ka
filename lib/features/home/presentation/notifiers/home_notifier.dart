import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/network/http_client.dart';
import '../../../fermentation/data/datasource/remote/active_fermentation_datasource.dart';
import '../../../fermentation/data/repositories/active_fermentation_repository_impl.dart';
import '../../../fermentation/domain/entities/active_fermentation_session.dart';
import '../../../fermentation/domain/use_cases/get_active_fermentation_use_case.dart';
import '../../../notifications/data/datasource/remote/model/dto/notification_event_dto.dart';
import '../../../notifications/data/services/notification_websocket_service.dart';
import '../../../reports/data/datasource/remote/reports_remote_datasource.dart';
import '../../../reports/data/datasource/remote/model/dto/response/fermentation_session_response_dto.dart';
import '../../../sensors/data/datasource/remote/sensors_realtime_datasource.dart';
import '../../../sensors/data/repositories/sensors_realtime_repository_impl.dart';
import '../../../sensors/domain/entities/sensor_realtime_reading.dart';
import '../../../sensors/domain/repositories/sensors_realtime_repository.dart';
import '../../../sensors/domain/use_cases/watch_sensors_use_case.dart';
import '../../domain/entities/active_fermentation.dart';
import '../../domain/entities/ai_recommendation.dart';
import '../../domain/entities/chart_point.dart';
import '../../domain/entities/fermentation_item.dart';
import '../../domain/entities/fermentation_metric.dart';
import '../../../../shared/theme/app_palette.dart';
import 'home_state.dart';

class HomeNotifier extends AutoDisposeNotifier<HomeState> {
  final SensorsRealtimeRepository _sensorsRepo = SensorsRealtimeRepositoryImpl(
    SensorsRealtimeDataSource(HttpClient.instance),
  );
  late final WatchSensorsUseCase _watchSensors;
  final ReportsRemoteDataSource _reportsDs = ReportsRemoteDataSource(
    HttpClient.instance,
  );

  StreamSubscription<SensorRealtimeReading>? _sub;
  StreamSubscription<NotificationEventDto>? _notifSub;
  Timer? _ticker;

  final Map<String, double> _live = {};
  final List<double> _alcoholHistory = [];

  static const _ringColors = [
    Color(0xFF75D079),
    Color(0xFF60A5FA),
    Color(0xFFF0A646),
    Color(0xFFEC4899),
    Color(0xFF14B8A6),
    Color(0xFFA855F7),
  ];

  @override
  HomeState build() {
    ref.onDispose(_cleanup);
    return const HomeState();
  }

  void _cleanup() {
    _sub?.cancel();
    _notifSub?.cancel();
    _ticker?.cancel();
    _sensorsRepo.dispose();
  }

  Future<void> load() async {
    state = state.copyWith(isLoading: true, clearError: true);
    ActiveFermentationSession? session;
    try {
      final useCase = GetActiveFermentationUseCase(
        ActiveFermentationRepositoryImpl(
          ActiveFermentationDatasource(HttpClient.instance),
        ),
      );
      session = await useCase();
    } catch (_) {
      session = null;
    }

    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 2), (_) {
      if (state.active.id == '—') return;
      _rebuildActive();
    });

    if (session != null) {
      _sub = _watchSensors(session.circuitId).listen(_applyReading);
    }

    _notifSub?.cancel();
    _notifSub = NotificationWebSocketService.instance.events.listen(
      _onNotification,
    );

    _rebuildActive(session: session);
    _loadFermentations();
    _checkPredictionThresholds();
  }

  void _rebuildActive({ActiveFermentationSession? session}) {
    final s = session ?? _findSessionFromState();
    final active = _buildActiveFermentation(s);
    state = state.copyWith(isLoading: false, active: active);
  }

  ActiveFermentationSession? _findSessionFromState() {
    if (state.active.id == '—') return null;
    return null;
  }

  void _onNotification(NotificationEventDto event) {
    if (event.type != 'recommendation' &&
        event.type != 'anomaly' &&
        event.type != 'efficiency') {
      return;
    }
    state = state.copyWith(
      recommendation: AiRecommendation(
        body: event.message,
        actionLabel: 'Ver análisis',
      ),
    );
  }

  Future<void> _loadFermentations() async {
    try {
      final pairs = await _reportsDs.getSessionsWithReports();
      final items = pairs.take(10).map((p) => _sessionToItem(p.$1)).toList();
      state = state.copyWith(fermentations: items);
    } catch (_) {}
  }

  FermentationItem _sessionToItem(FermentationSessionResponseDto s) {
    final start = s.actualStart != null
        ? DateTime.tryParse(s.actualStart!) ?? DateTime.now()
        : DateTime.tryParse(s.scheduledStart) ?? DateTime.now();
    final end =
        DateTime.tryParse(s.scheduledEnd) ??
        start.add(const Duration(hours: 48));
    final now = DateTime.now();
    final totalSecs = end.difference(start).inSeconds.clamp(1, 1 << 53);
    final elapsedSecs = now.difference(start).inSeconds.clamp(0, totalSecs);
    final progress = elapsedSecs / totalSecs;
    final dayElapsed = now.difference(start).inDays + 1;
    final dayTotal = end.difference(start).inDays.clamp(1, 365);
    final ringColor = _ringColors[s.formulaId % _ringColors.length];
    final (statusLabel, statusColor) = switch (s.status) {
      'running' || 'active' => ('En curso', const Color(0xFF75D079)),
      'completed' => ('Completada', const Color(0xFF60A5FA)),
      'interrupted' => ('Interrumpida', const Color(0xFFF0A646)),
      _ => (s.status, const Color(0xFF8A8A8E)),
    };
    return FermentationItem(
      id: 'F-${s.id.toString().padLeft(3, '0')}',
      name: 'Circuito ${s.circuitId}',
      process: statusLabel,
      farm: s.groupId != null ? 'Grupo ${s.groupId}' : '',
      statusLabel: statusLabel,
      statusColor: statusColor,
      timeInfo: 'Día $dayElapsed / $dayTotal',
      ringProgress: progress.clamp(0.0, 1.0),
      ringColor: ringColor,
      sessionId: s.id,
    );
  }

  void _applyReading(SensorRealtimeReading r) {
    _live[r.sensorType] = r.value;
    if (r.sensorType == 'alcohol') {
      _alcoholHistory.add(r.value);
      if (_alcoholHistory.length > 24) _alcoholHistory.removeAt(0);
    }
    _rebuildActive();
  }

  String _prefKey(int sessionId, int threshold) =>
      'ml_predicted_${threshold}_$sessionId';

  Future<bool> _hasPredicted(int sessionId, int threshold) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_prefKey(sessionId, threshold)) ?? false;
  }

  Future<void> _markPredicted(int sessionId, int threshold) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefKey(sessionId, threshold), true);
  }

  Future<void> requestPrediction() async {
    if (state.isPredicting) return;
    state = state.copyWith(isPredicting: true);
    try {
      await HttpClient.instance.post(
        '/fermentation/${state.active.id}/predict-now',
        {},
      );
    } catch (_) {}
    state = state.copyWith(isPredicting: false);
  }

  Future<void> _checkPredictionThresholds() async {
    final progress = state.active.progressPercent;
    final idStr = state.active.id;
    if (idStr == '—') return;
    final id = int.tryParse(idStr.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
    if (progress >= 50 && !await _hasPredicted(id, 50)) {
      await _markPredicted(id, 50);
      requestPrediction();
    }
    if (progress >= 80 && !await _hasPredicted(id, 80)) {
      await _markPredicted(id, 80);
      requestPrediction();
    }
  }

  ActiveFermentation _buildActiveFermentation(ActiveFermentationSession? s) {
    final temperature = _metric(
      'TEMPERATURA',
      'temperature',
      '°C',
      AppPalette.metricOrange,
    );
    final alcohol = _metric('ALCOHOL', 'alcohol', '%v/v', AppPalette.metricRed);
    final conductivity = _metric(
      'CONDUCTIVIDAD',
      'conductivity',
      'mS/cm',
      AppPalette.metricCyan,
    );
    final turbidity = _metric(
      'TURBIDEZ',
      'turbidity',
      'NTU',
      AppPalette.metricPurple,
      decimals: 0,
    );
    final ph = _metric('PH', 'ph', '', AppPalette.metricCyan, decimals: 2);
    final rpm = _metric(
      'RPM MOTOR',
      'rpm',
      'rpm',
      AppPalette.accent,
      decimals: 0,
    );

    if (s == null) {
      return const ActiveFermentation(
        id: '—',
        variety: 'Sin fermentación',
        process: 'activa',
        farm: '',
        tank: '',
        elapsed: Duration.zero,
        objective: Duration.zero,
        progressPercent: 0,
        chartPoints: [],
        temperature: FermentationMetric(
          label: 'TEMPERATURA',
          value: '—',
          unit: '°C',
          change: 'sin datos',
          color: Color(0xFFF0A646),
        ),
        alcohol: FermentationMetric(
          label: 'ALCOHOL',
          value: '—',
          unit: '%v/v',
          change: 'sin datos',
          color: Color(0xFFFF6B6B),
        ),
        conductivity: FermentationMetric(
          label: 'CONDUCTIVIDAD',
          value: '—',
          unit: 'mS/cm',
          change: 'sin datos',
          color: Color(0xFF14B8A6),
        ),
        turbidity: FermentationMetric(
          label: 'TURBIDEZ',
          value: '—',
          unit: 'NTU',
          change: 'sin datos',
          color: Color(0xFFA78BFA),
        ),
        ph: FermentationMetric(
          label: 'PH',
          value: '—',
          unit: '',
          change: 'sin datos',
          color: Color(0xFF4FA8E8),
        ),
        rpm: FermentationMetric(
          label: 'RPM MOTOR',
          value: '—',
          unit: 'rpm',
          change: 'sin datos',
          color: Color(0xFF14B8A6),
        ),
      );
    }

    return ActiveFermentation(
      id: 'F-${s.id}',
      variety: s.loteLabel,
      process: s.isRunning ? 'En fermentación' : s.status,
      farm: s.groupId != null ? 'Grupo ${s.groupId}' : '',
      tank: 'Circuito #${s.circuitId}',
      elapsed: s.elapsed,
      objective: s.objective,
      progressPercent: s.progress,
      chartPoints: _liveChart,
      temperature: temperature,
      alcohol: alcohol,
      conductivity: conductivity,
      turbidity: turbidity,
      ph: ph,
      rpm: rpm,
    );
  }

  List<ChartPoint> get _liveChart {
    if (_alcoholHistory.isEmpty) return const [];
    final maxV = _alcoholHistory.reduce((a, b) => a > b ? a : b);
    final denom = maxV <= 0 ? 1.0 : maxV;
    final n = _alcoholHistory.length;
    return [
      for (var i = 0; i < n; i++)
        ChartPoint(
          n == 1 ? 0.0 : i / (n - 1),
          (_alcoholHistory[i] / denom).clamp(0.0, 1.0),
        ),
    ];
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

  String get elapsedFormatted => _formatDuration(state.active.elapsed);
  String get objectiveFormatted => _formatDuration(state.active.objective);
  bool get hasActive => state.active.id != '—';
}

final homeProvider = NotifierProvider.autoDispose<HomeNotifier, HomeState>(
  HomeNotifier.new,
);
