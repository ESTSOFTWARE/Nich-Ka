part of 'class_members_view.dart';

class _MemberTile extends StatelessWidget {
  final ClassMember member;
  final ClassPalette palette;

  const _MemberTile({required this.member, required this.palette});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/user-detail', extra: member),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: palette.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: palette.border),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: member.color.withValues(alpha: 0.2),
                shape: BoxShape.circle,
                border: Border.all(
                  color: member.color.withValues(alpha: 0.4),
                  width: 1.5,
                ),
              ),
              child: (member.avatar == null || member.avatar!.isEmpty)
                  ? Text(
                      member.initials,
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: member.color,
                      ),
                    )
                  : ClipOval(
                      child: Image.network(
                        member.avatar!,
                        width: 44,
                        height: 44,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stack) => Text(
                          member.initials,
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: member.color,
                          ),
                        ),
                      ),
                    ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    member.name,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: palette.textPrimary,
                    ),
                  ),
                  if (member.email != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      member.email!,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: palette.textSecondary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
