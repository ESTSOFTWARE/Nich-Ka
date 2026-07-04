import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/theme/app_palette.dart';
import '../providers/group_chat_provider.dart';

part 'group_members_sheet_state.dart';

class GroupMembersSheet extends StatefulWidget {
  final GroupChatProvider provider;
  final AppPalette palette;
  final int myUserId;

  const GroupMembersSheet({
    super.key,
    required this.provider,
    required this.palette,
    required this.myUserId,
  });

  @override
  State<GroupMembersSheet> createState() => _GroupMembersSheetState();
}
