import '../../domain/entities/profile_user.dart';
import '../states/ui_state.dart';

/// Estado inmutable del drawer (usuario del encabezado + estado de logout).
class DrawerState {
  final UiState<ProfileUser> userState;
  final UiState<void> logoutState;

  const DrawerState({
    this.userState = const UiIdle(),
    this.logoutState = const UiIdle(),
  });

  ProfileUser? get user => switch (userState) {
    UiSuccess<ProfileUser> s => s.data,
    _ => null,
  };

  bool get isLoggingOut => logoutState is UiLoading;

  DrawerState copyWith({
    UiState<ProfileUser>? userState,
    UiState<void>? logoutState,
  }) => DrawerState(
    userState: userState ?? this.userState,
    logoutState: logoutState ?? this.logoutState,
  );
}
