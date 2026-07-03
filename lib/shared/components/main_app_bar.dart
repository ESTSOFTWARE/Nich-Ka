import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../theme/app_palette.dart';
import '../../features/notifications/presentation/providers/notifications_provider.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  final AppPalette palette;
  final bool isScrolled;
  final VoidCallback? onMenuTap;
  final VoidCallback? onNotificationTap;

  const MainAppBar({
    super.key,
    required this.palette,
    this.isScrolled = false,
    this.onMenuTap,
    this.onNotificationTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: isScrolled ? 20 : 0,
          sigmaY: isScrolled ? 20 : 0,
        ),
        child: AppBar(
          backgroundColor: isScrolled
              ? palette.glassBackground
              : Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          systemOverlayStyle: palette.isDark
              ? SystemUiOverlayStyle.light
              : SystemUiOverlayStyle.dark,
          centerTitle: false,
          titleSpacing: 0,
          leadingWidth: 48,
          leading: GestureDetector(
            onTap: onMenuTap,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Icon(Icons.menu, color: palette.textPrimary, size: 22),
            ),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Nich-Ka',
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: palette.textPrimary,
                  height: 1.1,
                ),
              ),
              Text(
                'ESTUDIANTE',
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: AppPalette.accent,
                  letterSpacing: 0.8,
                  height: 1.2,
                ),
              ),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  GestureDetector(
                    onTap: onNotificationTap,
                    behavior: HitTestBehavior.opaque,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: SvgPicture.asset(
                        'assets/icons/notify.svg',
                        width: 22,
                        height: 22,
                        colorFilter: ColorFilter.mode(
                          palette.textPrimary,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                  if (context.watch<NotificationsProvider>().unreadCount > 0)
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        width: 7,
                        height: 7,
                        decoration: const BoxDecoration(
                          color: AppPalette.accent,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
