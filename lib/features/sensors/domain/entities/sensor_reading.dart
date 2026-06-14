import 'package:flutter/material.dart';

class SensorReading {
  final String id;
  final String label;
  final double rawValue;
  final int decimals;
  final String unit;
  final IconData icon;
  final Color color;
  final List<double> history;
  final bool isOnline;
  final bool trendUp;

  SensorReading({
    required this.id,
    required this.label,
    required this.rawValue,
    required this.decimals,
    required this.unit,
    required this.icon,
    required this.color,
    required this.history,
    this.isOnline = true,
    this.trendUp = true,
  });

  String get displayValue => rawValue.toStringAsFixed(decimals);

  SensorReading copyWith({
    double? rawValue,
    List<double>? history,
    bool? trendUp,
  }) {
    return SensorReading(
      id: id,
      label: label,
      rawValue: rawValue ?? this.rawValue,
      decimals: decimals,
      unit: unit,
      icon: icon,
      color: color,
      history: history ?? List.of(this.history),
      isOnline: isOnline,
      trendUp: trendUp ?? this.trendUp,
    );
  }
}
