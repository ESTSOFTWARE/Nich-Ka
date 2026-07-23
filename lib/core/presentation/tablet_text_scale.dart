import 'package:flutter/widgets.dart';

import 'responsive.dart';

/// Aplica el escalado de texto de tablet ([kTabletTextScale]) a todo su
/// subárbol. Lo usan las vistas con layout propio (las que no pasan por
/// `ResponsiveCenter`) para verse igual de grandes que el resto de la app.
///
/// En teléfono no hace nada.
class TabletTextScale extends StatelessWidget {
  final Widget child;

  const TabletTextScale({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    if (!isTablet(context)) return child;
    return MediaQuery(
      data: MediaQuery.of(
        context,
      ).copyWith(textScaler: const TextScaler.linear(kTabletTextScale)),
      child: child,
    );
  }
}
