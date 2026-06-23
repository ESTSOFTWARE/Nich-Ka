class MemberDto {
  final int id;
  final String name;
  final String role;
  final String? avatar;

  const MemberDto({
    required this.id,
    required this.name,
    required this.role,
    this.avatar,
  });

  factory MemberDto.fromJson(Map<String, dynamic> json) => MemberDto(
        id: json['id'] as int,
        name: json['name'] as String,
        role: json['role'] as String,
        avatar: json['avatar'] as String?,
      );
}
