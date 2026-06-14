import 'package:flutter/material.dart';

class ClassPalette {
  final Color background;
  final Color surface;
  final Color rowSurface;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color border;
  final Color glassBackground;
  final Color glowColor;
  final bool isDark;

  const ClassPalette({
    required this.background,
    required this.surface,
    required this.rowSurface,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.border,
    required this.glassBackground,
    required this.glowColor,
    required this.isDark,
  });

  static const Color accent = Color(0xFF75D079);
  static const Color error = Color(0xFFEF4444);
  static const Color unreadBadge = Color(0xFF75D079);

  static const ClassPalette dark = ClassPalette(
    background: Color(0xFF0A0A0B),
    surface: Color(0xFF111113),
    rowSurface: Color(0xFF1A1A1C),
    textPrimary: Color(0xFFFFFFFF),
    textSecondary: Color(0xFFA3A3A3),
    textMuted: Color(0xFF525252),
    border: Color(0xFF262626),
    glassBackground: Color(0xA60A0A0B),
    glowColor: Color(0x24FFFFFF),
    isDark: true,
  );

  static const ClassPalette light = ClassPalette(
    background: Color(0xFFF4EFE6),
    surface: Color(0xFFFFFFFF),
    rowSurface: Color(0xFFF0EDE8),
    textPrimary: Color(0xFF0A0A0B),
    textSecondary: Color(0xFF525252),
    textMuted: Color(0xFF9CA3AF),
    border: Color(0xFFE5E5E5),
    glassBackground: Color(0xCCF4EFE6),
    glowColor: Color(0x1275D079),
    isDark: false,
  );

  static ClassPalette of(bool isDark) => isDark ? dark : light;
}
