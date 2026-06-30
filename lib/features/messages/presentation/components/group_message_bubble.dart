import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/entities/group_message.dart';
import '../../../../shared/theme/app_palette.dart';

class GroupMessageBubble extends StatelessWidget {
  final GroupMessage message;
  final AppPalette palette;
  final bool showSenderName;

  const GroupMessageBubble({
    super.key,
    required this.message,
    required this.palette,
    this.showSenderName = true,
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
    final index =
        name.codeUnits.fold(0, (a, b) => a + b) % _senderColors.length;
    return _senderColors[index];
  }

  @override
  Widget build(BuildContext context) {
    if (message.isMe) return _buildMyBubble(context);
    return _buildOtherBubble(context);
  }

  Widget _buildMyBubble(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.72,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: AppPalette.accent.withValues(alpha: 0.15),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(14),
              topRight: Radius.circular(14),
              bottomLeft: Radius.circular(14),
              bottomRight: Radius.circular(4),
            ),
            border: Border.all(color: AppPalette.accent.withValues(alpha: 0.3)),
          ),
          child: Text(
            message.content,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: palette.textPrimary,
              height: 1.5,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOtherBubble(BuildContext context) {
    final senderColor = _colorForSender(message.senderName);
    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.78,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showSenderName)
              Padding(
                padding: const EdgeInsets.only(left: 2, bottom: 4),
                child: Text(
                  message.senderName,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: senderColor,
                  ),
                ),
              ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: palette.surface,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(14),
                  bottomLeft: Radius.circular(14),
                  bottomRight: Radius.circular(14),
                ),
                border: Border.all(color: palette.border),
              ),
              child: Text(
                message.content,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: palette.textPrimary,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
