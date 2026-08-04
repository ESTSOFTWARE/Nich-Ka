import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/http_client.dart';
import '../../../../core/session/current_user_avatar.dart';
import '../../../auth/data/datasource/remote/auth_remote_datasource.dart';
import '../../../auth/data/repositories/auth_repository_impl.dart';
import '../../../auth/domain/use_cases/logout_use_case.dart';
import '../../data/datasource/remote/profile_remote_datasource.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../domain/use_cases/get_profile_use_case.dart';
import '../states/ui_state.dart';
import 'drawer_state.dart';

class DrawerNotifier extends Notifier<DrawerState> {
  late final GetProfileUseCase _getProfile;
  late final LogoutUseCase _logout;

  @override
  DrawerState build() {
    _getProfile = GetProfileUseCase(
      ProfileRepositoryImpl(ProfileRemoteDataSource(HttpClient.instance)),
    );
    _logout = LogoutUseCase(
      AuthRepositoryImpl(AuthRemoteDataSource(HttpClient.instance)),
    );
    Future.microtask(loadUser);
    return const DrawerState();
  }

  Future<void> loadUser() async {
    state = state.copyWith(userState: const UiLoading());
    try {
      final user = await _getProfile();
      CurrentUserAvatar.instance.value = user.profileImage;
      state = state.copyWith(userState: UiSuccess(user));
    } catch (e) {
      state = state.copyWith(
        userState: UiError(e.toString().replaceFirst('Exception: ', '')),
      );
    }
  }

  Future<void> logout() async {
    state = state.copyWith(logoutState: const UiLoading());
    try {
      await _logout();
    } catch (_) {
      // Aunque falle la API, se limpia la sesión local.
    }
    HttpClient.instance.clearTokens();
    state = state.copyWith(logoutState: const UiSuccess(null));
  }
}

final drawerProvider = NotifierProvider<DrawerNotifier, DrawerState>(
  DrawerNotifier.new,
);
