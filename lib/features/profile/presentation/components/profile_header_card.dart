import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/entities/profile_user.dart';
import '../theme/profile_palette.dart';
import 'role_badge.dart';

class ProfileHeaderCard extends StatelessWidget {
  final ProfileUser user;
  final ProfilePalette palette;
  final VoidCallback? onChangePhoto;

  const ProfileHeaderCard({
    super.key,
    required this.user,
    required this.palette,
    this.onChangePhoto,
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
              CircleAvatar(
                radius: 42,
                backgroundColor: palette.rowSurface,
                backgroundImage: const AssetImage('assets/img/profile.png'),
              ),
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
                    child: const Icon(
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
          RoleBadge(role: user.role),
        ],
      ),
    );
  }
}
