import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/theme/app_palette.dart';
import '../../../../core/validation/input_formatters.dart';

part 'group_message_input_state.dart';

class GroupMessageInput extends StatefulWidget {
  final AppPalette palette;
  final ValueChanged<String> onSend;

  const GroupMessageInput({
    super.key,
    required this.palette,
    required this.onSend,
  });

  @override
  State<GroupMessageInput> createState() => _GroupMessageInputState();
}
