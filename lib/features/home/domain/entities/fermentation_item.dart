import 'package:flutter/material.dart';

class FermentationItem {
  final String id;
  final String name;
  final String process;
  final String farm;
  final String statusLabel;
  final Color statusColor;
  final String timeInfo;
  final double ringProgress;
  final Color ringColor;
  final int? sessionId; // id de la sesión, para abrir su reporte

  const FermentationItem({
    required this.id,
    required this.name,
    required this.process,
    required this.farm,
    required this.statusLabel,
    required this.statusColor,
    required this.timeInfo,
    required this.ringProgress,
    required this.ringColor,
    this.sessionId,
  });
}
