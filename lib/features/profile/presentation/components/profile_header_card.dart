import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/entities/profile_user.dart';
import '../theme/profile_palette.dart';

class ProfileHeaderCard extends StatelessWidget {
  final ProfileUser user;
  final ProfilePalette palette;
  final VoidCallback? onChangePhoto;
  final bool isUploading;

  const ProfileHeaderCard({
    super.key,
    required this.user,
    required this.palette,
    this.onChangePhoto,
    this.isUploading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: palette.border),
      ),
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              _buildAvatar(),
              Positioned(
                right: -2,
                bottom: -2,
                child: GestureDetector(
                  onTap: onChangePhoto,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: ProfilePalette.accent,
                      shape: BoxShape.circle,
                      border: Border.all(color: palette.surface, width: 2),
                    ),
                    child: isUploading
                        ? const SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(
                            Icons.file_upload_outlined,
                            size: 14,
                            color: Colors.white,
                          ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            user.fullName,
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: palette.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            user.email,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: palette.textSecondary,
            ),
          ),
          const SizedBox(height: 14),
          _buildStatusBadge(),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    final imageUrl = user.profileImage;

    return CircleAvatar(
      radius: 42,
      backgroundColor: palette.rowSurface,
      child: ClipOval(
        child: imageUrl != null
            ? Image.network(
                imageUrl,
                width: 84,
                height: 84,
                fit: BoxFit.cover,
                errorBuilder: (_, e, s) => _buildLogoFallback(),
              )
            : _buildLogoFallback(),
      ),
    );
  }

  Widget _buildLogoFallback() => Padding(
    padding: const EdgeInsets.all(18),
    child: SvgPicture.asset('assets/icons/logo.svg'),
  );

  Widget _buildStatusBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: ProfilePalette.accent.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: ProfilePalette.accent.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: const BoxDecoration(
              color: ProfilePalette.accent,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 7),
          Text(
            'Activo',
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: ProfilePalette.accent,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}
