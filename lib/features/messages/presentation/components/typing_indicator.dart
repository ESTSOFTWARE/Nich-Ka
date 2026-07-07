import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/group_chat_provider.dart';
import '../../../../shared/theme/app_palette.dart';

part 'typing_indicator_state.dart';
part 'typing_dots.dart';

class TypingIndicator extends StatefulWidget {
  final List<TypingUser> users;
  final AppPalette palette;

  const TypingIndicator({
    super.key,
    required this.users,
    required this.palette,
  });

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}
