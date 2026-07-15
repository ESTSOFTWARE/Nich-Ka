import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/http_client.dart';
import '../../../fermentation/data/datasource/remote/active_fermentation_datasource.dart';
import '../../../fermentation/data/repositories/active_fermentation_repository_impl.dart';
import '../../../fermentation/domain/entities/active_fermentation_session.dart';
import '../../../fermentation/domain/use_cases/get_active_fermentation_use_case.dart';
import '../../../sensors/data/datasource/remote/sensors_realtime_datasource.dart';
import '../../../sensors/data/repositories/sensors_realtime_repository_impl.dart';
import '../../../sensors/domain/entities/sensor_reading.dart';
import '../../../sensors/domain/entities/sensor_realtime_reading.dart';
import '../../../sensors/domain/repositories/sensors_realtime_repository.dart';
import '../../../sensors/domain/use_cases/watch_sensors_use_case.dart';
import '../../domain/entities/chart_point.dart';
import '../../domain/entities/dashboard_stat.dart';
import '../../domain/entities/fermentation_card.dart';
import '../components/time_range.dart';
import '../../../../shared/theme/app_palette.dart';
import 'overview_state.dart';

class OverviewNotifier extends AutoDisposeNotifier<OverviewState> {
  final SensorsRealtimeRepository _sensorsRepo = SensorsRealtimeRepositoryImpl(
    SensorsRealtimeDataSource(HttpClient.instance),
  );
  late final WatchSensorsUseCase _watchSensors;

  StreamSubscription<SensorRealtimeReading>? _sub;
  Timer? _ticker;
  ActiveFermentationSession? _session;

  static const Map<String, String> _typeToId = {
    'temperature': 'temp',
    'alcohol': 'alcohol',
    'conductivity': 'conductividad',
    'ph': 'ph',
    'turbidity': 'turbidez',
    'rpm': 'rpm',
  };

  @override
  OverviewState build() {
    ref.onDispose(_cleanup);
    return OverviewState(readings: _buildInitialReadings());
  }

  void _cleanup() {
    _sub?.cancel();
    _ticker?.cancel();
    _sensorsRepo.dispose();
  }

  Future<void> load() async {
    _watchSensors = WatchSensorsUseCase(_sensorsRepo);
    state = state.copyWith(isLoading: true);

    try {
      final useCase = GetActiveFermentationUseCase(
        ActiveFermentationRepositoryImpl(
          ActiveFermentationDatasource(HttpClient.instance),
        ),
      );
      _session = await useCase();
    } catch (_) {
      _session = null;
    }

    _rebuildFromSession();

    if (_session != null) {
      _sub = _watchSensors(_session!.circuitId).listen(_applyReading);
    }

    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 15), (_) => _refresh());
  }

  Future<void> _refresh() async {
    try {
      final useCase = GetActiveFermentationUseCase(
        ActiveFermentationRepositoryImpl(
          ActiveFermentationDatasource(HttpClient.instance),
        ),
      );
      final active = await useCase();
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
      _rebuildFromSession();
    } catch (_) {}
  }

  void _rebuildFromSession() {
    state = state.copyWith(
      isLoading: false,
      stats: _buildStats(),
      fermentationCards: _buildCards(),
    );
  }

  void _applyReading(SensorRealtimeReading r) {
    final id = _typeToId[r.sensorType];
    if (id == null) return;

    final newReadings = state.readings.map((reading) {
      if (reading.id != id) return reading;
      return reading.copyWith(
        rawValue: r.value,
        history: [...reading.history.skip(1), r.value],
        trendUp: r.value >= reading.rawValue,
      );
    }).toList();

    state = state.copyWith(
      readings: newReadings,
      stats: _buildStatsFromReadings(newReadings),
      fermentationCards: _buildCards(),
    );
  }

  void selectRange(TimeRange range) {
    if (state.selectedRange == range) return;
    state = state.copyWith(selectedRange: range);
  }

  String get greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return '¡Buenos días!';
    if (hour < 19) return '¡Buenas tardes!';
    return '¡Buenas noches!';
  }

  String get loteLabel => _session?.loteLabel ?? 'Sin lote activo';

  String get statusLabel {
    if (_session == null) return 'Sin fermentación activa';
    return _session!.isRunning ? 'En fermentación' : _session!.status;
  }

  String get elapsedLabel =>
      _session == null ? '—' : _fmtDuration(_session!.elapsed);

  int get progressPercent =>
      _session == null ? 0 : (_session!.progress * 100).round();

  bool get hasActive => _session != null;

  List<ChartPoint> get chartPoints {
    final reading = state.readings.isNotEmpty ? state.readings.first : null;
    if (reading == null || reading.history.isEmpty) return const [];
    final hist = reading.history;
    final maxV = hist.reduce((a, b) => a > b ? a : b);
    final denom = maxV <= 0 ? 1.0 : maxV;
    final n = hist.length;
    return [
      for (var i = 0; i < n; i++)
        ChartPoint(
          n == 1 ? 0.0 : i / (n - 1),
          (hist[i] / denom).clamp(0.0, 1.0),
        ),
    ];
  }

  List<DashboardStat> _buildStats() => _buildStatsFromReadings(state.readings);

  List<DashboardStat> _buildStatsFromReadings(List<SensorReading> readings) {
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
    SensorReading? byId(String id) {
      for (final r in readings) {
        if (r.id == id) return r;
      }
      return null;
    }

    final temp = byId('temp');
    final alcohol = byId('alcohol');
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

  List<FermentationCard> _buildCards() {
    if (_session == null) return const [];
    return [
      FermentationCard(
        id: _session!.loteLabel,
        name: _session!.groupId != null
            ? 'Grupo ${_session!.groupId}'
            : 'Fermentación',
        stage: statusLabel,
        progress: _session!.progress,
        ringColor: AppPalette.accent,
        sessionId: _session!.id,
      ),
    ];
  }

  static String _fmtDuration(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes % 60;
    return h > 0 ? '${h}h ${m}m' : '${m}m';
  }

  List<SensorReading> _buildInitialReadings() {
    return [
      SensorReading(
        id: 'ph',
        label: 'pH',
        rawValue: 0,
        decimals: 2,
        unit: '',
        icon: Icons.ssid_chart,
        color: const Color(0xFF4FA8E8),
        history: List.filled(20, 0.0),
      ),
      SensorReading(
        id: 'temp',
        label: 'Temperatura',
        rawValue: 0,
        decimals: 1,
        unit: '°C',
        icon: Icons.thermostat,
        color: const Color(0xFFF0A646),
        history: List.filled(20, 0.0),
      ),
      SensorReading(
        id: 'alcohol',
        label: 'Alcohol',
        rawValue: 0,
        decimals: 1,
        unit: '%v/v',
        icon: Icons.science,
        color: const Color(0xFFFF6B6B),
        history: List.filled(20, 0.0),
      ),
      SensorReading(
        id: 'conductividad',
        label: 'Conductividad',
        rawValue: 0,
        decimals: 1,
        unit: 'mS',
        icon: Icons.bolt,
        color: const Color(0xFF14B8A6),
        history: List.filled(20, 0.0),
      ),
      SensorReading(
        id: 'turbidez',
        label: 'Turbidez',
        rawValue: 0,
        decimals: 0,
        unit: 'NTU',
        icon: Icons.grain,
        color: const Color(0xFFA78BFA),
        history: List.filled(20, 0.0),
      ),
      SensorReading(
        id: 'rpm',
        label: 'RPM del motor',
        rawValue: 0,
        decimals: 0,
        unit: 'rpm',
        icon: Icons.settings,
        color: const Color(0xFFF97316),
        history: List.filled(20, 0.0),
      ),
    ];
  }
}

final overviewProvider =
    NotifierProvider.autoDispose<OverviewNotifier, OverviewState>(
      OverviewNotifier.new,
    );
