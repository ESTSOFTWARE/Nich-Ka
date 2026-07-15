import 'package:flutter/material.dart';

import '../../../shared/theme/app_palette.dart';

Color statusColorFor(String status) {
  return switch (status) {
    'running' => AppPalette.accent,
    'completed' => const Color(0xFF75D079),
    'interrupted' => AppPalette.metricOrange,
    _ => const Color(0xFF787878),
  };
}
