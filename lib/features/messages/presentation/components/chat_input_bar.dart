import 'dart:io';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart' as ep;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../shared/theme/app_palette.dart';
import '../../domain/entities/chat_member.dart';
import 'sticker_picker.dart';
import '../../../../core/validation/input_formatters.dart';

part 'chat_input_bar_state.dart';

class ChatInputBar extends StatefulWidget {
  final AppPalette palette;
  final String? editingContent;
  final void Function(String text, List<int> mentions) onSend;
  final void Function(String text) onChanged;
  final void Function(File file) onImagePicked;
  final void Function(File file)? onFilePicked;
  final void Function(File file)? onStickerPicked;

  /// Miembros del grupo, para autocompletar menciones (@). Vacío en 1:1.
  final List<ChatMember> members;

  /// Mi propio id, para no ofrecerme a mí mismo en las menciones.
  final int myUserId;

  const ChatInputBar({
    super.key,
    required this.palette,
    required this.onSend,
    required this.onChanged,
    required this.onImagePicked,
    this.onFilePicked,
    this.onStickerPicked,
    this.editingContent,
    this.members = const [],
    this.myUserId = 0,
  });

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}
