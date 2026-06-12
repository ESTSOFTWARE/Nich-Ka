import 'package:flutter/material.dart';

/// Responsabilidad única: centralizar los tokens de color de la app.
/// Los widgets NO deben hardcodear colores; deben referenciar estos tokens.
class AppColors {
  AppColors._();

  /// Fondo base ultra oscuro de las pantallas.
  static const Color background = Color(0xFF0A0A0B);

  /// Superficie de inputs/botones secundarios (neutral-900).
  static const Color surface = Color(0xFF171717);

  /// Borde sutil de inputs/botones (neutral-800).
  static const Color border = Color(0xFF262626);

  /// Texto principal sobre fondo oscuro.
  static const Color textPrimary = Colors.white;

  /// Texto secundario / etiquetas (neutral-400).
  static const Color textSecondary = Color(0xFFA3A3A3);

  /// Texto atenuado / placeholders / pies (neutral-600).
  static const Color textMuted = Color(0xFF525252);

  /// Acento verde de la marca (green-500), usado en focus.
  static const Color accent = Color(0xFF22C55E);

  /// Luz del efecto spotlight.
  static const Color spotlight = Colors.white;
}
