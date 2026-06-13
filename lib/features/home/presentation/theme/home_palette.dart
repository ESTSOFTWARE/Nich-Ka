import 'package:flutter/material.dart';

class HomePalette {
  final Color background;
  final Color surface;
  final Color rowSurface;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color border;
  final Color aiCardBg;
  final Color aiCardBorder;
  final Color navActive;
  final Color navInactive;
  // Pre-baked alpha (used as-is, no withValues needed)
  final Color glassBackground;
  final Color glowColor;
  final bool isDark;

  const HomePalette({
    required this.background,
    required this.surface,
    required this.rowSurface,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.border,
    required this.aiCardBg,
    required this.aiCardBorder,
    required this.navActive,
    required this.navInactive,
    required this.glassBackground,
    required this.glowColor,
    required this.isDark,
  });

  static const Color accent = Color(0xFF75D079);
  static const Color metricOrange = Color(0xFFF0A646);
  static const Color metricCyan = Color(0xFF86CDFF);
  static const Color metricRed = Color(0xFFFF9C8B);

  static const HomePalette dark = HomePalette(
    background: Color(0xFF0A0A0B),
    surface: Color(0xFF111113),
    rowSurface: Color(0xFF1A1A1C),
    textPrimary: Color(0xFFFFFFFF),
    textSecondary: Color(0xFFA3A3A3),
    textMuted: Color(0xFF525252),
    border: Color(0xFF262626),
    aiCardBg: Color(0xFF0D1F0D),
    aiCardBorder: Color(0xFF1A3A1A),
    navActive: Color(0xFFFFFFFF),
    navInactive: Color(0xFF787878),
    glassBackground: Color(0xA60A0A0B), // #0A0A0B at 65% opacity
    glowColor: Color(0x24FFFFFF), // white at ~14% opacity
    isDark: true,
  );

  static const HomePalette light = HomePalette(
    background: Color(0xFFF4EFE6),
    surface: Color(0xFFFFFFFF),
    rowSurface: Color(0xFFF0EDE8),
    textPrimary: Color(0xFF0A0A0B),
    textSecondary: Color(0xFF525252),
    textMuted: Color(0xFF9CA3AF),
    border: Color(0xFFE5E5E5),
    aiCardBg: Color(0xFFF0FBF0),
    aiCardBorder: Color(0xFFBBF7D0),
    navActive: Color(0xFF0A0A0B),
    navInactive: Color(0xFF9CA3AF),
    glassBackground: Color(0xCCF4EFE6), // cream at 80% opacity
    glowColor: Color(0x1275D079), // accent green at ~7% opacity
    isDark: false,
  );

  static HomePalette of(bool isDark) => isDark ? dark : light;
}
