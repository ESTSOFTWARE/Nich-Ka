import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/theme/app_palette.dart';
import '../../domain/entities/chat_member.dart';

/// Hoja que muestra quién reaccionó a un mensaje, agrupado por emoji.
/// Tocar tu propia reacción la quita.
class ReactionsViewerSheet extends StatelessWidget {
  final Map<String, List<int>> reactions;
  final List<ChatMember> members;
  final int myUserId;
  final AppPalette palette;
  final void Function(String emoji) onToggle;

  const ReactionsViewerSheet({
    super.key,
    required this.reactions,
    required this.members,
    required this.myUserId,
    required this.palette,
    required this.onToggle,
  });

  ChatMember? _member(int id) => members.where((m) => m.id == id).firstOrNull;

  @override
  Widget build(BuildContext context) {
    final entries = reactions.entries.where((e) => e.value.isNotEmpty).toList();
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 12,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: palette.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Text(
            'Reacciones',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: palette.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Flexible(
            child: ListView(
              shrinkWrap: true,
              children: [
                for (final e in entries)
                  for (final uid in e.value) _row(context, e.key, uid),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(BuildContext context, String emoji, int uid) {
    final member = _member(uid);
    final name = member?.name ?? 'Usuario';
    final mine = uid == myUserId;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      onTap: mine
          ? () {
              onToggle(emoji);
              Navigator.of(context).pop();
            }
          : null,
      leading: _avatar(name, member?.avatar),
      title: Text(
        mine ? '$name (tú)' : name,
        style: GoogleFonts.poppins(color: palette.textPrimary, fontSize: 14),
      ),
      subtitle: mine
          ? Text(
              'Toca para quitar tu reacción',
              style: GoogleFonts.poppins(
                color: palette.textMuted,
                fontSize: 11,
              ),
            )
          : null,
      trailing: Text(emoji, style: const TextStyle(fontSize: 20)),
    );
  }

  Widget _avatar(String name, String? avatar) {
    final initial = Center(
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : '?',
        style: GoogleFonts.poppins(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: AppPalette.accent,
        ),
      ),
    );
    return Container(
      width: 36,
      height: 36,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppPalette.accent.withValues(alpha: 0.15),
      ),
      child: (avatar != null && avatar.isNotEmpty)
          ? Image.network(
              avatar,
              width: 36,
              height: 36,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stack) => initial,
            )
          : initial,
    );
  }
}
