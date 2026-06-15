import '../../../../domain/entities/auth_credentials.dart';
import '../../../../domain/entities/auth_token.dart';
import '../model/dto/request/change_password_request_dto.dart';
import '../model/dto/request/forgot_password_request_dto.dart';
import '../model/dto/request/login_request_dto.dart';
import '../model/dto/response/login_response_dto.dart';

class AuthMapper {
  const AuthMapper._();

  static LoginRequestDto toLoginRequest(AuthCredentials credentials) =>
      LoginRequestDto(email: credentials.email, password: credentials.password);

  static ForgotPasswordRequestDto toForgotPasswordRequest(String email) =>
      ForgotPasswordRequestDto(email: email);

  static ChangePasswordRequestDto toChangePasswordRequest({
    required String current,
    required String next,
  }) => ChangePasswordRequestDto(
    currentPassword: current,
    newPassword: next,
    confirmPassword: next,
  );

  static AuthToken fromLoginResponse(LoginResponseDto dto) => AuthToken(
    token: dto.accessToken,
    userId: dto.user.id,
    name: dto.user.name,
    lastName: dto.user.lastName,
    email: dto.user.email,
    role: dto.user.role,
    profileImage: dto.user.profileImage,
    oauthProvider: dto.user.oauthProvider,
  );
}
