import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/network/http_client.dart';
import '../../data/datasource/remote/sensors_realtime_datasource.dart';
import '../../data/repositories/sensors_realtime_repository_impl.dart';
import '../../domain/entities/sensor_range.dart';
import '../../domain/entities/sensor_reading.dart';
import '../../domain/entities/sensor_realtime_reading.dart';
import '../../domain/repositories/sensors_realtime_repository.dart';
import '../../domain/use_cases/get_my_circuit_id_use_case.dart';
import '../../domain/use_cases/watch_sensors_use_case.dart';

class SensorDetailProvider extends ChangeNotifier {
  final ScrollController scrollController = ScrollController();
  bool _isScrolled = false;
  bool get isScrolled => _isScrolled;

  final SensorsRealtimeRepository _repository;
  late final GetMyCircuitIdUseCase _getMyCircuitId;
  late final WatchSensorsUseCase _watchSensors;
  StreamSubscription? _sub;

  // Mapea el sensor_type del backend al id local de la lectura.
  static const Map<String, String> _typeToId = {
    'temperature': 'temp',
    'alcohol': 'alcohol',
    'conductivity': 'conductividad',
    'ph': 'ph',
    'turbidity': 'turbidez',
    'rpm': 'rpm',
  };

  SensorReading _reading;
  SensorReading get reading => _reading;

  SensorRange get range => SensorRange.forId(_reading.id);

  String _window = '1m';
  String get window => _window;

  SensorDetailProvider(
    SensorReading initial, {
    SensorsRealtimeRepository? repository,
  }) : _reading = initial,
       _repository =
           repository ??
           SensorsRealtimeRepositoryImpl(
             SensorsRealtimeDataSource(HttpClient.instance),
           ) {
    _getMyCircuitId = GetMyCircuitIdUseCase(_repository);
    _watchSensors = WatchSensorsUseCase(_repository);
    scrollController.addListener(_onScroll);
    _init();
  }

  Future<void> _init() async {
    final circuitId = await _getMyCircuitId();
    if (circuitId == null) return;
    _sub = _watchSensors(circuitId).listen(_applyReading);
  }

  // Solo aplica las lecturas de ESTE sensor (las demás se ignoran).
  void _applyReading(SensorRealtimeReading r) {
    if (_typeToId[r.sensorType] != _reading.id) return;
    _reading = _reading.copyWith(
      rawValue: r.value,
      history: [..._reading.history.skip(1), r.value],
      trendUp: r.value >= _reading.rawValue,
    );
    notifyListeners();
  }

  void setWindow(String w) {
    if (_window == w) return;
    _window = w;
    notifyListeners();
  }

  void _onScroll() {
    final scrolled = scrollController.offset > 4;
    if (scrolled != _isScrolled) {
      _isScrolled = scrolled;
      notifyListeners();
    }
  }

  List<double> get chartPoints => _reading.history;

  double get minValue => _reading.history.reduce(math.min);
  double get maxValue => _reading.history.reduce(math.max);
  double get avgValue {
    final sum = _reading.history.fold<double>(0, (a, b) => a + b);
    return sum / _reading.history.length;
  }

  bool get isInRange => range.isInRange(_reading.rawValue);

  String get aiInsight => isInRange
      ? '${_reading.label} se mantiene estable dentro del rango óptimo. Sin anomalías en la última hora.'
      : '${_reading.label} está fuera del rango óptimo. Revisa las condiciones del tanque.';

  @override
  void dispose() {
    _sub?.cancel();
    _repository.dispose();
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.dispose();
  }
}
