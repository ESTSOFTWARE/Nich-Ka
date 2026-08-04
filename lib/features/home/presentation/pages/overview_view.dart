import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/presentation/app_theme_scope.dart';
import '../../../../shared/components/app_drawer.dart';
import '../../../../shared/components/app_drawer_item.dart';
import '../../../../shared/components/app_tab.dart';
import '../../../../shared/components/bottom_nav_bar.dart';
import '../../../../shared/components/main_app_bar.dart';
import '../../../../shared/utils/drawer_navigation.dart';
import '../../../../shared/utils/bottom_nav_navigation.dart';
import '../../../../features/profile/presentation/notifiers/drawer_notifier.dart';
import '../components/fermentation_curve_card.dart';
import '../components/fermentation_progress_list.dart';
import '../components/home_glow.dart';
import '../components/stats_overview_grid.dart';
import '../notifiers/overview_notifier.dart';
import '../../../../shared/theme/app_palette.dart';
import '../../../../core/presentation/responsive_center.dart';
import '../../../../core/presentation/responsive.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OverviewView extends ConsumerWidget {
  const OverviewView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(overviewProvider);
    final notifier = ref.read(overviewProvider.notifier);
    // Sin fermentación activa esta vista no aplica → al home normal.
    if (!state.isLoading && !state.hasActive) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) context.go('/');
      });
      return const Scaffold(
        backgroundColor: Color(0xFF0A0A0B),
        body: Center(child: CircularProgressIndicator()),
      );
    }
    final drawer = ref.watch(drawerProvider);
    final firstName = (drawer.user?.fullName ?? '').trim().split(' ').first;
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
                24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: firstName.isEmpty
                              ? 'Hola, '
                              : 'Hola $firstName, ',
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.w400,
                            color: palette.textPrimary,
                            height: 1.2,
                          ),
                        ),
                        TextSpan(
                          text: state.greeting,
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: palette.textPrimary,
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  StatsOverviewGrid(stats: state.stats, palette: palette),
                  const SizedBox(height: 14),
                  FermentationCurveCard(
                    points: state.chartPoints,
                    selectedRange: state.selectedRange,
                    palette: palette,
                    onRangeSelected: notifier.selectRange,
                  ),
                  const SizedBox(height: 20),
                  FermentationProgressList(
                    cards: state.fermentationCards,
                    palette: palette,
                    total: state.fermentationCards.length,
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
