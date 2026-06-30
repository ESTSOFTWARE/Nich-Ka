import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/presentation/app_theme_scope.dart';
import '../../../../core/presentation/change_notifier_provider.dart';
import '../../../../shared/theme/app_palette.dart';
import '../components/notification_list_item.dart';
import '../providers/notifications_provider.dart';
import '../../../home/presentation/components/home_glow.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<NotificationsProvider>(
      create: () => NotificationsProvider(),
      builder: (context, provider) {
        final isDark = AppThemeScope.of(context).isDark;
        final palette = AppPalette.of(isDark);
        return Scaffold(
          backgroundColor: palette.background,
          extendBodyBehindAppBar: true,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: provider.isScrolled ? 20 : 0,
                  sigmaY: provider.isScrolled ? 20 : 0,
                ),
                child: AppBar(
                  backgroundColor: provider.isScrolled
                      ? palette.glassBackground
                      : Colors.transparent,
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
                      onTap: () => context.canPop()
                          ? context.pop()
                          : context.go('/home'),
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
                    children: [
                      Text(
                        'Notificaciones',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: palette.textPrimary,
                        ),
                      ),
                      if (provider.unreadCount > 0)
                        Text(
                          '${provider.unreadCount} sin leer',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: palette.textSecondary,
                          ),
                        ),
                    ],
                  ),
                  actions: [
                    if (provider.unreadCount > 0)
                      Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: GestureDetector(
                          onTap: provider.markAllRead,
                          child: Text(
                            'Marcar todo',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: AppPalette.accent,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          body: Stack(
            children: [
              HomeGlow(palette: palette),
              provider.items.isEmpty
                  ? _buildEmpty(context, palette)
                  : ListView.builder(
                      controller: provider.scrollController,
                      padding: EdgeInsets.fromLTRB(
                        0,
                        MediaQuery.of(context).padding.top + kToolbarHeight + 8,
                        0,
                        8,
                      ),
                      itemCount: provider.items.length,
                      itemBuilder: (context, index) => NotificationListItem(
                        item: provider.items[index],
                        palette: palette,
                      ),
                    ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmpty(BuildContext context, AppPalette palette) {
    final topPad = MediaQuery.of(context).padding.top + kToolbarHeight;
    return Padding(
      padding: EdgeInsets.fromLTRB(32, topPad + 40, 32, 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none_outlined,
            size: 72,
            color: palette.textMuted,
          ),
          const SizedBox(height: 24),
          Text(
            'Sin notificaciones',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: palette.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Cuando tengas actividad nueva aparecerá aquí. Por ahora todo está al día.',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: palette.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
