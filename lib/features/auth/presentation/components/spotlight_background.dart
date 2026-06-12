import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Responsabilidad única: pintar el fondo oscuro con el efecto "spotlight".
///
/// Réplica del componente de Figma/web: una elipse blanca alargada y delgada,
/// muy difuminada y rotada en diagonal, que nace arriba a la izquierda.
///
/// Una sola clase: la animación de entrada (fade-in + escala con retardo) la
/// encapsula [TweenAnimationBuilder], sin necesidad de un State.
class SpotlightBackground extends StatelessWidget {
  final Widget child;

  const SpotlightBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // Elipse alargada (~5:1), como el componente del diseño.
    final ellipseLong = size.width * 1.7;
    final ellipseShort = ellipseLong * 0.22;

    return Scaffold(
      backgroundColor: AppColors.background, // Fondo base ultra oscuro
      body: Stack(
        children: [
          // EFECTO SPOTLIGHT: duration 2s + delay 0.75s -> Interval sobre 2.75s.
          Positioned.fill(
            child: IgnorePointer(
              child: TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 2750),
                curve: const Interval(0.27, 1.0, curve: Curves.ease),
                builder: (context, t, child) {
                  return Opacity(
                    opacity: t, // 0 -> 1
                    child: Transform.scale(
                      scale: 0.7 + 0.3 * t, // 0.7 -> 1
                      alignment: Alignment.topLeft,
                      child: child,
                    ),
                  );
                },
                child: Stack(
                  children: [
                    Positioned(
                      // Centro de la elipse cerca de la esquina superior izq.
                      top: -size.width * 0.15,
                      left: -size.width * 0.65,
                      child: Transform.rotate(
                        // Diagonal: baja de arriba-izquierda a abajo-derecha.
                        angle: math.pi / 5, // ~ +36°
                        child: ImageFiltered(
                          imageFilter:
                              ImageFilter.blur(sigmaX: 60.0, sigmaY: 60.0),
                          child: Container(
                            width: ellipseLong,
                            height: ellipseShort,
                            decoration: BoxDecoration(
                              // Relleno uniforme tenue (fillOpacity de la web).
                              color: AppColors.spotlight.withValues(alpha: 0.28),
                              borderRadius: BorderRadius.all(
                                Radius.elliptical(
                                    ellipseLong / 2, ellipseShort / 2),
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

          // CONTENIDO (por encima de la luz)
          SafeArea(child: child),
        ],
      ),
    );
  }
}
