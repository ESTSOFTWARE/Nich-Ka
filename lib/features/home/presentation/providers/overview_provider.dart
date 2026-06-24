import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/network/http_client.dart';
import '../../../../features/fermentation/data/datasource/remote/active_fermentation_datasource.dart';
import '../../../../features/fermentation/data/repositories/active_fermentation_repository_impl.dart';
import '../../../../features/fermentation/domain/entities/active_fermentation_session.dart';
import '../../../../features/fermentation/domain/use_cases/get_active_fermentation_use_case.dart';
import '../../../../features/sensors/data/datasource/remote/sensors_realtime_datasource.dart';
import '../../../../features/sensors/data/repositories/sensors_realtime_repository_impl.dart';
import '../../../../features/sensors/domain/entities/sensor_reading.dart';
import '../../../../features/sensors/domain/entities/sensor_realtime_reading.dart';
import '../../../../features/sensors/domain/repositories/sensors_realtime_repository.dart';
import '../../../../features/sensors/domain/use_cases/watch_sensors_use_case.dart';
import '../../domain/entities/chart_point.dart';
import '../../domain/entities/dashboard_stat.dart';
import '../../domain/entities/fermentation_card.dart';
import '../components/time_range.dart';
import '../../../../shared/theme/app_palette.dart';

class OverviewProvider extends ChangeNotifier {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController scrollController = ScrollController();

  bool _isScrolled = false;
  bool get isScrolled => _isScrolled;

  TimeRange _selectedRange = TimeRange.twentyFourHours;
  TimeRange get selectedRange => _selectedRange;

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

  late List<SensorReading> _readings;
  List<SensorReading> get readings => _readings;

  // Mapea el sensor_type del backend al id local de la lectura.
  static const Map<String, String> _typeToId = {
    'temperature': 'temp',
    'alcohol': 'alcohol',
    'conductivity': 'conductividad',
    'ph': 'ph',
    'turbidity': 'turbidez',
    'rpm': 'rpm',
  };

  OverviewProvider({
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
    _readings = _buildInitialReadings();
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
      // Métricas en vivo del circuito de la fermentación activa.
      _sub = _watchSensors(_session!.circuitId).listen(_applyReading);
    }
    // Re-consulta la sesión activa: detecta cuando termina (auto-stop o detenida
    // desde otro lado) y refresca tiempo/progreso.
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
        // Si justo arrancó una fermentación, engancha el WS.
        if (wasNull) {
          _sub = _watchSensors(active.circuitId).listen(_applyReading);
        }
      }
      notifyListeners();
    } catch (_) {/* sin conexión: reintenta en el próximo tick */}
  }

  void _applyReading(SensorRealtimeReading r) {
    final id = _typeToId[r.sensorType];
    if (id == null) return;

    var changed = false;
    _readings = _readings.map((reading) {
      if (reading.id != id) return reading;
      changed = true;
      return reading.copyWith(
        rawValue: r.value,
        history: [...reading.history.skip(1), r.value],
        trendUp: r.value >= reading.rawValue,
      );
    }).toList();

    if (changed) notifyListeners();
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

  // ── Datos derivados de la sesión activa ────────────────────────────────────
  String get loteLabel => _session?.loteLabel ?? 'Sin lote activo';

  String get statusLabel {
    if (_session == null) return 'Sin fermentación activa';
    return _session!.isRunning ? 'En fermentación' : _session!.status;
  }

  String get elapsedLabel =>
      _session == null ? '—' : _fmtDuration(_session!.elapsed);

  int get progressPercent =>
      _session == null ? 0 : (_session!.progress * 100).round();

  static String _fmtDuration(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes % 60;
    return h > 0 ? '${h}h ${m}m' : '${m}m';
  }

  SensorReading? _byId(String id) {
    for (final r in _readings) {
      if (r.id == id) return r;
    }
    return null;
  }

  // ── Stats reales (reemplazan los mock) ─────────────────────────────────────
  List<DashboardStat> get stats {
    if (_session == null) {
      return const [
        DashboardStat(
          label: 'FERMENTACIONES ACTIVAS',
          value: '0',
          subtitle: 'sin actividad',
          color: AppPalette.metricCyan,
        ),
      ];
    }
    final temp = _byId('temp');
    final alcohol = _byId('alcohol');
    return [
      DashboardStat(
        label: 'ESTADO',
        value: 'Activa',
        subtitle: statusLabel,
        color: const Color(0xFF75D079),
      ),
      DashboardStat(
        label: 'TIEMPO',
        value: elapsedLabel,
        subtitle: 'transcurrido',
        color: AppPalette.metricOrange,
      ),
      DashboardStat(
        label: 'TEMPERATURA',
        value: temp != null ? '${temp.displayValue}°C' : '—',
        subtitle: 'en vivo',
        color: AppPalette.metricRed,
      ),
      DashboardStat(
        label: 'ALCOHOL',
        value: alcohol != null ? '${alcohol.displayValue}%' : '—',
        subtitle: 'en vivo',
        color: AppPalette.metricCyan,
      ),
    ];
  }

  // Curva: usa el histórico en vivo del alcohol, normalizado a 0–1.
  List<ChartPoint> get chartPoints {
    final reading = _byId('alcohol') ?? (_readings.isNotEmpty ? _readings.first : null);
    if (reading == null || reading.history.isEmpty) return const [];
    final hist = reading.history;
    final maxV = hist.reduce((a, b) => a > b ? a : b);
    final denom = maxV <= 0 ? 1.0 : maxV;
    final n = hist.length;
    return [
      for (var i = 0; i < n; i++)
        ChartPoint(n == 1 ? 0.0 : i / (n - 1), (hist[i] / denom).clamp(0.0, 1.0)),
    ];
  }

  // Lista de progreso: una sola card = la fermentación activa (lote).
  List<FermentationCard> get fermentationCards {
    if (_session == null) return const [];
    return [
      FermentationCard(
        id: _session!.loteLabel,
        name: _session!.groupId != null ? 'Grupo ${_session!.groupId}' : 'Fermentación',
        stage: statusLabel,
        progress: _session!.progress,
        ringColor: AppPalette.accent,
        sessionId: _session!.id,
      ),
    ];
  }

  List<SensorReading> _buildInitialReadings() {
    return [
      _make(id: 'ph', label: 'pH', value: 0, decimals: 2, unit: '', icon: Icons.ssid_chart, color: const Color(0xFF4FA8E8)),
      _make(id: 'temp', label: 'Temperatura', value: 0, decimals: 1, unit: '°C', icon: Icons.thermostat, color: const Color(0xFFF0A646)),
      _make(id: 'alcohol', label: 'Alcohol', value: 0, decimals: 1, unit: '%v/v', icon: Icons.science, color: const Color(0xFFFF6B6B)),
      _make(id: 'conductividad', label: 'Conductividad', value: 0, decimals: 1, unit: 'mS', icon: Icons.bolt, color: const Color(0xFF14B8A6)),
      _make(id: 'turbidez', label: 'Turbidez', value: 0, decimals: 0, unit: 'NTU', icon: Icons.grain, color: const Color(0xFFA78BFA)),
      _make(id: 'rpm', label: 'RPM del motor', value: 0, decimals: 0, unit: 'rpm', icon: Icons.settings, color: const Color(0xFFF97316)),
    ];
  }

  SensorReading _make({
    required String id,
    required String label,
    required double value,
    required int decimals,
    required String unit,
    required IconData icon,
    required Color color,
  }) {
    return SensorReading(
      id: id,
      label: label,
      rawValue: value,
      decimals: decimals,
      unit: unit,
      icon: icon,
      color: color,
      history: List.filled(20, value),
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
