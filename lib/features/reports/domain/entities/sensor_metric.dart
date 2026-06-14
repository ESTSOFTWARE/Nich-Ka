import 'package:flutter/material.dart';

class SensorMetric {
  final String label;
  final String initialValue;
  final String finalValue;
  final String lastValue;
  final String unit;
  final Color valueColor;
  final IconData icon;

  const SensorMetric({
    required this.label,
    required this.initialValue,
    required this.finalValue,
    required this.lastValue,
    required this.unit,
    required this.valueColor,
    required this.icon,
  });
}
