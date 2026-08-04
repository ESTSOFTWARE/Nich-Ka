import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/http_client.dart';
import '../../data/datasource/remote/sensors_realtime_datasource.dart';
import '../../data/repositories/sensors_realtime_repository_impl.dart';
import '../../domain/entities/sensor_reading.dart';
import '../../domain/entities/sensor_realtime_reading.dart';
import '../../domain/repositories/sensors_realtime_repository.dart';
import '../../domain/use_cases/get_my_circuit_id_use_case.dart';
import '../../domain/use_cases/watch_sensors_use_case.dart';
import 'sensor_detail_state.dart';

/// Family sobre la lectura inicial del sensor abierto.
class SensorDetailNotifier
    extends FamilyNotifier<SensorDetailState, SensorReading> {
  final ScrollController scrollController = ScrollController();

  late final SensorsRealtimeRepository _repository;
  late final GetMyCircuitIdUseCase _getMyCircuitId;
  late final WatchSensorsUseCase _watchSensors;
  StreamSubscription? _sub;
  String _id = '';

  static const Map<String, String> _typeToId = {
    'temperature': 'temp',
    'alcohol': 'alcohol',
    'conductivity': 'conductividad',
    'ph': 'ph',
    'turbidity': 'turbidez',
    'rpm': 'rpm',
  };

  @override
  SensorDetailState build(SensorReading initial) {
    _id = initial.id;
    _repository = SensorsRealtimeRepositoryImpl(
      SensorsRealtimeDataSource(HttpClient.instance),
    );
    _getMyCircuitId = GetMyCircuitIdUseCase(_repository);
    _watchSensors = WatchSensorsUseCase(_repository);

    scrollController.addListener(_onScroll);
    ref.onDispose(() {
      _sub?.cancel();
      _repository.dispose();
      scrollController.removeListener(_onScroll);
      scrollController.dispose();
    });

    _init();
    return SensorDetailState(reading: initial);
  }

  Future<void> _init() async {
    final circuitId = await _getMyCircuitId();
    if (circuitId == null) return;
    _sub = _watchSensors(circuitId).listen(_applyReading);
  }

  void _applyReading(SensorRealtimeReading r) {
    if (_typeToId[r.sensorType] != _id) return;
    final reading = state.reading;
    state = state.copyWith(
      reading: reading.copyWith(
        rawValue: r.value,
        history: [...reading.history.skip(1), r.value],
        trendUp: r.value >= reading.rawValue,
      ),
    );
  }

  void setWindow(String w) {
    if (state.window == w) return;
    state = state.copyWith(window: w);
  }

  void _onScroll() {
    final scrolled = scrollController.offset > 4;
    if (scrolled != state.isScrolled) {
      state = state.copyWith(isScrolled: scrolled);
    }
  }
}

final sensorDetailProvider =
    NotifierProvider.family<
      SensorDetailNotifier,
      SensorDetailState,
      SensorReading
    >(SensorDetailNotifier.new);
