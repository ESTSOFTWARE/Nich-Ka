import 'dart:ui';
import 'dart:math' as math; // <-- IMPORTANTE PARA LA ROTACIÓN
import 'package:flutter/material.dart';

class SpotlightBackground extends StatelessWidget {
  final Widget child;

  const SpotlightBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    // Obtenemos el ancho de la pantalla para que la luz sea responsiva
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      // Fondo base ultra oscuro
      backgroundColor: const Color(0xFF0A0A0B),
      body: Stack(
        children: [
          // 1. EL EFECTO SPOTLIGHT (Replicando la lógica del SVG Web)
          Positioned(
            // Lo desplazamos hacia arriba y a la izquierda para que nazca de la esquina
            top: -screenWidth * 0.3,
            left: -screenWidth * 0.2,
            child: Transform.rotate(
              // Inclinamos la elipse para crear el "rayo" (Equivalente al matrix transform de la web)
              angle: -math.pi / 5, // Aprox -36 grados
              child: ImageFiltered(
                // Difuminado extremo (Equivalente al <feGaussianBlur stdDeviation="151">)
                imageFilter: ImageFilter.blur(sigmaX: 90.0, sigmaY: 90.0),
                child: Container(
                  // Proporciones estiradas: mucho más ancho que alto (rx vs ry)
                  width: screenWidth * 1.5,
                  height: screenWidth * 0.4,
                  decoration: BoxDecoration(
                    // Color blanco con la opacidad dictada en el código web (0.21 ajustado a 0.18 para móvil)
                    color: Colors.white.withOpacity(0.18),
                    // Forzamos la forma elíptica
                    borderRadius: BorderRadius.all(
                      Radius.elliptical(screenWidth * 1.5, screenWidth * 0.4),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // 2. TU CONTENIDO (Por encima de la luz)
          SafeArea(
            child: child,
          ),
        ],
      ),
    );
  }
}