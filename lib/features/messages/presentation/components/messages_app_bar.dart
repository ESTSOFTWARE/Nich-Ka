import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/theme/app_palette.dart';

class MessagesAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String subtitle;
  final bool isScrolled;
  final bool isDark;
  final AppPalette palette;
  final VoidCallback onBack;

  const MessagesAppBar({
    super.key,
    required this.subtitle,
    required this.isScrolled,
    required this.isDark,
    required this.palette,
    required this.onBack,
  });

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: isScrolled ? 20 : 0,
          sigmaY: isScrolled ? 20 : 0,
        ),
        child: AppBar(
          backgroundColor:
              isScrolled ? palette.glassBackground : Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          systemOverlayStyle:
              isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
          automaticallyImplyLeading: false,
          centerTitle: false,
          toolbarHeight: 64,
          leadingWidth: 56,
          leading: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: GestureDetector(
              onTap: onBack,
              child: Container(
                width: 36,
                height: 36,
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
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Mensajes',
                style: GoogleFonts.poppins(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: palette.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: palette.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
