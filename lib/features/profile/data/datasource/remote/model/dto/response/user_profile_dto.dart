class UserProfileDto {
  final int id;
  final String name;
  final String lastName;
  final String email;
  final String role;
  final int? roleId;
  final int? circuitId;
  final String? circuitCode;
  final int? createdBy;
  final String? profileImage;
  final String? phoneNumber;
  final String? dialCode;
  final String? username;
  final String? createdAt;
  final bool tourCompleted;

  const UserProfileDto({
    required this.id,
    required this.name,
    required this.lastName,
    required this.email,
    required this.role,
    this.roleId,
    this.circuitId,
    this.circuitCode,
    this.createdBy,
    this.profileImage,
    this.phoneNumber,
    this.dialCode,
    this.username,
    this.createdAt,
    this.tourCompleted = false,
  });

  String get fullName => '$name $lastName';

  factory UserProfileDto.fromJson(Map<String, dynamic> json) => UserProfileDto(
    id: json['id'] as int,
    name: json['name'] as String? ?? '',
    lastName: json['last_name'] as String? ?? '',
    email: json['email'] as String? ?? '',
    role: json['role_name'] as String? ?? json['role'] as String? ?? '',
    roleId: json['role_id'] as int?,
    circuitId: json['circuit_id'] as int?,
    circuitCode: json['circuit_code'] as String?,
    createdBy: json['created_by'] as int?,
    profileImage: json['profile_image'] as String?,
    phoneNumber: json['phone_number'] as String?,
    dialCode: json['dial_code'] as String?,
    username: json['username'] as String?,
    createdAt: json['created_at'] as String?,
    tourCompleted: json['tour_completed'] as bool? ?? false,
  );
}
