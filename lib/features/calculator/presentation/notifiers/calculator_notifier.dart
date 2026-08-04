import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'calculator_state.dart';

/// Notifier de la calculadora. Mantiene los TextEditingController (los expone
/// para que la vista los enlace) y recalcula el estado en cada cambio.
class CalculatorNotifier extends Notifier<CalculatorState> {
  final sugarController = TextEditingController(text: '180');
  final ethanolController = TextEditingController(text: '8.2');
  final factorController = TextEditingController(text: '0.51');

  @override
  CalculatorState build() {
    sugarController.addListener(_recompute);
    ethanolController.addListener(_recompute);
    factorController.addListener(_recompute);
    // Los controllers viven mientras viva el provider.
    ref.onDispose(() {
      sugarController.dispose();
      ethanolController.dispose();
      factorController.dispose();
    });
    return _compute();
  }

  void _recompute() => state = _compute();

  CalculatorState _compute() {
    final sugar = double.tryParse(sugarController.text);
    final ethanol = double.tryParse(ethanolController.text);
    final factor = double.tryParse(factorController.text);

    final double? efficiency =
        (sugar == null ||
            ethanol == null ||
            factor == null ||
            sugar == 0 ||
            factor == 0)
        ? null
        : (ethanol / (sugar * factor)) * 100;

    final s = sugarController.text.isEmpty ? '?' : sugarController.text;
    final e = ethanolController.text.isEmpty ? '?' : ethanolController.text;
    final f = factorController.text.isEmpty ? '?' : factorController.text;

    return CalculatorState(
      efficiency: efficiency,
      substitutedFormula: '($e / ($s × $f)) × 100',
    );
  }
}

final calculatorProvider =
    NotifierProvider<CalculatorNotifier, CalculatorState>(
      CalculatorNotifier.new,
    );
