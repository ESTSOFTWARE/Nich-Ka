import 'package:flutter/material.dart';

class ClassMember {
  final String initials;
  final Color color;
  final String name;
  final String? email;

  const ClassMember({
    required this.initials,
    required this.color,
    required this.name,
    this.email,
  });
}
