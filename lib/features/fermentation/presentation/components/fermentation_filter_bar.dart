import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../home/presentation/theme/home_palette.dart';
import '../../domain/entities/fermentation_filter.dart';

class FermentationFilterBar extends StatelessWidget {
  final FermentationFilter selected;
  final HomePalette palette;
  final ValueChanged<FermentationFilter> onSelected;

  const FermentationFilterBar({
    super.key,
    required this.selected,
    required this.palette,
    required this.onSelected,
  });

  static const _labels = {
    FermentationFilter.todos: 'Todos',
    FermentationFilter.activos: 'Activos',
    FermentationFilter.secado: 'Secado',
    FermentationFilter.completados: 'Completados',
  };

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: FermentationFilter.values.map((filter) {
          final isSelected = filter == selected;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => onSelected(filter),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? palette.textPrimary : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? palette.textPrimary : palette.border,
                  ),
                ),
                child: Text(
                  _labels[filter]!,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: isSelected
                        ? palette.background
                        : palette.textSecondary,
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
