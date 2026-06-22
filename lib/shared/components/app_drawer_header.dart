import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_palette.dart';

class AppDrawerHeader extends StatelessWidget {
  final AppPalette palette;
  final String userName;
  final String userRole;

  const AppDrawerHeader({
    super.key,
    required this.palette,
    this.userName = 'Ameth Toledo',
    this.userRole = 'ESTUDIANTE',
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppPalette.accent.withValues(alpha: 0.4),
                width: 1.5,
              ),
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/img/profile.png',
                width: 48,
                height: 48,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: palette.textPrimary,
                  height: 1.2,
                ),
              ),
              Text(
                userRole,
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: AppPalette.accent,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
