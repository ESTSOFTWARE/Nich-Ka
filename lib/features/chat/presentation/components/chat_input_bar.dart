import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/theme/app_palette.dart';

part 'chat_input_bar_state.dart';

class ChatInputBar extends StatefulWidget {
  final AppPalette palette;
  final bool isLoading;
  final void Function(String) onSend;
  final TextEditingController? controller;

  const ChatInputBar({
    super.key,
    required this.palette,
    required this.onSend,
    this.isLoading = false,
    this.controller,
  });

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}
