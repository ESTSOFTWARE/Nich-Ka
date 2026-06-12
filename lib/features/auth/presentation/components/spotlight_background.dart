import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class SpotlightBackground extends StatelessWidget {
  final Widget child;

  const SpotlightBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final ellipseLong = size.width * 1.7;
    final ellipseShort = ellipseLong * 0.22;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Positioned.fill(
            child: IgnorePointer(
              child: TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 2750),
                curve: const Interval(0.27, 1.0, curve: Curves.ease),
                builder: (context, t, child) {
                  return Opacity(
                    opacity: t,
                    child: Transform.scale(
                      scale: 0.7 + 0.3 * t,
                      alignment: Alignment.topLeft,
                      child: child,
                    ),
                  );
                },
                child: Stack(
                  children: [
                    Positioned(
                      top: -size.width * 0.15,
                      left: -size.width * 0.65,
                      child: Transform.rotate(
                        angle: math.pi / 5,
                        child: ImageFiltered(
                          imageFilter: ImageFilter.blur(
                            sigmaX: 60.0,
                            sigmaY: 60.0,
                          ),
                          child: Container(
                            width: ellipseLong,
                            height: ellipseShort,
                            decoration: BoxDecoration(
                              color: AppColors.spotlight.withValues(
                                alpha: 0.28,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.elliptical(
                                  ellipseLong / 2,
                                  ellipseShort / 2,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          SafeArea(child: child),
        ],
      ),
    );
  }
}
