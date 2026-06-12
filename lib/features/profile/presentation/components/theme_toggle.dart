import 'package:flutter/material.dart';
import '../theme/profile_palette.dart';
import 'theme_segment.dart';

class ThemeToggle extends StatelessWidget {
  final bool isDark;
  final ValueChanged<bool> onChanged;
  final ProfilePalette palette;

  const ThemeToggle({
    super.key,
    required this.isDark,
    required this.onChanged,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: palette.background,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: palette.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ThemeSegment(
            iconPath: 'assets/icons/light.svg',
            label: 'Claro',
            selected: !isDark,
            palette: palette,
            onTap: () => onChanged(false),
          ),
          ThemeSegment(
            iconPath: 'assets/icons/dark.svg',
            label: 'Oscuro',
            selected: isDark,
            palette: palette,
            onTap: () => onChanged(true),
          ),
        ],
      ),
    );
  }
}
