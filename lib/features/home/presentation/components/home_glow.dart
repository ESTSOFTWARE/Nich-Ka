import 'package:flutter/material.dart';
import '../../../../shared/theme/app_palette.dart';

class HomeGlow extends StatelessWidget {
  final AppPalette palette;

  const HomeGlow({super.key, required this.palette});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
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
                  palette.glowColor,
                  palette.glowColor.withValues(alpha: 0),
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
