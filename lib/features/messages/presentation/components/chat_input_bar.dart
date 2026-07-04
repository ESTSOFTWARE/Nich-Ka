import 'dart:io';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart' as ep;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../shared/theme/app_palette.dart';

part 'chat_input_bar_state.dart';

class ChatInputBar extends StatefulWidget {
  final AppPalette palette;
  final String? editingContent;
  final void Function(String text) onSend;
  final void Function(String text) onChanged;
  final void Function(File file) onImagePicked;
  final void Function(File file)? onFilePicked;

  const ChatInputBar({
    super.key,
    required this.palette,
    required this.onSend,
    required this.onChanged,
    required this.onImagePicked,
    this.onFilePicked,
    this.editingContent,
  });

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}
