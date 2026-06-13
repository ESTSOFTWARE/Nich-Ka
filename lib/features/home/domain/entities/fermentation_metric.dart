import 'package:flutter/material.dart';

class FermentationMetric {
  final String label;
  final String value;
  final String unit;
  final String change;
  final Color color;

  const FermentationMetric({
    required this.label,
    required this.value,
    required this.unit,
    required this.change,
    required this.color,
  });
}
