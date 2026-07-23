import 'package:flutter/material.dart';

/// Punto de quiebre para tablets. Se usa el lado más corto para que la
/// detección no cambie al rotar el dispositivo.
const double kTabletBreakpoint = 600;

/// Valores ÚNICOS del modo tablet. Toda la app los usa para verse uniforme:
/// no se definen tamaños sueltos por vista.
const double kTabletTextScale = 1.4; // texto (labels, campos, botones…)
const double kTabletHeaderScale = 1.35; // barra superior, marca y logo
const double kTabletMaxWidth = 720; // ancho del contenido centrado
const double kTabletPadding = 32; // padding lateral de la pantalla

/// true en tablets (≥600dp de lado corto); false en teléfonos.
/// El layout de teléfono NUNCA cambia: las vistas solo agregan una variante
/// cuando esto es true.
bool isTablet(BuildContext context) =>
    MediaQuery.sizeOf(context).shortestSide >= kTabletBreakpoint;

/// true cuando el dispositivo está en horizontal.
bool isLandscape(BuildContext context) =>
    MediaQuery.orientationOf(context) == Orientation.landscape;

/// Altura efectiva del MainAppBar (mayor en tablet). Las vistas la usan para
/// el padding superior de su contenido, así no queda tapado por la barra.
double appBarHeight(BuildContext context) =>
    kToolbarHeight * (isTablet(context) ? kTabletHeaderScale : 1.0);
