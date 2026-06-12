import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';

class LegalFooter extends StatelessWidget {
  const LegalFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final linkStyle = GoogleFonts.poppins(
      fontSize: 12,
      color: AppColors.textMuted,
      decoration: TextDecoration.underline,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () => context.push('/privacy'),
          child: Text('Términos de Privacidad', style: linkStyle),
        ),
        Text('  |  ', style: linkStyle.copyWith(decoration: null)),
        GestureDetector(
          onTap: () => context.push('/terms'),
          child: Text('Términos de uso', style: linkStyle),
        ),
      ],
    );
  }
}
