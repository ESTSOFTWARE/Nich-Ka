class AuthUserResponseDto {
  final int id;
  final String name;
  final String lastName;
  final String email;
  final String role;
  final String? profileImage;
  final String oauthProvider;

  const AuthUserResponseDto({
    required this.id,
    required this.name,
    required this.lastName,
    required this.email,
    required this.role,
    this.profileImage,
    required this.oauthProvider,
  });

  factory AuthUserResponseDto.fromJson(Map<String, dynamic> json) =>
      AuthUserResponseDto(
        id: json['id'] as int,
        name: json['name'] as String,
        lastName: json['last_name'] as String,
        email: json['email'] as String,
        role: json['role'] as String,
        profileImage: json['profile_image'] as String?,
        oauthProvider: json['oauth_provider'] as String? ?? 'email',
      );
}
