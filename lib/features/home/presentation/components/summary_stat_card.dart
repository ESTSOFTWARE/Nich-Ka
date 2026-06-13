import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/entities/dashboard_stat.dart';
import '../theme/home_palette.dart';

class SummaryStatCard extends StatelessWidget {
  final DashboardStat stat;
  final HomePalette palette;

  const SummaryStatCard({super.key, required this.stat, required this.palette});

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
            stat.label,
            style: GoogleFonts.poppins(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: palette.textMuted,
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            stat.value,
            style: GoogleFonts.poppins(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: stat.color,
              height: 1.0,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            stat.subtitle,
            style: GoogleFonts.poppins(fontSize: 11, color: palette.textMuted),
          ),
        ],
      ),
    );
  }
}
