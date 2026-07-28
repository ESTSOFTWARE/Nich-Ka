part of 'group_message_input.dart';

class _GroupMessageInputState extends State<GroupMessageInput> {
  final TextEditingController _controller = TextEditingController();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final has = _controller.text.trim().isNotEmpty;
      if (has != _hasText) setState(() => _hasText = has);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    widget.onSend(text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 6, 6, 6),
      decoration: BoxDecoration(
        color: widget.palette.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: widget.palette.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              inputFormatters: AppInputFormatters.text,
              controller: _controller,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: widget.palette.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: 'Escribe un mensaje...',
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
              onSubmitted: (_) => _send(),
            ),
          ),
          const SizedBox(width: 8),
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
              child: const Icon(
                Icons.arrow_upward_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
