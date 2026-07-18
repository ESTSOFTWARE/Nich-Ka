part of 'class_members_view.dart';

class _ClassMembersViewState extends State<ClassMembersView> {
  final _searchCtrl = TextEditingController();
  String _search = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<ClassMember> get _filtered {
    if (_search.isEmpty) return widget.members;
    final q = _search.toLowerCase();
    return widget.members
        .where(
          (m) =>
              m.name.toLowerCase().contains(q) ||
              (m.email?.toLowerCase().contains(q) ?? false),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = AppThemeScope.of(context).isDark;
    final palette = ClassPalette.of(isDark);
    final homePalette = AppPalette.of(isDark);
    final filtered = _filtered;

    return Scaffold(
      backgroundColor: palette.background,
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: AppBar(
              backgroundColor: homePalette.glassBackground,
              elevation: 0,
              scrolledUnderElevation: 0,
              systemOverlayStyle: isDark
                  ? SystemUiOverlayStyle.light
                  : SystemUiOverlayStyle.dark,
              automaticallyImplyLeading: false,
              centerTitle: false,
              leadingWidth: 56,
              leading: Center(
                child: GestureDetector(
                  onTap: () =>
                      context.canPop() ? context.pop() : context.go('/classes'),
                  child: Container(
                    width: 36,
                    height: 36,
                    margin: const EdgeInsets.only(left: 16),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: palette.border),
                    ),
                    child: Icon(
                      Icons.chevron_left,
                      color: palette.textPrimary,
                      size: 22,
                    ),
                  ),
                ),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Alumnos',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: palette.textPrimary,
                    ),
                  ),
                  Text(
                    widget.className,
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: palette.textSecondary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          HomeGlow(palette: homePalette),
          Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).padding.top + kToolbarHeight,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: TextField(
                  controller: _searchCtrl,
                  onChanged: (v) => setState(() => _search = v),
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: palette.textPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Buscar alumno...',
                    hintStyle: GoogleFonts.poppins(
                      fontSize: 14,
                      color: palette.textMuted,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: palette.textMuted,
                      size: 20,
                    ),
                    suffixIcon: _search.isNotEmpty
                        ? IconButton(
                            icon: Icon(
                              Icons.close,
                              color: palette.textMuted,
                              size: 18,
                            ),
                            onPressed: () {
                              _searchCtrl.clear();
                              setState(() => _search = '');
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: palette.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: palette.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: palette.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: ClassPalette.accent,
                        width: 1.5,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 11,
                    ),
                    isDense: true,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Row(
                  children: [
                    Text(
                      '${filtered.length} alumno${filtered.length != 1 ? 's' : ''}',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: palette.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: filtered.isEmpty
                    ? _buildEmpty(palette)
                    : ListView.separated(
                        padding: EdgeInsets.fromLTRB(
                          16,
                          0,
                          16,
                          MediaQuery.of(context).padding.bottom + 16,
                        ),
                        itemCount: filtered.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 8),
                        itemBuilder: (_, i) =>
                            _MemberTile(member: filtered[i], palette: palette),
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty(ClassPalette palette) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.person_search_outlined,
            size: 56,
            color: palette.textMuted,
          ),
          const SizedBox(height: 16),
          Text(
            'Sin resultados',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: palette.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'No hay alumnos que coincidan con tu búsqueda.',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: palette.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
