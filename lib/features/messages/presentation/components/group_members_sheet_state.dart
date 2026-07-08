part of 'group_members_sheet.dart';

class _GroupMembersSheetState extends State<GroupMembersSheet> {
  bool _adding = false;
  bool _loading = false;
  String _search = '';
  final Set<int> _selected = {};

  Future<void> _startAdding() async {
    setState(() {
      _adding = true;
      _search = '';
    });
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
    final conv = widget.provider.conversation;
    final members = conv.members;
    final memberIds = members.map((m) => m.id).toSet();
    final q = _search.trim().toLowerCase();
    final available = widget.provider.contacts
        .where((c) => !memberIds.contains(c.id))
        .where((c) => q.isEmpty || c.name.toLowerCase().contains(q))
        .toList();
    final description = conv.description?.trim() ?? '';

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
              // Solo el creador del grupo puede agregar miembros.
              if (!_adding && widget.provider.isCreator)
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
          // Descripción del grupo (visible para todos).
          if (!_adding && description.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              description,
              style: GoogleFonts.poppins(
                color: p.textSecondary,
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ],
          // Buscador de contactos al agregar.
          if (_adding) ...[
            const SizedBox(height: 10),
            TextField(
              autofocus: true,
              onChanged: (v) => setState(() => _search = v),
              style: GoogleFonts.poppins(color: p.textPrimary, fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Buscar integrante...',
                hintStyle: GoogleFonts.poppins(
                  color: p.textMuted,
                  fontSize: 14,
                ),
                prefixIcon: Icon(Icons.search, size: 20, color: p.textMuted),
                isDense: true,
                filled: true,
                fillColor: p.rowSurface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: p.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: p.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppPalette.accent),
                ),
              ),
            ),
          ],
          const SizedBox(height: 8),
          Flexible(
            child: _adding
                ? (available.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          child: Text(
                            q.isEmpty
                                ? 'No hay contactos para agregar.'
                                : 'Sin resultados para "$_search".',
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
