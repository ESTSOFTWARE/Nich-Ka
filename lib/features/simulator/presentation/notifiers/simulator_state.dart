import '../../domain/entities/simulator_model_type.dart';
import '../../domain/entities/simulator_point.dart';

/// Estado inmutable del simulador de fermentación.
class SimulatorState {
  final SimulatorModelType model;
  final double muMax;
  final double ks;
  final double xm;
  final double yxs;
  final double yps;
  final double x0;
  final double s0;
  final double tf;
  final List<SimulatorPoint> points;
  final bool isScrolled;

  const SimulatorState({
    this.model = SimulatorModelType.monod,
    this.muMax = 0.04,
    this.ks = 10.0,
    this.xm = 8.0,
    this.yxs = 0.50,
    this.yps = 0.45,
    this.x0 = 0.15,
    this.s0 = 200.0,
    this.tf = 200.0,
    this.points = const [],
    this.isScrolled = false,
  });

  double get finalProduct => points.isEmpty ? 0 : points.last.p;

  double get efficiency {
    final maxP = s0 * yps;
    if (maxP == 0) return 0;
    return (finalProduct / maxP) * 100;
  }

  SimulatorState copyWith({
    SimulatorModelType? model,
    double? muMax,
    double? ks,
    double? xm,
    double? yxs,
    double? yps,
    double? x0,
    double? s0,
    double? tf,
    List<SimulatorPoint>? points,
    bool? isScrolled,
  }) => SimulatorState(
    model: model ?? this.model,
    muMax: muMax ?? this.muMax,
    ks: ks ?? this.ks,
    xm: xm ?? this.xm,
    yxs: yxs ?? this.yxs,
    yps: yps ?? this.yps,
    x0: x0 ?? this.x0,
    s0: s0 ?? this.s0,
    tf: tf ?? this.tf,
    points: points ?? this.points,
    isScrolled: isScrolled ?? this.isScrolled,
  );
}
