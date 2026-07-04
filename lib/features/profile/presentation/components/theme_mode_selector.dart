import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/presentation/theme_choice.dart';
import '../../../../shared/theme/app_palette.dart';

/// Selector de tema de 3 vías: Sistema · Claro · Oscuro.
class ThemeModeSelector extends StatelessWidget {
  final ThemeChoice choice;
  final Color surface;
  final Color border;
  final Color textMuted;
  final Color textSecondary;
  final ValueChanged<ThemeChoice> onChanged;

  const ThemeModeSelector({
    super.key,
    required this.choice,
    required this.surface,
    required this.border,
    required this.textMuted,
    required this.textSecondary,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    const options = [
      (ThemeChoice.system, 'Sistema', Icons.brightness_auto_outlined),
      (ThemeChoice.light, 'Claro', Icons.light_mode_outlined),
      (ThemeChoice.dark, 'Oscuro', Icons.dark_mode_outlined),
    ];

    return Row(
      children: options.map((o) {
        final active = choice == o.$1;
        return Expanded(
          child: GestureDetector(
            onTap: () => onChanged(o.$1),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: active
                    ? AppPalette.accent.withValues(alpha: 0.14)
                    : surface,
                border: Border.all(color: active ? AppPalette.accent : border),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Icon(
                    o.$3,
                    size: 18,
                    color: active ? AppPalette.accent : textMuted,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    o.$2,
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: active ? AppPalette.accent : textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
