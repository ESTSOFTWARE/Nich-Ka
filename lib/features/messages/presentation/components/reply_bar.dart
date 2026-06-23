import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/entities/chat_message.dart';
import '../../../../shared/theme/app_palette.dart';

class ReplyBar extends StatelessWidget {
  final ChatMessage message;
  final AppPalette palette;
  final VoidCallback onCancel;

  const ReplyBar({
    super.key,
    required this.message,
    required this.palette,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
      decoration: BoxDecoration(
        color: palette.rowSurface,
        border: Border(top: BorderSide(color: palette.border)),
      ),
      child: Row(
        children: [
          Container(
            width: 3,
            height: 36,
            decoration: BoxDecoration(
              color: AppPalette.accent,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Responder a ${message.senderName}',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppPalette.accent,
                  ),
                ),
                Text(
                  message.content ??
                      (message.attachments.isNotEmpty ? '📎 Adjunto' : ''),
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: palette.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onCancel,
            icon: Icon(Icons.close, size: 18, color: palette.textMuted),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}
