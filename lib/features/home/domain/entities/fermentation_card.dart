import 'package:flutter/material.dart';

class FermentationCard {
  final String id;
  final String name;
  final String stage;
  final double progress;
  final Color ringColor;

  const FermentationCard({
    required this.id,
    required this.name,
    required this.stage,
    required this.progress,
    required this.ringColor,
  });
}
