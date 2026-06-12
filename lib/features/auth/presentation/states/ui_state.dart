/// Responsabilidad única: representar el estado de una operación asíncrona de
/// la UI (autenticación, carga de datos, etc.).
///
/// `sealed` permite cubrir todos los casos con `switch` de forma exhaustiva:
///
/// ```dart
/// switch (state) {
///   case UiIdle():    // formulario en reposo
///   case UiLoading(): // mostrando spinner
///   case UiSuccess(:final data): // éxito con datos
///   case UiError(:final message): // mostrando error
/// }
/// ```
sealed class UiState<T> {
  const UiState();
}

/// Estado inicial: aún no se ha disparado ninguna operación.
class UiIdle<T> extends UiState<T> {
  const UiIdle();
}

/// Operación en curso (mostrar spinner / deshabilitar botones).
class UiLoading<T> extends UiState<T> {
  const UiLoading();
}

/// Operación completada con éxito; expone el resultado en [data].
class UiSuccess<T> extends UiState<T> {
  final T data;
  const UiSuccess(this.data);
}

/// Operación fallida; expone el mensaje en [message].
class UiError<T> extends UiState<T> {
  final String message;
  const UiError(this.message);
}
