import 'package:flutter/material.dart';
import '../../domain/entities/simulator_model_type.dart';
import '../../domain/entities/simulator_point.dart';

class SimulatorProvider extends ChangeNotifier {
  SimulatorModelType _model = SimulatorModelType.monod;
  double _muMax = 0.04;
  double _ks = 10.0;
  double _xm = 8.0;
  double _yxs = 0.50;
  double _yps = 0.45;
  double _x0 = 0.15;
  double _s0 = 200.0;
  double _tf = 200.0;

  List<SimulatorPoint> _points = [];

  final ScrollController scrollController = ScrollController();
  bool _isScrolled = false;
  bool get isScrolled => _isScrolled;

  SimulatorModelType get model => _model;
  double get muMax => _muMax;
  double get ks => _ks;
  double get xm => _xm;
  double get yxs => _yxs;
  double get yps => _yps;
  double get x0 => _x0;
  double get s0 => _s0;
  double get tf => _tf;
  List<SimulatorPoint> get points => _points;

  double get finalProduct => _points.isEmpty ? 0 : _points.last.p;

  double get efficiency {
    final maxP = _s0 * _yps;
    if (maxP == 0) return 0;
    return (finalProduct / maxP) * 100;
  }

  SimulatorProvider() {
    scrollController.addListener(_onScroll);
    _solve();
  }

  void _onScroll() {
    final scrolled = scrollController.offset > 4;
    if (scrolled != _isScrolled) {
      _isScrolled = scrolled;
      notifyListeners();
    }
  }

  double _mu(double x, double s) {
    switch (_model) {
      case SimulatorModelType.monod:
        final d = _ks + s;
        return d == 0 ? 0 : _muMax * s / d;
      case SimulatorModelType.logistico:
        if (_xm == 0) return 0;
        return _muMax * (1 - x / _xm).clamp(0.0, 1.0);
      case SimulatorModelType.contois:
        final d = _ks * x + s;
        return d == 0 ? 0 : _muMax * s / d;
    }
  }

  void _solve() {
    const steps = 300;
    final dt = _tf / steps;
    _points = [];
    double x = _x0, s = _s0, p = 0.0;

    for (int i = 0; i <= steps; i++) {
      _points.add(SimulatorPoint(t: i * dt, x: x, s: s, p: p));
      final mu = _mu(x, s);
      final dx = mu * x * dt;
      final ds = -(mu * x / _yxs) * dt;
      final dp = _yps * mu * x * dt;
      x = (x + dx).clamp(0.0, double.maxFinite);
      s = (s + ds).clamp(0.0, double.maxFinite);
      p = (p + dp).clamp(0.0, double.maxFinite);
    }
    notifyListeners();
  }

  void setModel(SimulatorModelType v) { _model = v; _solve(); }
  void setMuMax(double v) { _muMax = double.parse(v.toStringAsFixed(3)); _solve(); }
  void setKs(double v) { _ks = double.parse(v.toStringAsFixed(1)); _solve(); }
  void setXm(double v) { _xm = double.parse(v.toStringAsFixed(1)); _solve(); }
  void setYxs(double v) { _yxs = double.parse(v.toStringAsFixed(2)); _solve(); }
  void setYps(double v) { _yps = double.parse(v.toStringAsFixed(2)); _solve(); }
  void setX0(double v) { _x0 = double.parse(v.toStringAsFixed(2)); _solve(); }
  void setS0(double v) { _s0 = double.parse(v.toStringAsFixed(1)); _solve(); }
  void setTf(double v) { _tf = double.parse(v.toStringAsFixed(0)); _solve(); }

  @override
  void dispose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.dispose();
  }
}
