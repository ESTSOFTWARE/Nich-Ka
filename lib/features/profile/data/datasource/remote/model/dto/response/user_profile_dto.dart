class UserProfileDto {
  final int id;
  final String name;
  final String lastName;
  final String email;
  final String role;
  final String? profileImage;
  final String? phoneNumber;
  final String? username;
  final String? createdAt;

  const UserProfileDto({
    required this.id,
    required this.name,
    required this.lastName,
    required this.email,
    required this.role,
    this.profileImage,
    this.phoneNumber,
    this.username,
    this.createdAt,
  });

  factory UserProfileDto.fromJson(Map<String, dynamic> json) => UserProfileDto(
    id: json['id'] as int,
    name: json['name'] as String? ?? '',
    lastName: json['last_name'] as String? ?? '',
    email: json['email'] as String? ?? '',
    role: json['role'] as String? ?? '',
    profileImage: json['profile_image'] as String?,
    phoneNumber: json['phone_number'] as String?,
    username: json['username'] as String?,
    createdAt: json['created_at'] as String?,
  );
}
