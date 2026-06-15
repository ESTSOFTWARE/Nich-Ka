class AuthToken {
  final String token;
  final int userId;
  final String name;
  final String lastName;
  final String email;
  final String role;
  final String? profileImage;
  final String oauthProvider;

  const AuthToken({
    required this.token,
    required this.userId,
    required this.name,
    required this.lastName,
    required this.email,
    required this.role,
    this.profileImage,
    required this.oauthProvider,
  });
}
