import 'package:flutter/material.dart';

class DashboardStat {
  final String label;
  final String value;
  final String subtitle;
  final Color color;

  const DashboardStat({
    required this.label,
    required this.value,
    required this.subtitle,
    required this.color,
  });
}
