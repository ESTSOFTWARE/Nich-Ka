import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../states/calculator_state.dart';

class CalculatorNotifier extends Notifier<CalculatorState> {
  late final sugarController = TextEditingController(text: '180');
  late final ethanolController = TextEditingController(text: '8.2');
  late final factorController = TextEditingController(text: '0.51');

  @override
  CalculatorState build() {
    sugarController.addListener(_updateState);
    ethanolController.addListener(_updateState);
    factorController.addListener(_updateState);

    ref.onDispose(() {
      sugarController.dispose();
      ethanolController.dispose();
      factorController.dispose();
    });

    return _computeState();
  }

  void _updateState() {
    state = _computeState();
  }

  CalculatorState _computeState() {
    return CalculatorState(
      efficiency: _calculateEfficiency(),
      substitutedFormula: _buildFormula(),
    );
  }

  double? _calculateEfficiency() {
    final sugar = double.tryParse(sugarController.text);
    final ethanol = double.tryParse(ethanolController.text);
    final factor = double.tryParse(factorController.text);
    if (sugar == null ||
        ethanol == null ||
        factor == null ||
        sugar == 0 ||
        factor == 0) {
      return null;
    }
    return (ethanol / (sugar * factor)) * 100;
  }

  String _buildFormula() {
    final s = sugarController.text.isEmpty ? '?' : sugarController.text;
    final e = ethanolController.text.isEmpty ? '?' : ethanolController.text;
    final f = factorController.text.isEmpty ? '?' : factorController.text;
    return '($e / ($s × $f)) × 100';
  }
}

final calculatorProvider =
    NotifierProvider<CalculatorNotifier, CalculatorState>(
      CalculatorNotifier.new,
    );
