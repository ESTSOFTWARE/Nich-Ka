import 'package:flutter/material.dart';

class ClassMember {
  final int id;
  final String initials;
  final Color color;
  final String name;
  final String? email;
  final String? avatar;

  const ClassMember({
    this.id = 0,
    required this.initials,
    required this.color,
    required this.name,
    this.email,
    this.avatar,
  });
}
