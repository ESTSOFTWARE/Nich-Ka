import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/entities/class_summary.dart';
import '../states/ui_state.dart';
import '../theme/class_palette.dart';

class ClassesHeader extends StatelessWidget {
  final UiState<ClassSummary> summaryState;
  final ClassPalette palette;
  final VoidCallback onJoinClass;

  const ClassesHeader({
    super.key,
    required this.summaryState,
    required this.palette,
    required this.onJoinClass,
  });

  @override
  Widget build(BuildContext context) {
    final subtitle = switch (summaryState) {
      UiSuccess<ClassSummary>(:final data) =>
        '${data.totalGroups} grupos · ${data.unreadItems} elementos sin leer',
      _ => 'Cargando...',
    };

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Mis clases',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: palette.textPrimary,
                  letterSpacing: -0.5,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: palette.textSecondary,
                ),
              ),
            ],
          ),
        ),
        _buildJoinButton(),
      ],
    );
  }

  Widget _buildJoinButton() {
    return GestureDetector(
      onTap: onJoinClass,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add, size: 16, color: palette.isDark ? Colors.black : Colors.black),
            const SizedBox(width: 6),
            Text(
              'Unirme',
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: palette.isDark ? Colors.black : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
