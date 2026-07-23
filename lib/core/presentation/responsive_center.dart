import 'package:flutter/widgets.dart';

import 'responsive.dart';

/// En tablet centra el contenido, lo acota a [kTabletMaxWidth] y escala todo
/// el texto con [kTabletTextScale], para que cada pantalla se vea igual de
/// grande sin definir tamaños sueltos por vista.
///
/// En teléfono no hace nada (devuelve el hijo tal cual), así el diseño de
/// celular no cambia.
class ResponsiveCenter extends StatelessWidget {
  final Widget child;

  /// Solo para vistas que necesiten un ancho distinto (p.ej. un chat ancho).
  final double maxWidth;

  const ResponsiveCenter({
    super.key,
    required this.child,
    this.maxWidth = kTabletMaxWidth,
  });

  @override
  Widget build(BuildContext context) {
    if (!isTablet(context)) return child;
    return MediaQuery(
      data: MediaQuery.of(
        context,
      ).copyWith(textScaler: const TextScaler.linear(kTabletTextScale)),
      // topCenter (no Center): centra SOLO en horizontal y mantiene el
      // contenido pegado arriba. Con Center, un contenido más corto que la
      // pantalla del tablet quedaba flotando en el medio ("se ve hacia abajo").
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: child,
        ),
      ),
    );
  }
}
