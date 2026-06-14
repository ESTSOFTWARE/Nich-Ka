import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/entities/report_period_filter.dart';
import '../theme/reports_palette.dart';

class ReportsFilterBar extends StatelessWidget {
  final ReportPeriodFilter selected;
  final ReportsPalette palette;
  final ValueChanged<ReportPeriodFilter> onSelected;

  const ReportsFilterBar({
    super.key,
    required this.selected,
    required this.palette,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: ReportPeriodFilter.values.map((filter) {
          final isSelected = filter == selected;
          return Padding(
            padding: EdgeInsets.only(
              right: filter == ReportPeriodFilter.values.last ? 0 : 8,
            ),
            child: GestureDetector(
              onTap: () => onSelected(filter),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? palette.filterSelectedBg
                      : palette.filterUnselectedBg,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? palette.border : palette.border,
                  ),
                ),
                child: Text(
                  filter.label,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected
                        ? palette.filterSelectedText
                        : palette.filterUnselectedText,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
