import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/presentation/app_theme_scope.dart';
import '../../../../shared/components/app_drawer.dart';
import '../../../../shared/components/app_drawer_item.dart';
import '../../../../shared/components/app_tab.dart';
import '../../../../shared/components/bottom_nav_bar.dart';
import '../../../../shared/components/main_app_bar.dart';
import '../../../../shared/theme/app_palette.dart';
import '../../../../shared/utils/bottom_nav_navigation.dart';
import '../../../../shared/utils/drawer_navigation.dart';
import '../../../../features/profile/presentation/notifiers/drawer_notifier.dart';
import '../components/home_empty_card.dart';
import '../components/home_feature_item.dart';
import '../components/home_glow.dart';
import '../notifiers/home_student_notifier.dart';
import '../../../../core/presentation/responsive_center.dart';
import '../../../../core/presentation/responsive.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeStudentView extends ConsumerWidget {
  const HomeStudentView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeStudentProvider);
    final notifier = ref.read(homeStudentProvider.notifier);
    final drawer = ref.watch(drawerProvider);
    final isDark = AppThemeScope.of(context).isDark;
    final palette = AppPalette.of(isDark);
    return Scaffold(
      key: notifier.scaffoldKey,
      backgroundColor: palette.background,
      extendBodyBehindAppBar: true,
      drawer: AppDrawer(
        palette: palette,
        selected: AppDrawerItem.inicio,
        onSelected: (item) => onDrawerNav(context, item),
        onSettings: () => context.push('/profile'),
        userName: drawer.user?.fullName,
        userRole: drawer.user?.role.toUpperCase(),
        profileImage: drawer.user?.profileImage,
        onLogout: () async {
          await ref.read(drawerProvider.notifier).logout();
          if (context.mounted) context.go('/login');
        },
      ),
      appBar: MainAppBar(
        palette: palette,
        scale: isTablet(context) ? kTabletHeaderScale : 1.0,
        isScrolled: state.isScrolled,
        onMenuTap: () => notifier.scaffoldKey.currentState?.openDrawer(),
        onNotificationTap: () => context.push('/notifications'),
      ),
      body: Stack(
        children: [
          HomeGlow(palette: palette),
          ResponsiveCenter(
            child: SingleChildScrollView(
              controller: notifier.scrollController,
              padding: EdgeInsets.fromLTRB(
                16,
                MediaQuery.of(context).padding.top + appBarHeight(context) + 8,
                16,
                32,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Hola ${drawer.user?.firstName ?? ''}, ',
                          style: GoogleFonts.poppins(
                            fontSize: 26,
                            fontWeight: FontWeight.w400,
                            color: palette.textPrimary,
                            height: 1.2,
                          ),
                        ),
                        TextSpan(
                          text: state.greeting,
                          style: GoogleFonts.poppins(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: palette.textPrimary,
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  HomeEmptyCard(
                    palette: palette,
                    onJoinClass: () => context.push('/class'),
                  ),
                  const SizedBox(height: 28),
                  Text(
                    'QUÉ PODRÁS HACER',
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: palette.textMuted,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 4),
                  ...HomeStudentNotifier.features.asMap().entries.map(
                    (e) => HomeFeatureItem(
                      feature: e.value,
                      palette: palette,
                      onTap: switch (e.key) {
                        0 => () => context.push('/sensors'),
                        1 => () => context.push('/fermentations'),
                        2 => () => context.push('/assistant'),
                        3 => () => context.push('/reports'),
                        _ => null,
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        selected: AppTab.inicio,
        palette: palette,
        onTabSelected: (tab) => onBottomNavSelected(context, tab),
      ),
    );
  }
}
