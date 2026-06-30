import 'dart:io';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart' as ep;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../shared/theme/app_palette.dart';

class ChatInputBar extends StatefulWidget {
  final AppPalette palette;
  final String? editingContent;
  final void Function(String text) onSend;
  final void Function(String text) onChanged;
  final void Function(File file) onImagePicked;

  const ChatInputBar({
    super.key,
    required this.palette,
    required this.onSend,
    required this.onChanged,
    required this.onImagePicked,
    this.editingContent,
  });

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  final TextEditingController _ctrl = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ImagePicker _picker = ImagePicker();
  bool _hasText = false;
  bool _emojiOpen = false;

  @override
  void didUpdateWidget(covariant ChatInputBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.editingContent != null &&
        widget.editingContent != oldWidget.editingContent) {
      _ctrl.text = widget.editingContent!;
      _ctrl.selection = TextSelection.collapsed(offset: _ctrl.text.length);
      setState(() => _hasText = true);
    }
    if (widget.editingContent == null && oldWidget.editingContent != null) {
      _ctrl.clear();
      setState(() => _hasText = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _ctrl.addListener(() {
      final has = _ctrl.text.trim().isNotEmpty;
      if (has != _hasText) setState(() => _hasText = has);
      widget.onChanged(_ctrl.text);
    });
    _focusNode.addListener(() {
      if (_focusNode.hasFocus && _emojiOpen) {
        setState(() => _emojiOpen = false);
      }
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _send() {
    final text = _ctrl.text.trim();
    if (text.isEmpty) return;
    widget.onSend(text);
    _ctrl.clear();
  }

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (picked != null) widget.onImagePicked(File(picked.path));
  }

  void _toggleEmoji() {
    if (_emojiOpen) {
      _focusNode.requestFocus();
      setState(() => _emojiOpen = false);
    } else {
      _focusNode.unfocus();
      setState(() => _emojiOpen = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(6, 6, 6, 6),
          decoration: BoxDecoration(
            color: widget.palette.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: widget.palette.border),
          ),
          child: Row(
            children: [
              // Emoji toggle
              IconButton(
                onPressed: _toggleEmoji,
                icon: Icon(
                  _emojiOpen
                      ? Icons.keyboard_rounded
                      : Icons.emoji_emotions_outlined,
                  color: _emojiOpen
                      ? AppPalette.accent
                      : widget.palette.textMuted,
                  size: 22,
                ),
                padding: const EdgeInsets.all(4),
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 2),
              // Image picker
              IconButton(
                onPressed: _pickImage,
                icon: Icon(
                  Icons.image_outlined,
                  color: widget.palette.textMuted,
                  size: 22,
                ),
                padding: const EdgeInsets.all(4),
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: TextField(
                  controller: _ctrl,
                  focusNode: _focusNode,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: widget.palette.textPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: widget.editingContent != null
                        ? 'Editando mensaje...'
                        : 'Escribe un mensaje...',
                    hintStyle: GoogleFonts.poppins(
                      fontSize: 14,
                      color: widget.palette.textMuted,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 6),
                  ),
                  maxLines: 4,
                  minLines: 1,
                  textCapitalization: TextCapitalization.sentences,
                ),
              ),
              const SizedBox(width: 4),
              GestureDetector(
                onTap: _hasText ? _send : null,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: 36,
                  height: 36,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: _hasText
                        ? AppPalette.accent
                        : AppPalette.accent.withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    widget.editingContent != null
                        ? Icons.check_rounded
                        : Icons.arrow_upward_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
        // Emoji picker panel
        Offstage(
          offstage: !_emojiOpen,
          child: ep.EmojiPicker(
            onEmojiSelected: (_, emoji) {
              final text = _ctrl.text;
              final sel = _ctrl.selection;
              final newText = text.replaceRange(
                sel.start < 0 ? text.length : sel.start,
                sel.end < 0 ? text.length : sel.end,
                emoji.emoji,
              );
              _ctrl.value = TextEditingValue(
                text: newText,
                selection: TextSelection.collapsed(
                  offset:
                      (sel.start < 0 ? text.length : sel.start) +
                      emoji.emoji.length,
                ),
              );
            },
            config: ep.Config(
              height: 256,
              emojiTextStyle: const TextStyle(fontSize: 28),
              categoryViewConfig: ep.CategoryViewConfig(
                backgroundColor: widget.palette.surface,
                iconColor: widget.palette.textMuted,
                iconColorSelected: AppPalette.accent,
                indicatorColor: AppPalette.accent,
              ),
              emojiViewConfig: ep.EmojiViewConfig(
                backgroundColor: widget.palette.surface,
                columns: 8,
                emojiSizeMax: 28,
              ),
              searchViewConfig: ep.SearchViewConfig(
                backgroundColor: widget.palette.surface,
                buttonIconColor: AppPalette.accent,
              ),
              bottomActionBarConfig: ep.BottomActionBarConfig(
                backgroundColor: widget.palette.surface,
                buttonColor: AppPalette.accent,
                buttonIconColor: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
