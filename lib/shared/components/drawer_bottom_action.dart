import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_palette.dart';

class DrawerBottomAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final AppPalette palette;
  final VoidCallback onTap;

  const DrawerBottomAction({
    super.key,
    required this.icon,
    required this.label,
    required this.palette,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 20, color: palette.textSecondary),
            const SizedBox(width: 14),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: palette.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
