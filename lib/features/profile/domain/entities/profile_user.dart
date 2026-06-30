class ProfileUser {
  final String firstName;
  final String lastName;
  final String email;
  final String role;
  final String circuit;
  final String memberSince;
  final String? profileImage;

  const ProfileUser({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.role,
    required this.circuit,
    required this.memberSince,
    this.profileImage,
  });

  String get fullName => '$firstName $lastName';
}
