import 'package:flutter/material.dart';

class ReportsPalette {
  final Color background;
  final Color surface;
  final Color rowSurface;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color border;
  final Color filterSelectedBg;
  final Color filterSelectedText;
  final Color filterUnselectedBg;
  final Color filterUnselectedText;
  final Color glassBackground;
  final Color glowColor;
  final Color navActive;
  final Color navInactive;
  final bool isDark;

  const ReportsPalette({
    required this.background,
    required this.surface,
    required this.rowSurface,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.border,
    required this.filterSelectedBg,
    required this.filterSelectedText,
    required this.filterUnselectedBg,
    required this.filterUnselectedText,
    required this.glassBackground,
    required this.glowColor,
    required this.navActive,
    required this.navInactive,
    required this.isDark,
  });

  static const Color accent = Color(0xFF3A8F42);
  static const Color error = Color(0xFFEF4444);
  static const Color interrupted = Color(0xFFEF4444);

  static const ReportsPalette dark = ReportsPalette(
    background: Color(0xFF0A0A0B),
    surface: Color(0xFF111113),
    rowSurface: Color(0xFF1A1A1C),
    textPrimary: Color(0xFFFFFFFF),
    textSecondary: Color(0xFFA3A3A3),
    textMuted: Color(0xFF525252),
    border: Color(0xFF262626),
    filterSelectedBg: Color(0xFF262626),
    filterSelectedText: Color(0xFFFFFFFF),
    filterUnselectedBg: Colors.transparent,
    filterUnselectedText: Color(0xFF525252),
    glassBackground: Color(0xA60A0A0B),
    glowColor: Color(0x24FFFFFF),
    navActive: Color(0xFFFFFFFF),
    navInactive: Color(0xFF787878),
    isDark: true,
  );

  static const ReportsPalette light = ReportsPalette(
    background: Color(0xFFF4EFE6),
    surface: Color(0xFFFFFFFF),
    rowSurface: Color(0xFFF0EDE8),
    textPrimary: Color(0xFF0A0A0B),
    textSecondary: Color(0xFF525252),
    textMuted: Color(0xFF9CA3AF),
    border: Color(0xFFE5E5E5),
    filterSelectedBg: Color(0xFFE5E5E5),
    filterSelectedText: Color(0xFF0A0A0B),
    filterUnselectedBg: Colors.transparent,
    filterUnselectedText: Color(0xFF9CA3AF),
    glassBackground: Color(0xCCF4EFE6),
    glowColor: Color(0x1275D079),
    navActive: Color(0xFF0A0A0B),
    navInactive: Color(0xFF9CA3AF),
    isDark: false,
  );

  static ReportsPalette of(bool isDark) => isDark ? dark : light;
}
