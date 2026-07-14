import '../states/ui_state.dart';

class ChangePasswordState {
  final UiState<void> status;
  final bool currentObscured;
  final bool newObscured;
  final bool confirmObscured;

  const ChangePasswordState({
    this.status = const UiIdle(),
    this.currentObscured = true,
    this.newObscured = true,
    this.confirmObscured = true,
  });

  ChangePasswordState copyWith({
    UiState<void>? status,
    bool? currentObscured,
    bool? newObscured,
    bool? confirmObscured,
  }) => ChangePasswordState(
    status: status ?? this.status,
    currentObscured: currentObscured ?? this.currentObscured,
    newObscured: newObscured ?? this.newObscured,
    confirmObscured: confirmObscured ?? this.confirmObscured,
  );
}
