import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/home_palette.dart';

class AiCardHeader extends StatelessWidget {
  final HomePalette palette;

  const AiCardHeader({super.key, required this.palette});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: HomePalette.accent.withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: SvgPicture.asset(
              'assets/icons/ia.svg',
              width: 16,
              height: 16,
              colorFilter: const ColorFilter.mode(
                HomePalette.accent,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Asistente Nich-Ka',
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: palette.textPrimary,
                height: 1.2,
              ),
            ),
            Text(
              '· activo',
              style: GoogleFonts.poppins(
                fontSize: 11,
                color: HomePalette.accent,
                height: 1.2,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
