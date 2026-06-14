import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/class_palette.dart';

class ClassTeacherCard extends StatelessWidget {
  final String name;
  final String email;
  final String initials;
  final Color avatarColor;
  final ClassPalette palette;

  const ClassTeacherCard({
    super.key,
    required this.name,
    required this.email,
    required this.initials,
    required this.avatarColor,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: palette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'PROFESOR',
            style: GoogleFonts.poppins(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: palette.textMuted,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: avatarColor,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  initials,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: palette.textPrimary,
                      ),
                    ),
                    Text(
                      email,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: palette.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 36,
                height: 36,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: palette.border),
                ),
                child: Icon(
                  Icons.mail_outline,
                  size: 17,
                  color: palette.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
