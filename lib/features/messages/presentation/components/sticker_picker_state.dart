part of 'sticker_picker.dart';

class _StickerPickerState extends State<StickerPicker>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<StickerPack> _packs;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _packs = StickerPacksData.localPacks;
    _tabController = TabController(length: _packs.length + 1, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _createStickerFromGallery() async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (picked != null) {
      widget.onStickerSelected(File(picked.path));
    }
  }

  Future<File> _assetToFile(String assetPath) async {
    final data = await rootBundle.load(assetPath);
    final bytes = data.buffer.asUint8List();
    final ext = assetPath.split('.').last;
    final tempDir = await getTemporaryDirectory();
    final file = File(
      '${tempDir.path}/sticker_${DateTime.now().millisecondsSinceEpoch}.$ext',
    );
    await file.writeAsBytes(bytes);
    return file;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280,
      decoration: BoxDecoration(
        color: widget.palette.surface,
        border: Border(
          top: BorderSide(color: widget.palette.border, width: 0.5),
        ),
      ),
      child: Column(
        children: [
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                ..._packs.map((pack) => _buildPackGrid(pack)),
                _buildCreateTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: widget.palette.border, width: 0.5),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        labelColor: AppPalette.accent,
        unselectedLabelColor: widget.palette.textMuted,
        indicatorColor: AppPalette.accent,
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: GoogleFonts.poppins(
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.poppins(
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
        tabs: [
          ..._packs.map((pack) => Tab(child: _buildTrayImage(pack.trayImage))),
          const Tab(icon: Icon(Icons.add_rounded, size: 20)),
        ],
      ),
    );
  }

  Widget _buildTrayImage(String assetPath) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: widget.palette.surface,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Image.asset(
          assetPath,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stack) => Container(
            decoration: BoxDecoration(
              color: AppPalette.accent.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              Icons.sticky_note_2,
              size: 16,
              color: AppPalette.accent,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPackGrid(StickerPack pack) {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 6,
        crossAxisSpacing: 6,
      ),
      itemCount: pack.stickers.length,
      itemBuilder: (context, index) {
        final sticker = pack.stickers[index];
        return _buildStickerItem(sticker);
      },
    );
  }

  Widget _buildStickerItem(StickerItem sticker) {
    return GestureDetector(
      onTap: () async {
        final file = await _assetToFile(sticker.assetPath);
        widget.onStickerSelected(file);
      },
      child: Container(
        decoration: BoxDecoration(
          color: widget.palette.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: widget.palette.border.withValues(alpha: 0.5),
            width: 0.5,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            sticker.assetPath,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stack) => Center(
              child: Icon(
                Icons.sticky_note_2,
                size: 32,
                color: widget.palette.textMuted,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCreateTab() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: _createStickerFromGallery,
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppPalette.accent.withValues(alpha: 0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppPalette.accent.withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.add_photo_alternate_outlined,
                size: 28,
                color: AppPalette.accent,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Crear sticker',
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: widget.palette.textMuted,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Desde tu galería',
            style: GoogleFonts.poppins(
              fontSize: 10,
              color: widget.palette.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
