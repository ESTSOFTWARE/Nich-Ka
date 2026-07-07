class GroupMemberResponseDto {
  final int id;
  final int studentId;
  final String name;
  final String lastName;
  final String email;
  final String? avatar;

  const GroupMemberResponseDto({
    required this.id,
    required this.studentId,
    required this.name,
    required this.lastName,
    required this.email,
    this.avatar,
  });

  factory GroupMemberResponseDto.fromJson(Map<String, dynamic> json) =>
      GroupMemberResponseDto(
        id: json['id'] as int,
        studentId: json['student_id'] as int,
        name: json['name'] as String,
        lastName: json['last_name'] as String,
        email: json['email'] as String,
        avatar: json['avatar'] as String?,
      );
}
