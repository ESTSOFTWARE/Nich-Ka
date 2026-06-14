import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../domain/entities/sensor_range.dart';
import '../../domain/entities/sensor_reading.dart';

class SensorDetailProvider extends ChangeNotifier {
  final ScrollController scrollController = ScrollController();
  bool _isScrolled = false;
  bool get isScrolled => _isScrolled;

  final _rng = math.Random();
  Timer? _timer;

  SensorReading _reading;
  SensorReading get reading => _reading;

  SensorRange get range => SensorRange.forId(_reading.id);

  String _window = '1m';
  String get window => _window;

  SensorDetailProvider(SensorReading initial) : _reading = initial {
    scrollController.addListener(_onScroll);
    _timer = Timer.periodic(const Duration(milliseconds: 1100), _onTick);
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

  void _onTick(Timer _) {
    final delta = (_rng.nextDouble() - 0.48) * _reading.rawValue * 0.008;
    final next = _reading.rawValue + delta;
    _reading = _reading.copyWith(
      rawValue: next,
      history: [..._reading.history.skip(1), next],
      trendUp: delta >= 0,
    );
    notifyListeners();
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
    _timer?.cancel();
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.dispose();
  }
}
