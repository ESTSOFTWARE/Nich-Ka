import '../../../core/network/http_client.dart';
import '../data/datasource/remote/auth_remote_datasource.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../domain/use_cases/change_password_use_case.dart';
import '../domain/use_cases/login_use_case.dart';
import '../domain/use_cases/login_with_google_use_case.dart';
import '../domain/use_cases/logout_use_case.dart';
import '../domain/use_cases/send_forgot_password_use_case.dart';

class AuthDependencies {
  AuthDependencies._();

  static final AuthRemoteDataSource _dataSource =
      AuthRemoteDataSource(HttpClient.instance);

  static final AuthRepositoryImpl _repository =
      AuthRepositoryImpl(_dataSource);

  static LoginUseCase get loginWithEmail =>
      LoginUseCase(_repository);

  static LoginWithGoogleUseCase get loginWithGoogle =>
      LoginWithGoogleUseCase(_repository);

  static SendForgotPasswordUseCase get sendForgotPassword =>
      SendForgotPasswordUseCase(_repository);

  static ChangePasswordUseCase get changePassword =>
      ChangePasswordUseCase(_repository);

  static LogoutUseCase get logout =>
      LogoutUseCase(_repository);
}
