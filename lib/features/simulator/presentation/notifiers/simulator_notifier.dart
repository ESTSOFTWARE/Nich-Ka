import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/simulator_model_type.dart';
import '../../domain/entities/simulator_point.dart';
import 'simulator_state.dart';

class SimulatorNotifier extends Notifier<SimulatorState> {
  final ScrollController scrollController = ScrollController();

  @override
  SimulatorState build() {
    scrollController.addListener(_onScroll);
    ref.onDispose(() {
      scrollController.removeListener(_onScroll);
      scrollController.dispose();
    });
    // Resuelve con los parámetros por defecto.
    return _solve(const SimulatorState());
  }

  void _onScroll() {
    final scrolled = scrollController.offset > 4;
    if (scrolled != state.isScrolled) {
      state = state.copyWith(isScrolled: scrolled);
    }
  }

  double _mu(SimulatorState s, double x, double subs) {
    switch (s.model) {
      case SimulatorModelType.monod:
        final d = s.ks + subs;
        return d == 0 ? 0 : s.muMax * subs / d;
      case SimulatorModelType.logistico:
        if (s.xm == 0) return 0;
        return s.muMax * (1 - x / s.xm).clamp(0.0, 1.0);
      case SimulatorModelType.contois:
        final d = s.ks * x + subs;
        return d == 0 ? 0 : s.muMax * subs / d;
    }
  }

  /// Integra el modelo y devuelve el estado con los puntos calculados.
  SimulatorState _solve(SimulatorState s) {
    const steps = 300;
    final dt = s.tf / steps;
    final points = <SimulatorPoint>[];
    double x = s.x0, subs = s.s0, p = 0.0;

    for (int i = 0; i <= steps; i++) {
      points.add(SimulatorPoint(t: i * dt, x: x, s: subs, p: p));
      final mu = _mu(s, x, subs);
      final dx = mu * x * dt;
      final ds = -(mu * x / s.yxs) * dt;
      final dp = s.yps * mu * x * dt;
      x = (x + dx).clamp(0.0, double.maxFinite);
      subs = (subs + ds).clamp(0.0, double.maxFinite);
      p = (p + dp).clamp(0.0, double.maxFinite);
    }
    return s.copyWith(points: points);
  }

  void setModel(SimulatorModelType v) =>
      state = _solve(state.copyWith(model: v));

  void setMuMax(double v) =>
      state = _solve(state.copyWith(muMax: double.parse(v.toStringAsFixed(3))));

  void setKs(double v) =>
      state = _solve(state.copyWith(ks: double.parse(v.toStringAsFixed(1))));

  void setXm(double v) =>
      state = _solve(state.copyWith(xm: double.parse(v.toStringAsFixed(1))));

  void setYxs(double v) =>
      state = _solve(state.copyWith(yxs: double.parse(v.toStringAsFixed(2))));

  void setYps(double v) =>
      state = _solve(state.copyWith(yps: double.parse(v.toStringAsFixed(2))));

  void setX0(double v) =>
      state = _solve(state.copyWith(x0: double.parse(v.toStringAsFixed(2))));

  void setS0(double v) =>
      state = _solve(state.copyWith(s0: double.parse(v.toStringAsFixed(1))));

  void setTf(double v) =>
      state = _solve(state.copyWith(tf: double.parse(v.toStringAsFixed(0))));
}

final simulatorProvider = NotifierProvider<SimulatorNotifier, SimulatorState>(
  SimulatorNotifier.new,
);
