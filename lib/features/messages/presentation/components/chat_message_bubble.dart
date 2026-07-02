import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/entities/chat_message.dart';
import '../../../../shared/theme/app_palette.dart';
import 'image_viewer_page.dart';

class ChatMessageBubble extends StatelessWidget {
  final ChatMessage message;
  final AppPalette palette;
  final bool isMe;
  final bool isFirst; // first in sender block
  final bool isLast; // last in sender block
  final bool groupChat;
  final int myUserId;
  final void Function(ChatMessage)? onLongPress;
  final void Function(String emoji)? onQuickReact;

  const ChatMessageBubble({
    super.key,
    required this.message,
    required this.palette,
    required this.isMe,
    required this.myUserId,
    this.isFirst = true,
    this.isLast = true,
    this.groupChat = true,
    this.onLongPress,
    this.onQuickReact,
  });

  static const List<Color> _senderColors = [
    Color(0xFF75D079),
    Color(0xFF60A5FA),
    Color(0xFFFBBF24),
    Color(0xFFF472B6),
    Color(0xFFA78BFA),
    Color(0xFF34D399),
  ];

  Color _colorForSender(String name) {
    final idx = name.codeUnits.fold(0, (a, b) => a + b) % _senderColors.length;
    return _senderColors[idx];
  }

  BorderRadius _bubbleRadius() {
    const r = Radius.circular(18);
    const s = Radius.circular(4); // small corner inside a block

    if (isMe) {
      // My messages: bottom-right always sharp, top-right sharp unless first
      return BorderRadius.only(
        topLeft: r,
        topRight: isFirst ? r : s,
        bottomLeft: r,
        bottomRight: isLast ? s : s,
      );
    } else {
      // Others: bottom-left always sharp, top-left sharp unless first
      return BorderRadius.only(
        topLeft: isFirst ? r : s,
        topRight: r,
        bottomLeft: isLast ? s : s,
        bottomRight: r,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (message.deleted) return _buildDeleted();

    return GestureDetector(
      onLongPress: () => onLongPress?.call(message),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          // Avatar — only for others, only on last of block
          if (!isMe) ...[
            SizedBox(
              width: 32,
              child: isLast ? _buildAvatar() : const SizedBox(width: 32),
            ),
            const SizedBox(width: 6),
          ],

          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.72,
            ),
            child: Column(
              crossAxisAlignment: isMe
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                // Sender name — only for others, first of block, in group chat
                if (!isMe && isFirst && groupChat)
                  Padding(
                    padding: const EdgeInsets.only(left: 2, bottom: 3),
                    child: Text(
                      message.senderName,
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: _colorForSender(message.senderName),
                      ),
                    ),
                  ),

                // Priority badge — only on first of block
                if (isFirst && message.isImportant) _buildPriorityBadge(),

                // Bubble
                _buildBubble(context),

                // Timestamp + edited — only on last of block
                if (isLast)
                  Padding(
                    padding: const EdgeInsets.only(top: 3, left: 2, right: 2),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _formatTime(message.createdAt),
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            color: palette.textMuted,
                          ),
                        ),
                        if (message.edited) ...[
                          Text(
                            ' · ',
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              color: palette.textMuted,
                            ),
                          ),
                          Text(
                            'editado',
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              color: palette.textMuted,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                // Reactions
                if (message.reactions.isNotEmpty) _buildReactions(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeleted() {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (!isMe) const SizedBox(width: 38),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: palette.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: palette.border),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.block, size: 13, color: palette.textMuted),
              const SizedBox(width: 5),
              Text(
                'Mensaje eliminado',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontStyle: FontStyle.italic,
                  color: palette.textMuted,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAvatar() {
    final color = _colorForSender(message.senderName);
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: 0.15),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Center(
        child: Text(
          message.senderName.isNotEmpty
              ? message.senderName[0].toUpperCase()
              : '?',
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ),
    );
  }

  Widget _buildPriorityBadge() {
    final isUrgent = message.isUrgent;
    final color = isUrgent ? const Color(0xFFEF4444) : const Color(0xFFF0A646);
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isUrgent ? Icons.warning_amber_rounded : Icons.info_outline,
              size: 11,
              color: color,
            ),
            const SizedBox(width: 4),
            Text(
              isUrgent ? 'Urgente' : 'Importante',
              style: GoogleFonts.poppins(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBubble(BuildContext context) {
    final bgColor = isMe ? AppPalette.accent : palette.surface;
    final textColor = isMe ? Colors.black : palette.textPrimary;
    final borderColor = isMe ? Colors.transparent : palette.border;

    // Priority border
    final hasPriorityBorder = message.isImportant;
    final priorityColor = message.isUrgent
        ? const Color(0xFFEF4444)
        : const Color(0xFFF0A646);

    final hasContent = message.content != null && message.content!.isNotEmpty;
    final hasAttachments = message.attachments.isNotEmpty;

    if (!hasContent && !hasAttachments) return const SizedBox.shrink();

    // Image-only: render image directly without bubble frame
    if (!hasContent &&
        hasAttachments &&
        message.attachments.every((a) => a.isImage)) {
      return _buildImageOnly(context);
    }

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: _bubbleRadius(),
        border: Border.all(
          color: hasPriorityBorder
              ? priorityColor.withValues(alpha: 0.4)
              : borderColor,
          width: hasPriorityBorder ? 1 : 0.5,
        ),
      ),
      child: ClipRRect(
        borderRadius: _bubbleRadius(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Reply quote
              if (message.replyTo != null) _buildReplyQuote(textColor),

              // Text content
              if (hasContent)
                Text(
                  message.content!,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: textColor,
                    height: 1.4,
                  ),
                ),

              // Attachments
              if (hasAttachments) _buildAttachments(context, textColor),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageOnly(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: message.attachments.map((a) {
        return Padding(
          padding: const EdgeInsets.only(top: 2),
          child: GestureDetector(
            onTap: () => _openImageViewer(context, a.url),
            child: Image.network(
              a.url,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(
                height: 80,
                color: palette.rowSurface,
                child: Icon(Icons.broken_image, color: palette.textMuted),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  void _openImageViewer(BuildContext context, String url) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ImageViewerPage(imageUrl: url),
        fullscreenDialog: true,
      ),
    );
  }

  Widget _buildReplyQuote(Color textColor) {
    final reply = message.replyTo!;
    final quoteAccent = isMe
        ? Colors.black.withValues(alpha: 0.45)
        : AppPalette.accent;
    final quoteBg = isMe
        ? Colors.black.withValues(alpha: 0.1)
        : palette.rowSurface.withValues(alpha: 0.6);

    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: quoteBg,
        borderRadius: BorderRadius.circular(6),
        border: Border(left: BorderSide(color: quoteAccent, width: 3)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              reply.senderName,
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isMe
                    ? Colors.black.withValues(alpha: 0.7)
                    : AppPalette.accent,
              ),
            ),
            Text(
              reply.content ?? (reply.attachment != null ? '📎 Archivo' : ''),
              style: GoogleFonts.poppins(
                fontSize: 11,
                color: isMe
                    ? Colors.black.withValues(alpha: 0.6)
                    : palette.textSecondary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachments(BuildContext context, Color textColor) {
    return Column(
      children: message.attachments.map((a) {
        if (a.isImage) {
          return Padding(
            padding: const EdgeInsets.only(top: 6),
            child: GestureDetector(
              onTap: () => _openImageViewer(context, a.url),
              child: Image.network(
                a.url,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(
                  height: 80,
                  color: palette.rowSurface,
                  child: Icon(Icons.broken_image, color: palette.textMuted),
                ),
              ),
            ),
          );
        }
        final bgColor = isMe
            ? Colors.black.withValues(alpha: 0.15)
            : palette.rowSurface;
        return Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.insert_drive_file_outlined,
                  size: 16,
                  color: isMe ? Colors.black54 : AppPalette.accent,
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        a.name,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: textColor,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (a.size > 0)
                        Text(
                          _formatSize(a.size),
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            color: isMe
                                ? Colors.black.withValues(alpha: 0.5)
                                : palette.textMuted,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildReactions() {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Wrap(
        spacing: 4,
        runSpacing: 4,
        alignment: isMe ? WrapAlignment.end : WrapAlignment.start,
        children: message.reactions.entries
            .where((e) => e.value.isNotEmpty)
            .map((e) {
              final emoji = e.key;
              final users = e.value;
              final iMine = users.contains(myUserId);
              return GestureDetector(
                onTap: () => onQuickReact?.call(emoji),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: iMine
                        ? AppPalette.accent.withValues(alpha: 0.15)
                        : palette.rowSurface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: iMine
                          ? AppPalette.accent.withValues(alpha: 0.4)
                          : palette.border,
                    ),
                  ),
                  child: Text(
                    '$emoji ${users.length}',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: palette.textPrimary,
                    ),
                  ),
                ),
              );
            })
            .toList(),
      ),
    );
  }

  static String _formatTime(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  static String _formatSize(int bytes) {
    if (bytes < 1024) return '${bytes}B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)}KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)}MB';
  }
}
