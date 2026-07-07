import 'package:flutter/foundation.dart';

/// Fuente única del avatar del usuario actual. El sidebar la escucha y el
/// perfil la actualiza al subir una foto, así se sincronizan sin reiniciar
/// la app ni recargar cada pantalla.
class CurrentUserAvatar extends ValueNotifier<String?> {
  CurrentUserAvatar._() : super(null);

  static final CurrentUserAvatar instance = CurrentUserAvatar._();
}
