part of 'typing_indicator.dart';

class _TypingIndicatorState extends State<TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  String _first(String name) {
    final t = name.trim();
    return t.isEmpty ? t : t.split(' ').first;
  }

  String get _label {
    final names = widget.users.map((u) => _first(u.userName)).toList();
    final verb = names.length == 1 ? 'está escribiendo' : 'están escribiendo';
    if (names.length == 1) return '${names[0]} $verb';
    if (names.length == 2) return '${names[0]} y ${names[1]} $verb';
    return 'Varios $verb';
  }

  Widget _avatar(TypingUser u) {
    final initial = Text(
      u.userName.isNotEmpty ? u.userName[0].toUpperCase() : '?',
      style: GoogleFonts.poppins(
        fontSize: 9,
        fontWeight: FontWeight.w700,
        color: AppPalette.accent,
      ),
    );
    final avatar = u.avatar;
    return Container(
      width: 20,
      height: 20,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppPalette.accent.withValues(alpha: 0.15),
        border: Border.all(color: widget.palette.background, width: 1.5),
      ),
      child: (avatar != null && avatar.isNotEmpty)
          ? Image.network(
              avatar,
              width: 20,
              height: 20,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stack) => Center(child: initial),
            )
          : Center(child: initial),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Hasta 3 avatares superpuestos.
    final shown = widget.users.take(3).toList();
    const overlap = 12.0;
    final stackWidth = shown.isEmpty
        ? 0.0
        : 20.0 + (shown.length - 1) * overlap;

    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 4),
      child: Row(
        children: [
          if (shown.isNotEmpty)
            SizedBox(
              width: stackWidth,
              height: 20,
              child: Stack(
                children: [
                  for (var i = 0; i < shown.length; i++)
                    Positioned(left: i * overlap, child: _avatar(shown[i])),
                ],
              ),
            ),
          const SizedBox(width: 8),
          _Dots(controller: _ctrl, palette: widget.palette),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              _label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontStyle: FontStyle.italic,
                color: widget.palette.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
