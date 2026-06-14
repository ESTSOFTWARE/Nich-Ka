import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/theme/app_palette.dart';

class JoinClassDivider extends StatelessWidget {
  final String label;
  final AppPalette palette;

  const JoinClassDivider({
    super.key,
    required this.label,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider(color: palette.border, thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: palette.textMuted,
              letterSpacing: 0.6,
            ),
          ),
        ),
        Expanded(child: Divider(color: palette.border, thickness: 1)),
      ],
    );
  }
}
