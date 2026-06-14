import 'package:flutter/material.dart';

class CalculatorProvider extends ChangeNotifier {
  final TextEditingController sugarController = TextEditingController(
    text: '180',
  );
  final TextEditingController ethanolController = TextEditingController(
    text: '8.2',
  );
  final TextEditingController factorController = TextEditingController(
    text: '0.51',
  );

  CalculatorProvider() {
    sugarController.addListener(notifyListeners);
    ethanolController.addListener(notifyListeners);
    factorController.addListener(notifyListeners);
  }

  double? get efficiency {
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

  String get substitutedFormula {
    final s = sugarController.text.isEmpty ? '?' : sugarController.text;
    final e = ethanolController.text.isEmpty ? '?' : ethanolController.text;
    final f = factorController.text.isEmpty ? '?' : factorController.text;
    return '($e / ($s × $f)) × 100';
  }

  @override
  void dispose() {
    sugarController.dispose();
    ethanolController.dispose();
    factorController.dispose();
    super.dispose();
  }
}
