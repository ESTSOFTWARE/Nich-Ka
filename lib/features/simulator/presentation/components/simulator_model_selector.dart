import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/theme/app_palette.dart';
import '../../domain/entities/simulator_model_type.dart';

class SimulatorModelSelector extends StatelessWidget {
  final SimulatorModelType selected;
  final AppPalette palette;
  final ValueChanged<SimulatorModelType> onSelected;

  const SimulatorModelSelector({
    super.key,
    required this.selected,
    required this.palette,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: palette.border),
      ),
      child: Row(
        children: SimulatorModelType.values.map((model) {
          final isSelected = model == selected;
          return Expanded(
            child: GestureDetector(
              onTap: () => onSelected(model),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? AppPalette.accent : Colors.transparent,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Text(
                  _label(model),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected ? Colors.white : palette.textSecondary,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  String _label(SimulatorModelType model) {
    switch (model) {
      case SimulatorModelType.monod:
        return 'Monod';
      case SimulatorModelType.logistico:
        return 'Logístico';
      case SimulatorModelType.contois:
        return 'Contois';
    }
  }
}
