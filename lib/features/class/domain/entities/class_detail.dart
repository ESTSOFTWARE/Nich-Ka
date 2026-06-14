import 'package:flutter/material.dart';
import 'class_fermentation.dart';
import 'class_item.dart';
import 'class_member.dart';

class ClassDetail {
  final String id;
  final String name;
  final String subject;
  final String badgeLabel;
  final int studentCount;
  final DateTime createdAt;
  final String teacherName;
  final String teacherEmail;
  final String teacherInitials;
  final Color teacherAvatarColor;
  final List<ClassMember> members;
  final int totalMembers;
  final List<ClassFermentation> fermentations;

  const ClassDetail({
    required this.id,
    required this.name,
    required this.subject,
    required this.badgeLabel,
    required this.studentCount,
    required this.createdAt,
    required this.teacherName,
    required this.teacherEmail,
    required this.teacherInitials,
    required this.teacherAvatarColor,
    required this.members,
    required this.totalMembers,
    required this.fermentations,
  });

  factory ClassDetail.fromItem(ClassItem item) {
    String initials(String name) => name
        .split(' ')
        .take(2)
        .where((w) => w.isNotEmpty)
        .map((w) => w[0].toUpperCase())
        .join();

    return ClassDetail(
      id: item.id,
      name: item.name,
      subject: item.subject,
      badgeLabel: 'FERMENTACIÓN',
      studentCount: item.studentCount,
      createdAt: DateTime(2026, 5, 22),
      teacherName: item.professor,
      teacherEmail:
          '${item.professor.toLowerCase().replaceAll(' ', '.')}@nich-ka.space',
      teacherInitials: initials(item.professor),
      teacherAvatarColor: const Color(0xFF75D079),
      totalMembers: item.studentCount,
      members: const [
        ClassMember(
          initials: 'CR',
          color: Color(0xFFF97316),
          name: 'Carlos Ramírez',
        ),
        ClassMember(
          initials: 'JS',
          color: Color(0xFF3B82F6),
          name: 'Juan Salazar',
        ),
        ClassMember(
          initials: 'MC',
          color: Color(0xFF22C55E),
          name: 'María Cruz',
        ),
      ],
      fermentations: const [
        ClassFermentation(
          id: 'F-024',
          variety: 'Caturra',
          process: 'Lavado',
          isActive: true,
        ),
        ClassFermentation(
          id: 'F-023',
          variety: 'Geisha',
          process: 'Honey',
          isActive: false,
        ),
      ],
    );
  }

  static final mock = ClassDetail(
    id: 'cls-001',
    name: '5A BIOTECNOLOGÍA 2026',
    subject: 'BIOTECNOLOGÍA AGROINDUSTRIAL',
    badgeLabel: 'FERMENTACIÓN',
    studentCount: 24,
    createdAt: DateTime(2026, 5, 22),
    teacherName: 'Dorian Toledo',
    teacherEmail: 'dorian.toledo@nich-ka.space',
    teacherInitials: 'DT',
    teacherAvatarColor: const Color(0xFF75D079),
    totalMembers: 24,
    members: const [
      ClassMember(
        initials: 'CR',
        color: Color(0xFFF97316),
        name: 'Carlos Ramírez',
      ),
      ClassMember(
        initials: 'JS',
        color: Color(0xFF3B82F6),
        name: 'Juan Salazar',
      ),
      ClassMember(initials: 'MC', color: Color(0xFF22C55E), name: 'María Cruz'),
    ],
    fermentations: const [
      ClassFermentation(
        id: 'F-024',
        variety: 'Caturra',
        process: 'Lavado',
        isActive: true,
      ),
      ClassFermentation(
        id: 'F-023',
        variety: 'Geisha',
        process: 'Honey',
        isActive: false,
      ),
    ],
  );
}
