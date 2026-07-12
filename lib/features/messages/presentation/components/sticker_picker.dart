import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../shared/theme/app_palette.dart';
import '../../domain/entities/sticker_pack.dart';
import '../../data/sticker_packs.dart';

part 'sticker_picker_state.dart';

class StickerPicker extends StatefulWidget {
  final AppPalette palette;
  final void Function(File stickerFile) onStickerSelected;
  final VoidCallback? onCreateFromGallery;

  const StickerPicker({
    super.key,
    required this.palette,
    required this.onStickerSelected,
    this.onCreateFromGallery,
  });

  @override
  State<StickerPicker> createState() => _StickerPickerState();
}
