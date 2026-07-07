import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/entities/class_member.dart';
import '../theme/class_palette.dart';
import 'class_member_avatar.dart';

class ClassMembersRow extends StatelessWidget {
  final List<ClassMember> members;
  final int totalMembers;
  final ClassPalette palette;
  final VoidCallback? onViewAll;

  const ClassMembersRow({
    super.key,
    required this.members,
    required this.totalMembers,
    required this.palette,
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    const avatarSize = 36.0;
    const overlap = 10.0;
    final visibleCount = members.length.clamp(0, 3);
    final remaining = totalMembers - visibleCount;
    final rowWidth =
        visibleCount * (avatarSize - overlap) +
        overlap +
        (remaining > 0 ? avatarSize - overlap + overlap : 0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Compañeros',
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: palette.textPrimary,
              ),
            ),
            GestureDetector(
              onTap: onViewAll,
              child: Text(
                'Ver todos →',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: palette.textSecondary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: avatarSize,
          width: rowWidth,
          child: Stack(
            children: [
              for (var i = 0; i < visibleCount; i++)
                Positioned(
                  left: i * (avatarSize - overlap),
                  child: ClassMemberAvatar(
                    initials: members[i].initials,
                    color: members[i].color,
                    borderColor: palette.background,
                    size: avatarSize,
                    avatar: members[i].avatar,
                  ),
                ),
              if (remaining > 0)
                Positioned(
                  left: visibleCount * (avatarSize - overlap),
                  child: Container(
                    width: avatarSize,
                    height: avatarSize,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: palette.surface,
                      shape: BoxShape.circle,
                      border: Border.all(color: palette.background, width: 2),
                    ),
                    child: Text(
                      '+$remaining',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: palette.textSecondary,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
