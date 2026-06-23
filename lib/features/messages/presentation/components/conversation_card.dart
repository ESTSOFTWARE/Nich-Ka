import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/entities/chat_conversation.dart';
import '../../../../shared/theme/app_palette.dart';

class ConversationCard extends StatelessWidget {
  final ChatConversation conversation;
  final int myUserId;
  final AppPalette palette;
  final VoidCallback? onTap;

  const ConversationCard({
    super.key,
    required this.conversation,
    required this.myUserId,
    required this.palette,
    this.onTap,
  });

  static const List<Color> _avatarColors = [
    Color(0xFF75D079),
    Color(0xFF60A5FA),
    Color(0xFFFBBF24),
    Color(0xFFF472B6),
    Color(0xFFA78BFA),
    Color(0xFF34D399),
  ];

  Color _avatarColor(String seed) {
    final idx = seed.codeUnits.fold(0, (a, b) => a + b) % _avatarColors.length;
    return _avatarColors[idx];
  }

  @override
  Widget build(BuildContext context) {
    final name = conversation.displayName(myUserId);
    final avatarUrl = conversation.displayAvatar(myUserId);
    final color = _avatarColor(name);
    final last = conversation.lastMessage;

    String lastText = 'Sin mensajes';
    if (last != null) {
      lastText = last.deleted
          ? 'Mensaje eliminado'
          : (last.content ?? (last.attachments.isNotEmpty ? '📎 Adjunto' : ''));
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: palette.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: palette.border),
        ),
        child: Row(
          children: [
            _buildAvatar(name, avatarUrl, color),
            const SizedBox(width: 12),
            Expanded(child: _buildInfo(name, lastText, last)),
            const SizedBox(width: 8),
            _buildMeta(last),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(String name, String? avatarUrl, Color color) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withValues(alpha: 0.15),
            border: Border.all(color: color.withValues(alpha: 0.3), width: 1.5),
          ),
          child: ClipOval(
            child: avatarUrl != null
                ? Image.network(
                    avatarUrl,
                    width: 52,
                    height: 52,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => _initial(name, color),
                  )
                : _initial(name, color),
          ),
        ),
        if (conversation.hasUnread)
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              width: 18,
              height: 18,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppPalette.accent,
                shape: BoxShape.circle,
                border: Border.all(color: palette.surface, width: 2),
              ),
              child: Text(
                conversation.unreadCount > 9 ? '9+' : '${conversation.unreadCount}',
                style: GoogleFonts.poppins(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _initial(String name, Color color) => Container(
        color: color.withValues(alpha: 0.15),
        child: Center(
          child: Text(
            name.isNotEmpty ? name[0].toUpperCase() : '?',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ),
      );

  Widget _buildInfo(String name, String lastText, dynamic last) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (conversation.isGroup)
              Padding(
                padding: const EdgeInsets.only(right: 4),
                child: Icon(Icons.group_outlined,
                    size: 13, color: palette.textMuted),
              ),
            Expanded(
              child: Text(
                name,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: palette.textPrimary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 3),
        Text(
          lastText,
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: conversation.hasUnread ? FontWeight.w500 : FontWeight.normal,
            color: conversation.hasUnread
                ? palette.textPrimary
                : palette.textSecondary,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        if (conversation.isGroup) ...[
          const SizedBox(height: 3),
          Row(
            children: [
              Icon(Icons.people_outline, size: 11, color: palette.textMuted),
              const SizedBox(width: 3),
              Text(
                '${conversation.members.length} miembros',
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  color: palette.textMuted,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildMeta(dynamic last) {
    String time = '';
    if (last != null) {
      final dt = last.createdAt as DateTime;
      time =
          '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          time,
          style: GoogleFonts.poppins(
            fontSize: 11,
            color: conversation.hasUnread ? AppPalette.accent : palette.textMuted,
            fontWeight:
                conversation.hasUnread ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        const SizedBox(height: 6),
        Icon(Icons.chevron_right, size: 18, color: palette.textMuted),
      ],
    );
  }
}
