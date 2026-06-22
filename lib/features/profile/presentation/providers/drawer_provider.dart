import 'package:flutter/material.dart';
import '../../../../core/network/http_client.dart';
import '../../../auth/data/datasource/remote/auth_remote_datasource.dart';
import '../../../auth/data/repositories/auth_repository_impl.dart';
import '../../../auth/domain/use_cases/logout_use_case.dart';
import '../../data/datasource/remote/profile_remote_datasource.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../domain/entities/profile_user.dart';
import '../../domain/use_cases/get_profile_use_case.dart';
import '../states/ui_state.dart';

class DrawerProvider extends ChangeNotifier {
  final GetProfileUseCase _getProfile;
  final LogoutUseCase _logout;

  UiState<ProfileUser> _userState = const UiIdle();
  UiState<ProfileUser> get userState => _userState;

  UiState<void> _logoutState = const UiIdle();
  UiState<void> get logoutState => _logoutState;

  ProfileUser? get user => switch (_userState) {
    UiSuccess<ProfileUser> s => s.data,
    _ => null,
  };

  bool get isLoggingOut => _logoutState is UiLoading;

  DrawerProvider({
    GetProfileUseCase? getProfile,
    LogoutUseCase? logout,
  }) : _getProfile = getProfile ?? GetProfileUseCase(
        ProfileRepositoryImpl(ProfileRemoteDataSource(HttpClient.instance)),
      ),
      _logout = logout ?? LogoutUseCase(
        AuthRepositoryImpl(AuthRemoteDataSource(HttpClient.instance)),
      ) {
    _init();
  }

  Future<void> _init() async {
    await Future.microtask(loadUser);
  }

  void _setUserState(UiState<ProfileUser> state) {
    _userState = state;
    notifyListeners();
  }

  void _setLogoutState(UiState<void> state) {
    _logoutState = state;
    notifyListeners();
  }

  Future<void> loadUser() async {
    _setUserState(const UiLoading());
    try {
      final user = await _getProfile();
      _setUserState(UiSuccess(user));
    } catch (e) {
      _setUserState(UiError(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> logout() async {
    _setLogoutState(const UiLoading());
    try {
      await _logout();
    } catch (_) {
      // Even on API error, we clear local session
    }
    HttpClient.instance.clearTokens();
    _setLogoutState(const UiSuccess(null));
  }
}
