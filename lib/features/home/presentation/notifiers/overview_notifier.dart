import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/http_client.dart';
import '../../../../features/fermentation/data/datasource/remote/active_fermentation_datasource.dart';
import '../../../../features/fermentation/data/repositories/active_fermentation_repository_impl.dart';
import '../../../../features/fermentation/domain/use_cases/get_active_fermentation_use_case.dart';
import '../../../../features/sensors/data/datasource/remote/sensors_realtime_datasource.dart';
import '../../../../features/sensors/data/repositories/sensors_realtime_repository_impl.dart';
import '../../../../features/sensors/domain/entities/sensor_reading.dart';
import '../../../../features/sensors/domain/entities/sensor_realtime_reading.dart';
import '../../../../features/sensors/domain/repositories/sensors_realtime_repository.dart';
import '../../../../features/sensors/domain/use_cases/watch_sensors_use_case.dart';
import '../components/time_range.dart';
import 'overview_state.dart';

class OverviewNotifier extends Notifier<OverviewState> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController scrollController = ScrollController();

  late final GetActiveFermentationUseCase _getActive;
  late final SensorsRealtimeRepository _sensorsRepo;
  late final WatchSensorsUseCase _watchSensors;
  StreamSubscription? _sub;
  Timer? _ticker;

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
    _getActive = GetActiveFermentationUseCase(
      ActiveFermentationRepositoryImpl(
        ActiveFermentationDatasource(HttpClient.instance),
      ),
    );
    _sensorsRepo = SensorsRealtimeRepositoryImpl(
      SensorsRealtimeDataSource(HttpClient.instance),
    );
    _watchSensors = WatchSensorsUseCase(_sensorsRepo);

    scrollController.addListener(_onScroll);
    ref.onDispose(() {
      _sub?.cancel();
      _ticker?.cancel();
      _sensorsRepo.dispose();
      scrollController.removeListener(_onScroll);
      scrollController.dispose();
    });

    _init();
    return OverviewState(readings: _buildInitialReadings());
  }

  Future<void> _init() async {
    try {
      final session = await _getActive();
      state = state.copyWith(session: session, isLoading: false);
    } catch (_) {
      state = state.copyWith(clearSession: true, isLoading: false);
    }
    if (state.session != null) {
      _sub = _watchSensors(state.session!.circuitId).listen(_applyReading);
    }
    _ticker = Timer.periodic(const Duration(seconds: 15), (_) => _refresh());
  }

  Future<void> _refresh() async {
    try {
      final active = await _getActive();
      if (active == null) {
        if (state.session != null) {
          await _sub?.cancel();
          _sub = null;
          state = state.copyWith(clearSession: true);
        }
      } else {
        final wasNull = state.session == null;
        state = state.copyWith(session: active);
        if (wasNull) {
          _sub = _watchSensors(active.circuitId).listen(_applyReading);
        }
      }
    } catch (_) {
      /* sin conexión: reintenta en el próximo tick */
    }
  }

  void _applyReading(SensorRealtimeReading r) {
    final id = _typeToId[r.sensorType];
    if (id == null) return;

    var changed = false;
    final readings = state.readings.map((reading) {
      if (reading.id != id) return reading;
      changed = true;
      return reading.copyWith(
        rawValue: r.value,
        history: [...reading.history.skip(1), r.value],
        trendUp: r.value >= reading.rawValue,
      );
    }).toList();

    if (changed) state = state.copyWith(readings: readings);
  }

  void _onScroll() {
    final scrolled = scrollController.offset > 4;
    if (scrolled != state.isScrolled) {
      state = state.copyWith(isScrolled: scrolled);
    }
  }

  void selectRange(TimeRange range) {
    if (state.selectedRange == range) return;
    state = state.copyWith(selectedRange: range);
  }

  List<SensorReading> _buildInitialReadings() => [
    _make(
      id: 'ph',
      label: 'pH',
      value: 0,
      decimals: 2,
      unit: '',
      icon: Icons.ssid_chart,
      color: const Color(0xFF4FA8E8),
    ),
    _make(
      id: 'temp',
      label: 'Temperatura',
      value: 0,
      decimals: 1,
      unit: '°C',
      icon: Icons.thermostat,
      color: const Color(0xFFF0A646),
    ),
    _make(
      id: 'alcohol',
      label: 'Alcohol',
      value: 0,
      decimals: 1,
      unit: '%v/v',
      icon: Icons.science,
      color: const Color(0xFFFF6B6B),
    ),
    _make(
      id: 'conductividad',
      label: 'Conductividad',
      value: 0,
      decimals: 1,
      unit: 'mS',
      icon: Icons.bolt,
      color: const Color(0xFF14B8A6),
    ),
    _make(
      id: 'turbidez',
      label: 'Turbidez',
      value: 0,
      decimals: 0,
      unit: 'NTU',
      icon: Icons.grain,
      color: const Color(0xFFA78BFA),
    ),
    _make(
      id: 'rpm',
      label: 'RPM del motor',
      value: 0,
      decimals: 0,
      unit: 'rpm',
      icon: Icons.settings,
      color: const Color(0xFFF97316),
    ),
  ];

  SensorReading _make({
    required String id,
    required String label,
    required double value,
    required int decimals,
    required String unit,
    required IconData icon,
    required Color color,
  }) => SensorReading(
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

final overviewProvider = NotifierProvider<OverviewNotifier, OverviewState>(
  OverviewNotifier.new,
);
