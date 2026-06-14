import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/entities/class_item.dart';
import '../theme/class_palette.dart';

class ClassCard extends StatelessWidget {
  final ClassItem item;
  final ClassPalette palette;
  final VoidCallback? onTap;

  const ClassCard({
    super.key,
    required this.item,
    required this.palette,
    this.onTap,
  });

  static const double _coverSize = 76;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: palette.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: palette.border),
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildCover(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: _buildInfo(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Align(
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.chevron_right,
                    size: 20,
                    color: palette.textMuted,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCover() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(14),
            bottomLeft: Radius.circular(14),
          ),
          child: SizedBox(
            width: _coverSize,
            child: item.imageUrl != null
                ? Image.asset(
              item.imageUrl!,
              fit: BoxFit.cover,
            )
                : Container(
              color: ClassPalette.accent.withValues(alpha: 0.10),
              child: Center(
                child: Text(
                  item.subject.isNotEmpty
                      ? item.subject[0].toUpperCase()
                      : item.name[0].toUpperCase(),
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: ClassPalette.accent,
                  ),
                ),
              ),
            ),
          ),
        ),
        if (item.hasUnread)
          Positioned(
            top: -6,
            right: -6,
            child: _buildUnreadBadge(),
          ),
      ],
    );
  }

  Widget _buildInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          item.subject.toUpperCase(),
          style: GoogleFonts.poppins(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.6,
            color: ClassPalette.accent,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          item.name,
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: palette.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Container(
              width: 18,
              height: 18,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: ClassPalette.accent,
                shape: BoxShape.circle,
              ),
              child: Text(
                item.professor.isNotEmpty
                    ? item.professor[0].toUpperCase()
                    : '?',
                style: GoogleFonts.poppins(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                '${item.professor} · ${item.studentCount}',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: palette.textSecondary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 4),
            Icon(Icons.person_outline, size: 14, color: palette.textMuted),
          ],
        ),
      ],
    );
  }

  Widget _buildUnreadBadge() {
    return Container(
      width: 22,
      height: 22,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: ClassPalette.unreadBadge,
        shape: BoxShape.circle,
        border: Border.all(color: palette.surface, width: 2),
      ),
      child: Text(
        '${item.unreadCount}',
        style: GoogleFonts.poppins(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: Colors.black,
        ),
      ),
    );
  }
}