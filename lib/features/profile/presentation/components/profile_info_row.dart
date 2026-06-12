import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/profile_palette.dart';

class ProfileInfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool showDivider;
  final ProfilePalette palette;

  const ProfileInfoRow({
    super.key,
    required this.label,
    required this.value,
    required this.palette,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: showDivider ? palette.border : Colors.transparent,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: palette.textSecondary,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: palette.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
