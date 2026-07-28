part of 'chat_input_bar.dart';

class _ChatInputBarState extends State<ChatInputBar> {
  late final TextEditingController _ctrl;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _ctrl = widget.controller ?? TextEditingController();
    _ctrl.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    final has = _ctrl.text.trim().isNotEmpty;
    if (has != _hasText) setState(() => _hasText = has);
  }

  void _submit() {
    if (widget.isLoading || !_hasText) return;
    final text = _ctrl.text.trim();
    _ctrl.clear();
    widget.onSend(text);
  }

  @override
  void dispose() {
    _ctrl.removeListener(_onTextChanged);
    if (widget.controller == null) _ctrl.dispose();
    super.dispose();
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
              controller: _ctrl,
              enabled: !widget.isLoading,
              onSubmitted: (_) => _submit(),
              textInputAction: TextInputAction.send,
              maxLines: null,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: widget.palette.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: 'Pregunta a Nich-Ka...',
                hintStyle: GoogleFonts.poppins(
                  fontSize: 14,
                  color: widget.palette.textMuted,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 6),
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: _submit,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 34,
              height: 34,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: (_hasText && !widget.isLoading)
                    ? AppPalette.accent
                    : widget.palette.border,
                shape: BoxShape.circle,
              ),
              child: widget.isLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(
                      Icons.arrow_upward,
                      color: Colors.white,
                      size: 16,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
