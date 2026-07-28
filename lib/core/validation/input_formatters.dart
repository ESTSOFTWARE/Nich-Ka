import 'package:flutter/services.dart';

/// Formateadores de entrada para bloquear caracteres potencialmente maliciosos
/// (inyección HTML/XSS/script) directamente al teclear. La API igual valida en
/// el servidor; esto es una capa extra en el cliente.
///
/// No se usa en contraseñas: ahí los símbolos son deseables (más fuerza) y el
/// valor se hashea, nunca se renderiza como HTML.
class AppInputFormatters {
  AppInputFormatters._();

  /// Caracteres peligrosos para HTML/scripts/plantillas: `< > " ' \` `` ` ``
  /// `{ } $ ;`. Cubren XSS (`<script>`), atributos con comillas y plantillas.
  static final FilteringTextInputFormatter noDangerousChars =
      FilteringTextInputFormatter.deny(RegExp('[<>"\'`{}\$;\\\\]'));

  /// Igual que [noDangerousChars] pero también bloquea espacios: para códigos,
  /// nombres de usuario, etc.
  static final FilteringTextInputFormatter noDangerousCharsNoSpace =
      FilteringTextInputFormatter.deny(RegExp('[<>"\'`{}\$;\\\\\\s]'));

  /// Lista lista para pasar a `inputFormatters` de un campo de texto normal.
  static List<TextInputFormatter> get text => [noDangerousChars];
}
