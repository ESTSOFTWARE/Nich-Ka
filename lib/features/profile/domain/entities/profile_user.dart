class ProfileUser {
  final String firstName;
  final String lastName;
  final String email;
  final String role;
  final String circuit;
  final String memberSince;
  final String? profileImage;
  final String? dialCode;
  final String? phoneNumber;
  final String? description;

  const ProfileUser({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.role,
    required this.circuit,
    required this.memberSince,
    this.profileImage,
    this.dialCode,
    this.phoneNumber,
    this.description,
  });

  String get fullName => '$firstName $lastName';
}
