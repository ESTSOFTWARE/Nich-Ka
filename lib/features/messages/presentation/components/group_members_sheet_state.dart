part of 'group_members_sheet.dart';

class _GroupMembersSheetState extends State<GroupMembersSheet> {
  bool _adding = false;
  bool _loading = false;
  final Set<int> _selected = {};

  Future<void> _startAdding() async {
    setState(() => _adding = true);
    await widget.provider.loadContacts();
    if (mounted) setState(() {});
  }

  Future<void> _confirmAdd() async {
    if (_selected.isEmpty) return;
    setState(() => _loading = true);
    await widget.provider.addMembers(_selected.toList());
    if (mounted) {
      setState(() {
        _loading = false;
        _adding = false;
        _selected.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.palette;
    final members = widget.provider.conversation.members;
    final memberIds = members.map((m) => m.id).toSet();
    final available = widget.provider.contacts
        .where((c) => !memberIds.contains(c.id))
        .toList();

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 12,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: p.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Row(
            children: [
              Text(
                _adding
                    ? 'Agregar integrantes'
                    : 'Integrantes (${members.length})',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: p.textPrimary,
                ),
              ),
              const Spacer(),
              if (!_adding)
                TextButton.icon(
                  onPressed: _startAdding,
                  icon: const Icon(
                    Icons.person_add_alt_1,
                    size: 18,
                    color: AppPalette.accent,
                  ),
                  label: Text(
                    'Agregar',
                    style: GoogleFonts.poppins(
                      color: AppPalette.accent,
                      fontSize: 13,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Flexible(
            child: _adding
                ? (available.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          child: Text(
                            'No hay contactos para agregar.',
                            style: GoogleFonts.poppins(color: p.textMuted),
                          ),
                        )
                      : ListView(
                          shrinkWrap: true,
                          children: available.map((c) {
                            final sel = _selected.contains(c.id);
                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              onTap: () => setState(
                                () => sel
                                    ? _selected.remove(c.id)
                                    : _selected.add(c.id),
                              ),
                              leading: _avatar(c.name, c.avatar),
                              title: Text(
                                c.name,
                                style: GoogleFonts.poppins(
                                  color: p.textPrimary,
                                  fontSize: 14,
                                ),
                              ),
                              subtitle: Text(
                                c.role,
                                style: GoogleFonts.poppins(
                                  color: p.textMuted,
                                  fontSize: 11,
                                ),
                              ),
                              trailing: Icon(
                                sel
                                    ? Icons.check_circle
                                    : Icons.circle_outlined,
                                color: sel ? AppPalette.accent : p.textMuted,
                              ),
                            );
                          }).toList(),
                        ))
                : ListView(
                    shrinkWrap: true,
                    children: members
                        .map(
                          (m) => ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: _avatar(m.name, m.avatar),
                            title: Text(
                              m.id == widget.myUserId
                                  ? '${m.name} (tú)'
                                  : m.name,
                              style: GoogleFonts.poppins(
                                color: p.textPrimary,
                                fontSize: 14,
                              ),
                            ),
                            subtitle: Text(
                              m.role,
                              style: GoogleFonts.poppins(
                                color: p.textMuted,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
          ),
          if (_adding) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: (_selected.isEmpty || _loading) ? null : _confirmAdd,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppPalette.accent,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: _loading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        'Agregar ${_selected.length}',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _avatar(String name, [String? avatar]) {
    final initials = Text(
      name.isNotEmpty ? name[0].toUpperCase() : '?',
      style: const TextStyle(color: AppPalette.accent, fontSize: 14),
    );
    if (avatar == null || avatar.isEmpty) {
      return CircleAvatar(
        radius: 18,
        backgroundColor: AppPalette.accent.withValues(alpha: 0.2),
        child: initials,
      );
    }
    return CircleAvatar(
      radius: 18,
      backgroundColor: AppPalette.accent.withValues(alpha: 0.2),
      child: ClipOval(
        child: Image.network(
          avatar,
          width: 36,
          height: 36,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stack) => initials,
        ),
      ),
    );
  }
}
