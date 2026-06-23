import 'member_dto.dart';
import 'message_dto.dart';

class ConversationDto {
  final int id;
  final String type;
  final String? name;
  final String? description;
  final String? avatar;
  final List<MemberDto> members;
  final MessageDto? lastMessage;
  final int unreadCount;
  final DateTime createdAt;
  final int createdBy;

  const ConversationDto({
    required this.id,
    required this.type,
    required this.createdAt,
    required this.createdBy,
    this.name,
    this.description,
    this.avatar,
    this.members = const [],
    this.lastMessage,
    this.unreadCount = 0,
  });

  factory ConversationDto.fromJson(Map<String, dynamic> json) =>
      ConversationDto(
        id: json['id'] as int,
        type: json['type'] as String,
        name: json['name'] as String?,
        description: json['description'] as String?,
        avatar: json['avatar'] as String?,
        members: (json['members'] as List<dynamic>? ?? [])
            .map((m) => MemberDto.fromJson(m as Map<String, dynamic>))
            .toList(),
        lastMessage: json['lastMessage'] != null
            ? MessageDto.fromJson(json['lastMessage'] as Map<String, dynamic>)
            : null,
        unreadCount: (json['unreadCount'] as num?)?.toInt() ?? 0,
        createdAt: DateTime.parse(json['createdAt'] as String),
        createdBy: json['createdBy'] as int,
      );
}
