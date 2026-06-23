import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/group_chat_provider.dart';
import '../../../../shared/theme/app_palette.dart';

class TypingIndicator extends StatefulWidget {
  final List<TypingUser> users;
  final AppPalette palette;

  const TypingIndicator({
    super.key,
    required this.users,
    required this.palette,
  });

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

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

  String get _label {
    final names = widget.users.map((u) => u.userName).toList();
    if (names.length == 1) return '${names[0]} está escribiendo';
    if (names.length == 2) return '${names[0]} y ${names[1]} están escribiendo';
    return 'Varios están escribiendo';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 4),
      child: Row(
        children: [
          _Dots(controller: _ctrl, palette: widget.palette),
          const SizedBox(width: 8),
          Text(
            _label,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontStyle: FontStyle.italic,
              color: widget.palette.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _Dots extends StatelessWidget {
  final AnimationController controller;
  final AppPalette palette;

  const _Dots({required this.controller, required this.palette});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, _) {
        return Row(
          children: List.generate(3, (i) {
            final delay = i / 3;
            final t = ((controller.value - delay) % 1.0).clamp(0.0, 1.0);
            final opacity = (t < 0.5 ? t * 2 : (1 - t) * 2).clamp(0.3, 1.0);
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1.5),
              child: Opacity(
                opacity: opacity,
                child: Container(
                  width: 5,
                  height: 5,
                  decoration: BoxDecoration(
                    color: AppPalette.accent,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
