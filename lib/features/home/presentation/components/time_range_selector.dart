import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/theme/app_palette.dart';
import 'time_range.dart';

class TimeRangeSelector extends StatelessWidget {
  final TimeRange selected;
  final AppPalette palette;
  final ValueChanged<TimeRange> onSelected;

  const TimeRangeSelector({
    super.key,
    required this.selected,
    required this.palette,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: TimeRange.values.map((range) {
        final isSelected = range == selected;
        return GestureDetector(
          onTap: () => onSelected(range),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: isSelected ? palette.rowSurface : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              range.label,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? palette.textPrimary : palette.textMuted,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
