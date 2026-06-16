import 'package:flutter/material.dart';
import '../../../../domain/entities/class_detail.dart';
import '../../../../domain/entities/class_item.dart';
import '../../../../domain/entities/class_member.dart';
import '../model/dto/response/group_response_dto.dart';

class ClassMapper {
  const ClassMapper._();

  static const _memberColors = [
    Color(0xFFF97316),
    Color(0xFF3B82F6),
    Color(0xFF22C55E),
    Color(0xFFA855F7),
    Color(0xFFEC4899),
    Color(0xFF14B8A6),
  ];

  static ClassItem toItem(GroupResponseDto dto) => ClassItem(
    id: dto.id.toString(),
    name: dto.name,
    subject: dto.subject,
    professor: dto.professorName ?? '',
    studentCount: dto.members.length,
    lastActivity: '',
    imageUrl: dto.coverImage,
  );

  static ClassDetail toDetail(GroupResponseDto dto) {
    final teacher = dto.professorName ?? 'Profesor';
    final initials = teacher
        .split(' ')
        .take(2)
        .where((w) => w.isNotEmpty)
        .map((w) => w[0].toUpperCase())
        .join();

    final members = dto.members.asMap().entries.map((e) {
      final m = e.value;
      final color = _memberColors[e.key % _memberColors.length];
      final memberInitials =
          '${m.name.isNotEmpty ? m.name[0] : ''}${m.lastName.isNotEmpty ? m.lastName[0] : ''}'
              .toUpperCase();
      return ClassMember(
        initials: memberInitials,
        color: color,
        name: '${m.name} ${m.lastName}',
      );
    }).toList();

    DateTime? createdAt;
    try {
      createdAt = DateTime.parse(dto.createdAt);
    } catch (_) {
      createdAt = DateTime.now();
    }

    return ClassDetail(
      id: dto.id.toString(),
      name: dto.name,
      subject: dto.subject,
      badgeLabel: 'FERMENTACIÓN',
      studentCount: dto.members.length,
      createdAt: createdAt,
      teacherName: teacher,
      teacherEmail:
          '${teacher.toLowerCase().replaceAll(' ', '.')}@nich-ka.space',
      teacherInitials: initials,
      teacherAvatarColor: const Color(0xFF75D079),
      members: members,
      totalMembers: dto.members.length,
      fermentations: const [],
      coverImage: dto.coverImage,
    );
  }
}
