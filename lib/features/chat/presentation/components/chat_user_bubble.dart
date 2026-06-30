import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/entities/chat_message.dart';
import '../../../../shared/theme/app_palette.dart';

class ChatUserBubble extends StatelessWidget {
  final ChatMessage message;
  final AppPalette palette;

  const ChatUserBubble({
    super.key,
    required this.message,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.72,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: AppPalette.accent,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text(
            message.text,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.black,
              height: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}
