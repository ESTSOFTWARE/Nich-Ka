import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/entities/chat_message.dart';
import '../../../../shared/theme/app_palette.dart';

const _quickEmojis = ['👍', '❤️', '😂', '😮', '😢', '🔥', '👏', '🎉'];

Future<void> showMessageActionsSheet({
  required BuildContext context,
  required ChatMessage message,
  required AppPalette palette,
  required bool isMe,
  required bool canEdit,
  required bool isCreator,
  required void Function(String emoji) onReact,
  required void Function() onReply,
  required void Function() onEdit,
  required void Function() onDelete,
  required void Function() onPin,
  required void Function(String priority) onPriority,
}) {
  return showModalBottomSheet(
    context: context,
    backgroundColor: palette.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => _MessageActionsSheet(
      message: message,
      palette: palette,
      isMe: isMe,
      canEdit: canEdit,
      isCreator: isCreator,
      onReact: onReact,
      onReply: onReply,
      onEdit: onEdit,
      onDelete: onDelete,
      onPin: onPin,
      onPriority: onPriority,
    ),
  );
}

class _MessageActionsSheet extends StatelessWidget {
  final ChatMessage message;
  final AppPalette palette;
  final bool isMe;
  final bool canEdit;
  final bool isCreator;
  final void Function(String emoji) onReact;
  final void Function() onReply;
  final void Function() onEdit;
  final void Function() onDelete;
  final void Function() onPin;
  final void Function(String priority) onPriority;

  const _MessageActionsSheet({
    required this.message,
    required this.palette,
    required this.isMe,
    required this.canEdit,
    required this.isCreator,
    required this.onReact,
    required this.onReply,
    required this.onEdit,
    required this.onDelete,
    required this.onPin,
    required this.onPriority,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: palette.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),

            // Quick emojis
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _quickEmojis.map((emoji) {
                return GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    onReact(emoji);
                  },
                  child: Container(
                    width: 42,
                    height: 42,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: palette.rowSurface,
                      shape: BoxShape.circle,
                    ),
                    child: Text(emoji, style: const TextStyle(fontSize: 22)),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 8),
            Divider(color: palette.border),

            _action(context, Icons.reply_outlined, 'Responder', onReply),

            if (isMe && canEdit)
              _action(context, Icons.edit_outlined, 'Editar', onEdit),

            if (isCreator)
              _action(
                context,
                message.pinned ? Icons.push_pin : Icons.push_pin_outlined,
                message.pinned ? 'Desfijar' : 'Fijar',
                onPin,
              ),

            // Priority section
            Divider(color: palette.border, height: 8),
            _priorityAction(context, 'important', '⚠️ Importante'),
            _priorityAction(context, 'urgent', '🔴 Urgente'),
            if (message.priority != 'normal')
              _priorityAction(context, 'normal', '✕ Quitar prioridad'),

            if (isMe) ...[
              Divider(color: palette.border, height: 8),
              _action(
                context,
                Icons.delete_outline,
                'Eliminar',
                onDelete,
                color: const Color(0xFFEF4444),
              ),
            ],
            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }

  Widget _action(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onTap, {
    Color? color,
  }) {
    final c = color ?? palette.textPrimary;
    return ListTile(
      dense: true,
      leading: Icon(icon, color: c, size: 20),
      title: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 14,
          color: c,
          fontWeight: FontWeight.w500,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
    );
  }

  Widget _priorityAction(BuildContext context, String priority, String label) {
    final isActive = message.priority == priority;
    final color = priority == 'urgent'
        ? const Color(0xFFEF4444)
        : priority == 'important'
        ? const Color(0xFFF0A646)
        : palette.textMuted;
    return ListTile(
      dense: true,
      leading: SizedBox(
        width: 20,
        child: isActive
            ? Icon(Icons.check, color: color, size: 18)
            : const SizedBox.shrink(),
      ),
      title: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 14,
          color: isActive ? color : palette.textSecondary,
          fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
      onTap: () {
        Navigator.pop(context);
        onPriority(priority);
      },
    );
  }
}
