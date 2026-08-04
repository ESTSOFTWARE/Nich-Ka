import '../../domain/entities/class_detail.dart';
import '../states/ui_state.dart';

class JoinClassState {
  final bool isScrolled;
  final UiState<void> joinState;

  /// Código actual (refleja el TextField) para habilitar el botón.
  final String code;

  /// La clase a la que se acaba de unir (para navegar a su detalle).
  final ClassDetail? joinedClass;

  const JoinClassState({
    this.isScrolled = false,
    this.joinState = const UiIdle(),
    this.code = '',
    this.joinedClass,
  });

  static const Object _keep = Object();

  JoinClassState copyWith({
    bool? isScrolled,
    UiState<void>? joinState,
    String? code,
    Object? joinedClass = _keep,
  }) => JoinClassState(
    isScrolled: isScrolled ?? this.isScrolled,
    joinState: joinState ?? this.joinState,
    code: code ?? this.code,
    joinedClass: identical(joinedClass, _keep)
        ? this.joinedClass
        : joinedClass as ClassDetail?,
  );
}
