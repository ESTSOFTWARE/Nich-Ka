import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/entities/chat_conversation.dart';
import '../../domain/entities/chat_member.dart';
import '../../../../shared/theme/app_palette.dart';

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

class _NewConversationSheetState extends State<_NewConversationSheet> {
  String _type = 'personal';
  final List<int> _selected = [];
  String _search = '';
  String _groupName = '';
  bool _loading = false;

  List<ChatMember> get _filtered => widget.contacts
      .where(
        (m) =>
            m.name.toLowerCase().contains(_search.toLowerCase()) ||
            (_roleLabel[m.role] ?? m.role).toLowerCase().contains(
              _search.toLowerCase(),
            ),
      )
      .toList();

  bool get _canCreate =>
      _selected.isNotEmpty &&
      (_type == 'personal' || _groupName.trim().isNotEmpty);

  void _toggle(int id) {
    setState(() {
      if (_type == 'personal') {
        _selected
          ..clear()
          ..add(id);
      } else {
        _selected.contains(id) ? _selected.remove(id) : _selected.add(id);
      }
    });
  }

  Future<void> _submit() async {
    if (!_canCreate || _loading) return;
    setState(() => _loading = true);
    final conv = await widget.onCreate(
      type: _type,
      memberIds: List.from(_selected),
      name: _type == 'group' ? _groupName.trim() : null,
    );
    if (mounted) Navigator.of(context).pop(conv);
  }

  @override
  Widget build(BuildContext context) {
    final bottom =
        MediaQuery.of(context).viewInsets.bottom +
        MediaQuery.of(context).padding.bottom;

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: widget.palette.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 8),
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: widget.palette.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 16, 12),
            child: Row(
              children: [
                Text(
                  'Nueva conversación',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: widget.palette.textPrimary,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(
                    Icons.close,
                    color: widget.palette.textMuted,
                    size: 20,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                // Type selector
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: widget.palette.background,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      _typeButton(
                        'personal',
                        Icons.person_outline,
                        'Chat personal',
                      ),
                      _typeButton('group', Icons.group_outlined, 'Chat grupal'),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                // Group name field
                if (_type == 'group') ...[
                  TextField(
                    onChanged: (v) => setState(() => _groupName = v),
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: widget.palette.textPrimary,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Nombre del grupo',
                      hintStyle: GoogleFonts.poppins(
                        fontSize: 14,
                        color: widget.palette.textMuted,
                      ),
                      filled: true,
                      fillColor: widget.palette.rowSurface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: widget.palette.border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: widget.palette.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: AppPalette.accent,
                          width: 1.5,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      isDense: true,
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                // Search
                TextField(
                  onChanged: (v) => setState(() => _search = v),
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: widget.palette.textPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Buscar persona...',
                    hintStyle: GoogleFonts.poppins(
                      fontSize: 14,
                      color: widget.palette.textMuted,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: widget.palette.textMuted,
                      size: 20,
                    ),
                    filled: true,
                    fillColor: widget.palette.rowSurface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: widget.palette.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: widget.palette.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: AppPalette.accent,
                        width: 1.5,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    isDense: true,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Contact list
          Expanded(
            child: _filtered.isEmpty
                ? Center(
                    child: Text(
                      'Sin resultados',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: widget.palette.textMuted,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    itemCount: _filtered.length,
                    itemBuilder: (_, i) => _contactTile(_filtered[i]),
                  ),
          ),
          // Footer button
          Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, bottom > 0 ? bottom : 16),
            child: GestureDetector(
              onTap: _canCreate && !_loading ? _submit : null,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: _canCreate
                      ? AppPalette.accent
                      : AppPalette.accent.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(14),
                ),
                alignment: Alignment.center,
                child: _loading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.black,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        _type == 'personal' ? 'Iniciar chat' : 'Crear grupo',
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _typeButton(String type, IconData icon, String label) {
    final selected = _type == type;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() {
          _type = type;
          _selected.clear();
        }),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? widget.palette.surface : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: selected ? widget.palette.border : Colors.transparent,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: selected
                    ? widget.palette.textPrimary
                    : widget.palette.textMuted,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                  color: selected
                      ? widget.palette.textPrimary
                      : widget.palette.textMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _contactTile(ChatMember member) {
    final isSelected = _selected.contains(member.id);
    final color = _colorForName(member.name);

    return GestureDetector(
      onTap: () => _toggle(member.id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        margin: const EdgeInsets.symmetric(vertical: 3),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? AppPalette.accent.withValues(alpha: 0.08)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withValues(alpha: 0.15),
                border: Border.all(color: color.withValues(alpha: 0.3)),
              ),
              child: member.avatar != null
                  ? ClipOval(
                      child: Image.network(
                        member.avatar!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => _initial(member, color),
                      ),
                    )
                  : _initial(member, color),
            ),
            const SizedBox(width: 12),
            // Name + role
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    member.name,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: widget.palette.textPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    _roleLabel[member.role] ?? member.role,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: widget.palette.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            // Checkbox
            AnimatedContainer(
              duration: const Duration(milliseconds: 120),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppPalette.accent : Colors.transparent,
                border: Border.all(
                  color: isSelected ? AppPalette.accent : widget.palette.border,
                  width: 1.5,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check, size: 13, color: Colors.black)
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _initial(ChatMember member, Color color) => Center(
    child: Text(
      member.name.isNotEmpty ? member.name[0].toUpperCase() : '?',
      style: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: color,
      ),
    ),
  );

  static const _palette = [
    Color(0xFF75D079),
    Color(0xFF60A5FA),
    Color(0xFFFBBF24),
    Color(0xFFF472B6),
    Color(0xFFA78BFA),
    Color(0xFF34D399),
  ];

  Color _colorForName(String name) {
    final idx = name.codeUnits.fold(0, (a, b) => a + b) % _palette.length;
    return _palette[idx];
  }
}
