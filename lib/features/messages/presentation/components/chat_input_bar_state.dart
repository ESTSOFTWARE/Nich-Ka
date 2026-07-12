part of 'chat_input_bar.dart';

class _ChatInputBarState extends State<ChatInputBar> {
  final TextEditingController _ctrl = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ImagePicker _picker = ImagePicker();
  bool _hasText = false;
  bool _emojiOpen = false;
  bool _stickerOpen = false;
  String? _mentionQuery; // texto tras la @ actual (null = no hay mención)

  // ── Menciones (@) ─────────────────────────────────────────────────────────
  String _firstName(String name) {
    final t = name.trim();
    return t.isEmpty ? t : t.split(' ').first;
  }

  /// Índice de la @ que inicia el token bajo el cursor, o null.
  int? _mentionAtIndex() {
    final pos = _ctrl.selection.baseOffset;
    if (pos < 0) return null;
    final text = _ctrl.text;
    var i = pos - 1;
    while (i >= 0) {
      final ch = text[i];
      if (ch == '@') {
        if (i == 0 || text[i - 1] == ' ' || text[i - 1] == '\n') return i;
        return null;
      }
      if (ch == ' ' || ch == '\n') return null;
      i--;
    }
    return null;
  }

  void _updateMentionQuery() {
    if (widget.members.isEmpty) return;
    final at = _mentionAtIndex();
    final q = at == null
        ? null
        : _ctrl.text.substring(at + 1, _ctrl.selection.baseOffset);
    if (q != _mentionQuery) setState(() => _mentionQuery = q);
  }

  List<ChatMember> get _mentionSuggestions {
    final q = (_mentionQuery ?? '').toLowerCase();
    return widget.members
        .where((m) => m.id != widget.myUserId)
        .where((m) => q.isEmpty || m.name.toLowerCase().contains(q))
        .take(6)
        .toList();
  }

  bool get _showTodos =>
      (_mentionQuery ?? '').isEmpty ||
      'todos'.contains((_mentionQuery ?? '').toLowerCase());

  void _insertMention({ChatMember? member}) {
    final at = _mentionAtIndex();
    if (at == null) return;
    final pos = _ctrl.selection.baseOffset;
    final handle = member == null ? '@todos ' : '@${_firstName(member.name)} ';
    final newText = _ctrl.text.replaceRange(at, pos, handle);
    _ctrl.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: at + handle.length),
    );
    setState(() => _mentionQuery = null);
    _focusNode.requestFocus();
  }

  /// Resuelve los ids mencionados a partir del texto final (robusto ante
  /// ediciones): @todos = todos menos yo; @NombrePila = ese miembro.
  List<int> _resolveMentions(String text) {
    final lower = text.toLowerCase();
    final ids = <int>{};
    if (lower.contains('@todos')) {
      ids.addAll(
        widget.members.where((m) => m.id != widget.myUserId).map((m) => m.id),
      );
    }
    for (final m in widget.members) {
      if (m.id == widget.myUserId) continue;
      if (lower.contains('@${_firstName(m.name).toLowerCase()}')) {
        ids.add(m.id);
      }
    }
    return ids.toList();
  }

  @override
  void didUpdateWidget(covariant ChatInputBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.editingContent != null &&
        widget.editingContent != oldWidget.editingContent) {
      _ctrl.text = widget.editingContent!;
      _ctrl.selection = TextSelection.collapsed(offset: _ctrl.text.length);
      _focusNode.requestFocus();
      setState(() => _hasText = true);
    }
    if (widget.editingContent == null && oldWidget.editingContent != null) {
      _ctrl.clear();
      _focusNode.unfocus();
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
      _updateMentionQuery();
    });
    _focusNode.addListener(() {
      if (_focusNode.hasFocus && (_emojiOpen || _stickerOpen)) {
        setState(() {
          _emojiOpen = false;
          _stickerOpen = false;
        });
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
    widget.onSend(text, _resolveMentions(text));
    _ctrl.clear();
    setState(() => _mentionQuery = null);
  }

  /// Muestra un selector para elegir entre cámara y galería, y sube la foto.
  Future<void> _pickImage() async {
    _focusNode.unfocus();
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: widget.palette.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            ListTile(
              leading: Icon(
                Icons.photo_camera_outlined,
                color: widget.palette.textSecondary,
              ),
              title: Text(
                'Tomar foto',
                style: GoogleFonts.poppins(color: widget.palette.textPrimary),
              ),
              onTap: () => Navigator.pop(ctx, ImageSource.camera),
            ),
            ListTile(
              leading: Icon(
                Icons.image_outlined,
                color: widget.palette.textSecondary,
              ),
              title: Text(
                'Elegir de la galería',
                style: GoogleFonts.poppins(color: widget.palette.textPrimary),
              ),
              onTap: () => Navigator.pop(ctx, ImageSource.gallery),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
    if (source == null) return;
    final picked = await _picker.pickImage(source: source, imageQuality: 85);
    if (picked != null) widget.onImagePicked(File(picked.path));
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'pdf',
        'doc',
        'docx',
        'xls',
        'xlsx',
        'ppt',
        'pptx',
        'txt',
        'csv',
        'zip',
        'rar',
        '7z',
        'mp4',
        'mov',
        'avi',
        'mkv',
      ],
    );
    if (result != null && result.files.single.path != null) {
      widget.onFilePicked?.call(File(result.files.single.path!));
    }
  }

  void _toggleEmoji() {
    if (_emojiOpen) {
      _focusNode.requestFocus();
      setState(() {
        _emojiOpen = false;
        _stickerOpen = false;
      });
    } else {
      _focusNode.unfocus();
      setState(() {
        _emojiOpen = true;
        _stickerOpen = false;
      });
    }
  }

  void _toggleSticker() {
    if (_stickerOpen) {
      _focusNode.requestFocus();
      setState(() {
        _stickerOpen = false;
        _emojiOpen = false;
      });
    } else {
      _focusNode.unfocus();
      setState(() {
        _stickerOpen = true;
        _emojiOpen = false;
      });
    }
  }

  Widget _mentionsOverlay() {
    final suggestions = _mentionSuggestions;
    if (suggestions.isEmpty && !_showTodos) return const SizedBox.shrink();
    return Container(
      constraints: const BoxConstraints(maxHeight: 220),
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: widget.palette.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: widget.palette.border),
      ),
      child: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        children: [
          if (_showTodos)
            ListTile(
              dense: true,
              onTap: () => _insertMention(),
              leading: CircleAvatar(
                radius: 16,
                backgroundColor: AppPalette.accent.withValues(alpha: 0.2),
                child: const Icon(
                  Icons.groups_outlined,
                  size: 18,
                  color: AppPalette.accent,
                ),
              ),
              title: Text(
                'Todos',
                style: GoogleFonts.poppins(
                  color: widget.palette.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(
                'Notificar a todo el grupo',
                style: GoogleFonts.poppins(
                  color: widget.palette.textMuted,
                  fontSize: 11,
                ),
              ),
            ),
          ...suggestions.map(
            (m) => ListTile(
              dense: true,
              onTap: () => _insertMention(member: m),
              leading: _mentionAvatar(m),
              title: Text(
                m.name,
                style: GoogleFonts.poppins(
                  color: widget.palette.textPrimary,
                  fontSize: 14,
                ),
              ),
              subtitle: Text(
                '@${_firstName(m.name)}',
                style: GoogleFonts.poppins(
                  color: AppPalette.accent,
                  fontSize: 11,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _mentionAvatar(ChatMember m) {
    final initial = Center(
      child: Text(
        m.name.isNotEmpty ? m.name[0].toUpperCase() : '?',
        style: const TextStyle(
          color: AppPalette.accent,
          fontSize: 13,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
    return Container(
      width: 32,
      height: 32,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppPalette.accent.withValues(alpha: 0.15),
      ),
      child: (m.avatar != null && m.avatar!.isNotEmpty)
          ? Image.network(
              m.avatar!,
              width: 32,
              height: 32,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stack) => initial,
            )
          : initial,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_mentionQuery != null) _mentionsOverlay(),
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
              // Sticker toggle
              if (widget.onStickerPicked != null)
                IconButton(
                  onPressed: _toggleSticker,
                  icon: Icon(
                    Icons.sticky_note_2_outlined,
                    color: _stickerOpen
                        ? AppPalette.accent
                        : widget.palette.textMuted,
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
              // Imagen (cámara o galería)
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
              // Archivo
              if (widget.onFilePicked != null) ...[
                const SizedBox(width: 2),
                IconButton(
                  onPressed: _pickFile,
                  icon: Icon(
                    Icons.attach_file_outlined,
                    color: widget.palette.textMuted,
                    size: 22,
                  ),
                  padding: const EdgeInsets.all(4),
                  constraints: const BoxConstraints(),
                ),
              ],
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
        // Sticker picker panel
        if (widget.onStickerPicked != null)
          Offstage(
            offstage: !_stickerOpen,
            child: StickerPicker(
              palette: widget.palette,
              onStickerSelected: (file) {
                widget.onStickerPicked?.call(file);
                setState(() {
                  _stickerOpen = false;
                });
                _focusNode.requestFocus();
              },
            ),
          ),
      ],
    );
  }
}
