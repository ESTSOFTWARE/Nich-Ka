import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/http_client.dart';
import '../../../sensors/data/datasource/remote/sensors_realtime_datasource.dart';
import '../../../sensors/data/repositories/sensors_realtime_repository_impl.dart';
import '../../../sensors/domain/entities/sensor_realtime_reading.dart';
import '../../../sensors/domain/repositories/sensors_realtime_repository.dart';
import '../../../sensors/domain/use_cases/watch_sensors_use_case.dart';
import '../../data/datasource/remote/active_fermentation_datasource.dart';
import '../../data/repositories/active_fermentation_repository_impl.dart';
import '../../domain/use_cases/get_active_fermentation_use_case.dart';
import 'fermentation_detail_state.dart';

class FermentationDetailNotifier extends Notifier<FermentationDetailState> {
  final ScrollController scrollController = ScrollController();

  late final GetActiveFermentationUseCase _getActive;
  late final SensorsRealtimeRepository _sensorsRepo;
  late final WatchSensorsUseCase _watchSensors;
  StreamSubscription? _sub;
  StreamSubscription<void>? _stopSub;
  Timer? _ticker;

  @override
  FermentationDetailState build() {
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
      _stopSub?.cancel();
      _ticker?.cancel();
      _sensorsRepo.dispose();
      scrollController.removeListener(_onScroll);
      scrollController.dispose();
    });

    _init();
    return const FermentationDetailState();
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

    // Fin de fermentación → llega por WebSocket (sin polling mientras corre).
    _stopSub = _sensorsRepo.onFermentationStopped.listen((_) {
      if (state.session != null) {
        _sub?.cancel();
        _sub = null;
        state = state.copyWith(clearSession: true);
      }
    });

    // Ticker solo para detectar el INICIO de una fermentación mientras no hay.
    _ticker = Timer.periodic(const Duration(seconds: 20), (_) => _refresh());
  }

  Future<void> _refresh() async {
    if (state.session != null) return;
    try {
      final active = await _getActive();
      if (active != null) {
        _sub = _watchSensors(active.circuitId).listen(_applyReading);
        state = state.copyWith(session: active);
      }
    } catch (_) {
      /* reintenta luego */
    }
  }

  void _applyReading(SensorRealtimeReading r) {
    final live = {...state.live, r.sensorType: r.value};
    var tempHistory = state.tempHistory;
    if (r.sensorType == 'temperature') {
      tempHistory = [...tempHistory, r.value];
      if (tempHistory.length > 24) tempHistory = tempHistory.sublist(1);
    }
    state = state.copyWith(live: live, tempHistory: tempHistory);
  }

  void _onScroll() {
    final scrolled = scrollController.offset > 4;
    if (scrolled != state.isScrolled) {
      state = state.copyWith(isScrolled: scrolled);
    }
  }
}

final fermentationDetailProvider =
    NotifierProvider<FermentationDetailNotifier, FermentationDetailState>(
      FermentationDetailNotifier.new,
    );
