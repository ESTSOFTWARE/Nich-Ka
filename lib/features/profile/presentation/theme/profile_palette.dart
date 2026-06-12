import 'package:flutter/material.dart';

class ProfilePalette {
  final Color background;
  final Color surface;
  final Color rowSurface;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color border;

  const ProfilePalette({
    required this.background,
    required this.surface,
    required this.rowSurface,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.border,
  });

  static const Color accent = Color(0xFF22C55E);

  static const ProfilePalette dark = ProfilePalette(
    background: Color(0xFF0A0A0B),
    surface: Color(0xFF18181A),
    rowSurface: Color(0xFF202022),
    textPrimary: Color(0xFFFFFFFF),
    textSecondary: Color(0xFFA3A3A3),
    textMuted: Color(0xFF6B6B70),
    border: Color(0xFF2A2A2D),
  );

  static const ProfilePalette light = ProfilePalette(
    background: Color(0xFFF4EFE6),
    surface: Color(0xFFFFFFFF),
    rowSurface: Color(0xFFFFFFFF),
    textPrimary: Color(0xFF0A0A0A),
    textSecondary: Color(0xFF6B6B70),
    textMuted: Color(0xFF9AA0A6),
    border: Color(0xFFE8E2D6),
  );

  static ProfilePalette of(bool isDark) => isDark ? dark : light;
}
