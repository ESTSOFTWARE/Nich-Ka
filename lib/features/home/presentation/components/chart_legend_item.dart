import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/home_palette.dart';

class ChartLegendItem extends StatelessWidget {
  final Color dotColor;
  final String label;
  final HomePalette palette;

  const ChartLegendItem({
    super.key,
    required this.dotColor,
    required this.label,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 11,
            color: palette.textSecondary,
          ),
        ),
      ],
    );
  }
}
