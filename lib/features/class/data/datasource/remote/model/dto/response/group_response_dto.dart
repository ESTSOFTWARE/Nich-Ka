import 'group_member_response_dto.dart';

class GroupResponseDto {
  final int id;
  final String name;
  final String subject;
  final String? coverImage;
  final String? professorName;
  final String createdAt;
  final List<GroupMemberResponseDto> members;

  const GroupResponseDto({
    required this.id,
    required this.name,
    required this.subject,
    this.coverImage,
    this.professorName,
    required this.createdAt,
    required this.members,
  });

  factory GroupResponseDto.fromJson(Map<String, dynamic> json) =>
      GroupResponseDto(
        id: json['id'] as int,
        name: json['name'] as String,
        subject: json['subject'] as String,
        coverImage: json['cover_image'] as String?,
        professorName: json['professor_name'] as String?,
        createdAt: json['created_at'] as String? ?? '',
        members: (json['members'] as List<dynamic>)
            .map(
              (m) => GroupMemberResponseDto.fromJson(m as Map<String, dynamic>),
            )
            .toList(),
      );
}
