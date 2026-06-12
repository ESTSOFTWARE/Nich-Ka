import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/profile_palette.dart';

class ProfileTileRow extends StatelessWidget {
  final String? iconPath;
  final String title;
  final Widget trailing;
  final VoidCallback? onTap;
  final ProfilePalette palette;

  const ProfileTileRow({
    super.key,
    required this.title,
    required this.trailing,
    required this.palette,
    this.iconPath,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            if (iconPath != null) ...[
              SvgPicture.asset(iconPath!, width: 22, height: 22),
              const SizedBox(width: 12),
            ],
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: palette.textPrimary,
              ),
            ),
            const Spacer(),
            trailing,
          ],
        ),
      ),
    );
  }
}
