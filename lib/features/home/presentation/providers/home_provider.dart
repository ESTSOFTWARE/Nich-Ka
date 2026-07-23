import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/network/http_client.dart';
import '../../../../core/push/push_service.dart';
import '../../../../features/fermentation/data/datasource/remote/active_fermentation_datasource.dart';
import '../../../../features/fermentation/data/repositories/active_fermentation_repository_impl.dart';
import '../../../../features/fermentation/domain/entities/active_fermentation_session.dart';
import '../../../../features/fermentation/domain/use_cases/get_active_fermentation_use_case.dart';
import '../../../../features/notifications/data/datasource/remote/model/dto/notification_event_dto.dart';
import '../../../../features/notifications/data/services/notification_websocket_service.dart';
import '../../../../features/reports/data/datasource/remote/reports_remote_datasource.dart';
import '../../../../features/reports/data/datasource/remote/model/dto/response/fermentation_session_response_dto.dart';
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
  final ReportsRemoteDataSource _reportsDs;
  late final WatchSensorsUseCase _watchSensors;
  StreamSubscription? _sub;
  StreamSubscription? _notifSub;
  Timer? _ticker;

  bool _loading = true;
  bool get isLoading => _loading;

  bool _isPredicting = false;
  bool get isPredicting => _isPredicting;

  ActiveFermentationSession? _session;
  ActiveFermentationSession? get session => _session;
  bool get hasActive => _session != null;

  List<FermentationItem> _fermentations = [];
  List<FermentationItem> get fermentations => _fermentations;

  final Map<String, double> _live = {};
  final List<double> _alcoholHistory = [];

  HomeProvider({
    GetActiveFermentationUseCase? getActive,
    SensorsRealtimeRepository? sensorsRepo,
    ReportsRemoteDataSource? reportsDs,
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
           ),
       _reportsDs = reportsDs ?? ReportsRemoteDataSource(HttpClient.instance) {
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
    _notifSub = NotificationWebSocketService.instance.events.listen(
      _onNotification,
    );
    _ticker = Timer.periodic(const Duration(seconds: 2), (_) {
      if (_session == null) return;
      notifyListeners();
      _checkPredictionThresholds();
    });

    _loadFermentations();
    _checkPredictionThresholds();
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

  Future<String?> requestPrediction() async {
    final session = _session;
    if (session == null || _isPredicting) return null;
    _isPredicting = true;
    notifyListeners();
    String? message;
    try {
      final resp = await HttpClient.instance.post(
        '/fermentation/${session.id}/predict-now',
        {},
      );
      final data = jsonDecode(resp.body) as Map<String, dynamic>;
      message = data['message'] as String?;
      if (message != null && message.isNotEmpty) {
        recommendation = AiRecommendation(
          body: message,
          actionLabel: 'Ver análisis',
          title: 'PREDICCIÓN DE EFICIENCIA',
          isPrediction: true,
        );
        await PushService.instance.showLocalNotification(
          title: '🔮 Predicción de eficiencia',
          body: message,
        );
      }
    } catch (_) {}
    _isPredicting = false;
    notifyListeners();
    return message;
  }

  Future<void> _checkPredictionThresholds() async {
    final session = _session;
    if (session == null) return;
    // session.progress es 0.0–1.0 (fracción). Los umbrales 50% y 80% son
    // 0.5 y 0.8; comparar contra 50/80 nunca se cumplía y la predicción
    // automática jamás se disparaba.
    final progress = session.progress;
    final id = session.id;
    if (progress >= 0.5 && !await _hasPredicted(id, 50)) {
      await _markPredicted(id, 50);
      requestPrediction();
    }
    if (progress >= 0.8 && !await _hasPredicted(id, 80)) {
      await _markPredicted(id, 80);
      requestPrediction();
    }
  }

  Future<void> _loadFermentations() async {
    try {
      final pairs = await _reportsDs.getSessionsWithReports();
      _fermentations = pairs.take(10).map((p) => _sessionToItem(p.$1)).toList();
      notifyListeners();
    } catch (_) {}
  }

  static const _ringColors = [
    Color(0xFF75D079), // verde
    Color(0xFF60A5FA), // azul
    Color(0xFFF0A646), // naranja
    Color(0xFFEC4899), // rosa
    Color(0xFF14B8A6), // teal
    Color(0xFFA855F7), // morado
  ];

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
    notifyListeners();
  }

  void _onNotification(NotificationEventDto event) {
    if (event.type != 'recommendation' &&
        event.type != 'anomaly' &&
        event.type != 'efficiency') {
      return;
    }
    final sessionId = _session?.id;
    if (sessionId != null &&
        event.sessionId != null &&
        event.sessionId != sessionId) {
      return;
    }
    recommendation = AiRecommendation(
      body: event.message,
      actionLabel: 'Ver análisis',
      title: event.type == 'efficiency'
          ? 'PREDICCIÓN DE EFICIENCIA'
          : 'RECOMENDACIÓN IA',
      isPrediction: event.type == 'efficiency',
    );
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
        ChartPoint(
          n == 1 ? 0.0 : i / (n - 1),
          (_alcoholHistory[i] / denom).clamp(0.0, 1.0),
        ),
    ];
  }

  /// Fermentación activa construida con datos REALES (sesión + sensores en vivo).
  /// Los campos descriptivos que el backend no tiene se reemplazan por el lote,
  /// el circuito y el grupo (lo que sí existe).
  ActiveFermentation get activeFermentation {
    final s = _session;
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
        alcohol: alcohol,
        conductivity: conductivity,
        turbidity: turbidity,
        ph: ph,
        rpm: rpm,
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

  AiRecommendation recommendation = const AiRecommendation(
    body: 'Mantén la temperatura estable para una fermentación uniforme.',
    actionLabel: 'Ver análisis',
  );

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
    _notifSub?.cancel();
    _ticker?.cancel();
    _sensorsRepo.dispose();
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.dispose();
  }
}
