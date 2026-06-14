import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/class_palette.dart';

class ClassStatTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final ClassPalette palette;

  const ClassStatTile({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: palette.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: palette.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 16, color: palette.textMuted),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: palette.textMuted,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: palette.textPrimary,
                height: 1.1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
