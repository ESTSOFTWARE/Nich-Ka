import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/class_palette.dart';

class EmptyClassesState extends StatelessWidget {
  final ClassPalette palette;
  final VoidCallback onJoinClass;

  const EmptyClassesState({
    super.key,
    required this.palette,
    required this.onJoinClass,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: ClassPalette.accent.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: ClassPalette.accent.withValues(alpha: 0.25),
              ),
            ),
            child: const Center(
              child: Icon(
                Icons.school_outlined,
                size: 32,
                color: ClassPalette.accent,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Aún no perteneces a ninguna clase',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: palette.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Únete a una clase usando el código\nde acceso proporcionado por tu profesor.',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: palette.textSecondary,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: onJoinClass,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [ClassPalette.accent, Color(0xFF4ADE80)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: ClassPalette.accent.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                'Unirme a una clase',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
