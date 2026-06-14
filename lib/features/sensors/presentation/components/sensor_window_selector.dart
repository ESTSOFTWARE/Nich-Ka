import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/theme/app_palette.dart';

class SensorWindowSelector extends StatelessWidget {
  final String selected;
  final Color color;
  final AppPalette palette;
  final ValueChanged<String> onChanged;

  const SensorWindowSelector({
    super.key,
    required this.selected,
    required this.color,
    required this.palette,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: ['1m', '5m', '1h'].map((w) {
        final active = w == selected;
        return GestureDetector(
          onTap: () => onChanged(w),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            margin: const EdgeInsets.only(left: 4),
            decoration: BoxDecoration(
              color: active
                  ? color.withValues(alpha: 0.15)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: active ? color : palette.border),
            ),
            child: Text(
              w,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: active ? FontWeight.w600 : FontWeight.normal,
                color: active ? color : palette.textMuted,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
