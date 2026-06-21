import 'package:flutter/material.dart';
import '../../../../core/network/http_client.dart';
import '../../data/datasource/remote/profile_remote_datasource.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../domain/entities/profile_user.dart';
import '../../domain/use_cases/get_profile_use_case.dart';
import '../states/ui_state.dart';

class ProfileProvider extends ChangeNotifier {
  final GetProfileUseCase _getProfile;

  UiState<ProfileUser> _state = const UiIdle();
  UiState<ProfileUser> get state => _state;

  ProfileUser? get user => switch (_state) {
    UiSuccess<ProfileUser> s => s.data,
    _ => null,
  };

  bool get isGoogleLinked => true;

  ProfileProvider({GetProfileUseCase? getProfile})
    : _getProfile =
          getProfile ??
          GetProfileUseCase(
            ProfileRepositoryImpl(ProfileRemoteDataSource(HttpClient.instance)),
          ) {
    _init();
  }

  Future<void> _init() async {
    await Future.microtask(loadProfile);
  }

  void _setState(UiState<ProfileUser> state) {
    _state = state;
    notifyListeners();
  }

  Future<void> loadProfile() async {
    _setState(const UiLoading());
    try {
      final user = await _getProfile();
      _setState(UiSuccess(user));
    } catch (e) {
      _setState(UiError(e.toString().replaceFirst('Exception: ', '')));
    }
  }
}
