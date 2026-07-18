import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/entities/chat_conversation.dart';
import '../../domain/entities/chat_member.dart';
import '../../../../shared/theme/app_palette.dart';

part 'new_conversation_sheet_state.dart';

const _roleLabel = {
  'docente': 'Docente',
  'estudiante': 'Estudiante',
  'admin': 'Admin',
  'soporte': 'Soporte',
};

Future<ChatConversation?> showNewConversationSheet({
  required BuildContext context,
  required AppPalette palette,
  required List<ChatMember> contacts,
  required Future<ChatConversation?> Function({
    required String type,
    required List<int> memberIds,
    String? name,
  })
  onCreate,
}) {
  return showModalBottomSheet<ChatConversation>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _NewConversationSheet(
      palette: palette,
      contacts: contacts,
      onCreate: onCreate,
    ),
  );
}

class _NewConversationSheet extends StatefulWidget {
  final AppPalette palette;
  final List<ChatMember> contacts;
  final Future<ChatConversation?> Function({
    required String type,
    required List<int> memberIds,
    String? name,
  })
  onCreate;

  const _NewConversationSheet({
    required this.palette,
    required this.contacts,
    required this.onCreate,
  });

  @override
  State<_NewConversationSheet> createState() => _NewConversationSheetState();
}
