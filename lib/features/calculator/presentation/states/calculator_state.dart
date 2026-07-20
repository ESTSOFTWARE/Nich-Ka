class CalculatorState {
  final double? efficiency;
  final String substitutedFormula;

  const CalculatorState({this.efficiency, this.substitutedFormula = ''});

  CalculatorState copyWith({
    double? Function()? efficiency,
    String? substitutedFormula,
  }) => CalculatorState(
    efficiency: efficiency != null ? efficiency() : this.efficiency,
    substitutedFormula: substitutedFormula ?? this.substitutedFormula,
  );
}
