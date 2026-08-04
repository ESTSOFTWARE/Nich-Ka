/// Estado inmutable de la calculadora de eficiencia. Se recalcula cada vez que
/// cambian los inputs.
class CalculatorState {
  final double? efficiency;
  final String substitutedFormula;

  const CalculatorState({
    this.efficiency,
    this.substitutedFormula = '(? / (? × ?)) × 100',
  });

  CalculatorState copyWith({double? efficiency, String? substitutedFormula}) =>
      CalculatorState(
        efficiency: efficiency,
        substitutedFormula: substitutedFormula ?? this.substitutedFormula,
      );
}
