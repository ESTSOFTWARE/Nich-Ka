class SensorRange {
  final double min;
  final double max;
  final double optimalMin;
  final double optimalMax;
  final String contextLabel;

  const SensorRange({
    required this.min,
    required this.max,
    required this.optimalMin,
    required this.optimalMax,
    required this.contextLabel,
  });

  static const _ranges = <String, SensorRange>{
    'ph': SensorRange(
      min: 2,
      max: 7,
      optimalMin: 3.5,
      optimalMax: 4.5,
      contextLabel: 'Acidez del mosto',
    ),
    'temp': SensorRange(
      min: 18,
      max: 30,
      optimalMin: 20,
      optimalMax: 25,
      contextLabel: 'Calor del tanque',
    ),
    'alcohol': SensorRange(
      min: 0,
      max: 15,
      optimalMin: 5,
      optimalMax: 8,
      contextLabel: 'Contenido alcohólico',
    ),
    'conductividad': SensorRange(
      min: 0,
      max: 10,
      optimalMin: 2,
      optimalMax: 5,
      contextLabel: 'Conductividad eléctrica',
    ),
    'turbidez': SensorRange(
      min: 0,
      max: 500,
      optimalMin: 100,
      optimalMax: 250,
      contextLabel: 'Claridad del mosto',
    ),
    'rpm': SensorRange(
      min: 0,
      max: 300,
      optimalMin: 80,
      optimalMax: 160,
      contextLabel: 'Agitación del tanque',
    ),
  };

  static SensorRange forId(String id) =>
      _ranges[id] ??
      const SensorRange(
        min: 0,
        max: 100,
        optimalMin: 30,
        optimalMax: 70,
        contextLabel: '',
      );

  bool isInRange(double value) => value >= optimalMin && value <= optimalMax;

  String get optimalLabel {
    String fmt(double v) =>
        v % 1 == 0 ? v.toInt().toString() : v.toStringAsFixed(1);
    return 'óptimo ${fmt(optimalMin)}–${fmt(optimalMax)}';
  }
}
