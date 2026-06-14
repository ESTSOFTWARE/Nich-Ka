import '../repositories/auth_repository.dart';

class SendForgotPasswordUseCase {
  final AuthRepository _repository;

  const SendForgotPasswordUseCase(this._repository);

  Future<void> call(String email) => _repository.sendForgotPassword(email);
}
