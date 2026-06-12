import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/profile_palette.dart';

class EditButton extends StatelessWidget {
  final ProfilePalette palette;
  final VoidCallback onTap;

  const EditButton({super.key, required this.palette, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: palette.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: palette.border),
        ),
        child: Text(
          'Editar',
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: palette.textPrimary,
          ),
        ),
      ),
    );
  }
}
