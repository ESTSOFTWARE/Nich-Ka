import '../repositories/auth_repository.dart';

class ChangePasswordUseCase {
  final AuthRepository _repository;

  const ChangePasswordUseCase(this._repository);

  Future<void> call({required String current, required String next}) =>
      _repository.changePassword(current: current, next: next);
}
