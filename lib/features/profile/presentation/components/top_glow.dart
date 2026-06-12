import 'package:flutter/material.dart';

class TopGlow extends StatelessWidget {
  final bool isDark;

  const TopGlow({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final alpha = isDark ? 0.16 : 0.5;

    return Positioned(
      top: -width * 0.45,
      left: 0,
      right: 0,
      child: IgnorePointer(
        child: Center(
          child: Container(
            width: width * 1.1,
            height: width * 1.1,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  Colors.white.withValues(alpha: alpha),
                  Colors.white.withValues(alpha: 0.0),
                ],
                stops: const [0.0, 0.7],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
