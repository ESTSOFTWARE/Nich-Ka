import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/presentation/responsive.dart';
import '../theme/app_palette.dart';

class AppDrawerHeader extends StatelessWidget {
  final AppPalette palette;
  final String userName;
  final String userRole;
  final String? profileImage;

  const AppDrawerHeader({
    super.key,
    required this.palette,
    this.userName = 'Usuario',
    this.userRole = 'ESTUDIANTE',
    this.profileImage,
  });

  @override
  Widget build(BuildContext context) {
    final avatar = isTablet(context) ? 64.0 : 48.0;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      child: Row(
        children: [
          Container(
            width: avatar,
            height: avatar,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppPalette.accent.withValues(alpha: 0.4),
                width: 1.5,
              ),
            ),
            child: ClipOval(child: _buildAvatar(avatar)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
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
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(double size) {
    if (profileImage != null) {
      return Image.network(
        profileImage!,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => _buildLogoFallback(size),
      );
    }
    return _buildLogoFallback(size);
  }

  Widget _buildLogoFallback(double size) => Container(
    width: size,
    height: size,
    color: AppPalette.accent.withValues(alpha: 0.1),
    child: Padding(
      padding: const EdgeInsets.all(10),
      child: SvgPicture.asset('assets/icons/logo.svg'),
    ),
  );
}
