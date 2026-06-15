class ChangePasswordRequestDto {
  final String currentPassword;
  final String newPassword;
  final String confirmPassword;

  const ChangePasswordRequestDto({
    required this.currentPassword,
    required this.newPassword,
    required this.confirmPassword,
  });

  Map<String, dynamic> toJson() => {
    'current_password': currentPassword,
    'new_password': newPassword,
    'confirm_password': confirmPassword,
  };
}
