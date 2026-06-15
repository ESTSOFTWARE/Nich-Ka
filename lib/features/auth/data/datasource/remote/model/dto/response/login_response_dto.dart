import 'auth_user_response_dto.dart';

class LoginResponseDto {
  final String accessToken;
  final String refreshToken;
  final AuthUserResponseDto user;

  const LoginResponseDto({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  factory LoginResponseDto.fromJson(Map<String, dynamic> json) =>
      LoginResponseDto(
        accessToken: json['access_token'] as String,
        refreshToken: json['refresh_token'] as String,
        user: AuthUserResponseDto.fromJson(
          json['user'] as Map<String, dynamic>,
        ),
      );
}
