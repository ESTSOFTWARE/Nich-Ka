import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/theme/app_palette.dart';

class SimulatorSectionHeader extends StatelessWidget {
  final String label;
  final AppPalette palette;

  const SimulatorSectionHeader({
    super.key,
    required this.label,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 4),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: palette.textSecondary,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
