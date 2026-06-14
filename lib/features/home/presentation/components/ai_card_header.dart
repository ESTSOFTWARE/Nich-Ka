import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/theme/app_palette.dart';

class AiCardHeader extends StatelessWidget {
  final AppPalette palette;

  const AiCardHeader({super.key, required this.palette});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: AppPalette.accent.withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: SvgPicture.asset(
              'assets/icons/ia.svg',
              width: 16,
              height: 16,
              colorFilter: const ColorFilter.mode(
                AppPalette.accent,
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
                color: AppPalette.accent,
                height: 1.2,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
