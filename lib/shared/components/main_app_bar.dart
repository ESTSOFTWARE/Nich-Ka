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

  /// Multiplicador de tamaño. La vista pasa el suyo (mayor en tablet) para que
  /// preferredSize —que no tiene contexto— coincida con lo que se renderiza.
  final double scale;

  const MainAppBar({
    super.key,
    required this.palette,
    this.isScrolled = false,
    this.onMenuTap,
    this.onNotificationTap,
    this.scale = 1,
  });

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight * scale);

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
          toolbarHeight: kToolbarHeight * scale,
          systemOverlayStyle: palette.isDark
              ? SystemUiOverlayStyle.light
              : SystemUiOverlayStyle.dark,
          centerTitle: false,
          titleSpacing: 0,
          leadingWidth: 48 * scale,
          leading: GestureDetector(
            onTap: onMenuTap,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: EdgeInsets.all(12 * scale),
              child: Icon(
                Icons.menu,
                color: palette.textPrimary,
                size: 22 * scale,
              ),
            ),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Nich-Ka',
                style: GoogleFonts.poppins(
                  fontSize: 15 * scale,
                  fontWeight: FontWeight.w600,
                  color: palette.textPrimary,
                  height: 1.1,
                ),
              ),
              Text(
                'ESTUDIANTE',
                style: GoogleFonts.poppins(
                  fontSize: 10 * scale,
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
              padding: EdgeInsets.only(right: 16 * scale),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  GestureDetector(
                    onTap: onNotificationTap,
                    behavior: HitTestBehavior.opaque,
                    child: Padding(
                      padding: EdgeInsets.all(12 * scale),
                      child: SvgPicture.asset(
                        'assets/icons/notify.svg',
                        width: 22 * scale,
                        height: 22 * scale,
                        colorFilter: ColorFilter.mode(
                          palette.textPrimary,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                  if (context.watch<NotificationsProvider>().unreadCount > 0)
                    Positioned(
                      top: 10 * scale,
                      right: 10 * scale,
                      child: Container(
                        width: 7 * scale,
                        height: 7 * scale,
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
