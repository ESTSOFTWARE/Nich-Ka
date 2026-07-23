import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/presentation/app_theme_scope.dart';
import '../../../../shared/theme/app_palette.dart';
import '../../../home/presentation/components/home_glow.dart';
import '../../domain/entities/class_member.dart';
import '../theme/class_palette.dart';
import '../../../../core/presentation/responsive_center.dart';

part 'class_members_view_state.dart';
part 'class_member_tile.dart';

class ClassMembersView extends StatefulWidget {
  final String className;
  final List<ClassMember> members;

  const ClassMembersView({
    super.key,
    required this.className,
    required this.members,
  });

  @override
  State<ClassMembersView> createState() => _ClassMembersViewState();
}
