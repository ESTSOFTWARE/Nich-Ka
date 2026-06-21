import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../core/network/http_client.dart';
import '../../data/datasource/remote/sensors_realtime_datasource.dart';
import '../../data/repositories/sensors_realtime_repository_impl.dart';
import '../../domain/entities/sensor_reading.dart';
import '../../domain/entities/sensor_realtime_reading.dart';
import '../../domain/entities/sensors_status.dart';
import '../../domain/repositories/sensors_realtime_repository.dart';
import '../../domain/use_cases/get_my_circuit_id_use_case.dart';
import '../../domain/use_cases/watch_sensors_use_case.dart';

class SensorsProvider extends ChangeNotifier {
  final ScrollController scrollController = ScrollController();
  bool _isScrolled = false;
  bool get isScrolled => _isScrolled;

  final _rng = Random();
  final SensorsRealtimeRepository _repository;
  final GetMyCircuitIdUseCase _getMyCircuitId;
  final WatchSensorsUseCase _watchSensors;
  StreamSubscription? _sub;

  static const Map<String, String> _typeToId = {
    'temperature': 'temp',
    'alcohol': 'alcohol',
    'conductivity': 'conductividad',
    'ph': 'ph',
    'turbidity': 'turbidez',
    'rpm': 'rpm',
  };

  late List<SensorReading> _readings;
  List<SensorReading> get readings => _readings;

  final SensorsStatus status = const SensorsStatus(
    online: 6,
    total: 6,
    allInRange: true,
    statusLabel: 'Todo en rango óptimo',
    fermentationId: 'F-024',
    variety: 'Caturra',
  );

  SensorsProvider({SensorsRealtimeRepository? repository})
    : this._(
        repository ??
            SensorsRealtimeRepositoryImpl(
              SensorsRealtimeDataSource(HttpClient.instance),
            ),
      );

  SensorsProvider._(SensorsRealtimeRepository repository)
    : _repository = repository,
      _getMyCircuitId = GetMyCircuitIdUseCase(repository),
      _watchSensors = WatchSensorsUseCase(repository) {
    scrollController.addListener(_onScroll);
    _readings = _buildInitialReadings();
    _init();
  }

  Future<void> _init() async {
    final circuitId = await _getMyCircuitId();
    if (circuitId == null) return;
    _sub = _watchSensors(circuitId).listen(_applyReading);
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

  List<SensorReading> _buildInitialReadings() {
    return [
      _make(
        id: 'ph',
        label: 'pH',
        value: 4.10,
        decimals: 2,
        unit: '',
        icon: Icons.ssid_chart,
        color: const Color(0xFF4FA8E8),
      ),
      _make(
        id: 'temp',
        label: 'Temperatura',
        value: 23.5,
        decimals: 1,
        unit: '°C',
        icon: Icons.thermostat,
        color: const Color(0xFFF0A646),
      ),
      _make(
        id: 'alcohol',
        label: 'Alcohol',
        value: 6.1,
        decimals: 1,
        unit: '%v/v',
        icon: Icons.science,
        color: const Color(0xFFFF6B6B),
      ),
      _make(
        id: 'conductividad',
        label: 'Conductividad',
        value: 3.1,
        decimals: 1,
        unit: 'mS',
        icon: Icons.bolt,
        color: const Color(0xFF14B8A6),
      ),
      _make(
        id: 'turbidez',
        label: 'Turbidez',
        value: 173,
        decimals: 0,
        unit: 'NTU',
        icon: Icons.grain,
        color: const Color(0xFFA78BFA),
      ),
      _make(
        id: 'rpm',
        label: 'RPM del motor',
        value: 120,
        decimals: 0,
        unit: 'rpm',
        icon: Icons.settings,
        color: const Color(0xFFF97316),
      ),
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
    final history = List.generate(20, (i) {
      final noise = (_rng.nextDouble() - 0.5) * value * 0.04;
      return value + noise;
    });
    return SensorReading(
      id: id,
      label: label,
      rawValue: value,
      decimals: decimals,
      unit: unit,
      icon: icon,
      color: color,
      history: history,
    );
  }

  @override
  void dispose() {
    _sub?.cancel();
    _repository.dispose();
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.dispose();
  }
}
