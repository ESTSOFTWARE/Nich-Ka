import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/presentation/app_theme_scope.dart';
import '../../../../core/presentation/change_notifier_provider.dart';
import '../../../../shared/components/app_drawer.dart';
import '../../../../shared/components/app_drawer_item.dart';
import '../../../../shared/components/app_tab.dart';
import '../../../../shared/components/bottom_nav_bar.dart';
import '../../../../shared/components/main_app_bar.dart';
import '../../../../shared/utils/drawer_navigation.dart';
import '../../../../shared/utils/bottom_nav_navigation.dart';
import '../../../../features/profile/presentation/providers/drawer_provider.dart';
import '../components/fermentation_curve_card.dart';
import '../components/fermentation_progress_list.dart';
import '../components/home_glow.dart';
import '../components/stats_overview_grid.dart';
import '../providers/overview_provider.dart';
import '../../../../shared/theme/app_palette.dart';

class OverviewView extends StatelessWidget {
  const OverviewView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<OverviewProvider>(
      create: () => OverviewProvider(),
      builder: (context, provider) {
        // Sin fermentación activa esta vista no aplica → al home normal.
        if (!provider.isLoading && !provider.hasActive) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) context.go('/');
          });
          return const Scaffold(
            backgroundColor: Color(0xFF0A0A0B),
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final isDark = AppThemeScope.of(context).isDark;
        final palette = AppPalette.of(isDark);
        return ChangeNotifierProvider<DrawerProvider>(
          create: () => DrawerProvider(),
          builder: (context, drawerProvider) {
            final firstName =
                (drawerProvider.user?.fullName ?? '').trim().split(' ').first;
            return Scaffold(
              key: provider.scaffoldKey,
              backgroundColor: palette.background,
              extendBodyBehindAppBar: true,
              drawer: AppDrawer(
                palette: palette,
                selected: AppDrawerItem.inicio,
                onSelected: (item) => onDrawerNav(context, item),
                onSettings: () => context.push('/profile'),
                userName: drawerProvider.user?.fullName,
                userRole: drawerProvider.user?.role.toUpperCase(),
                profileImage: drawerProvider.user?.profileImage,
                onLogout: () async {
                  await drawerProvider.logout();
                  if (context.mounted) context.go('/login');
                },
              ),
              appBar: MainAppBar(
                palette: palette,
                isScrolled: provider.isScrolled,
                onMenuTap: () =>
                    provider.scaffoldKey.currentState?.openDrawer(),
                onNotificationTap: () => context.push('/notifications'),
              ),
              body: Stack(
                children: [
                  HomeGlow(palette: palette),
                  SingleChildScrollView(
                    controller: provider.scrollController,
                    padding: EdgeInsets.fromLTRB(
                      16,
                      MediaQuery.of(context).padding.top + kToolbarHeight + 8,
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
                                text: provider.greeting,
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
                        StatsOverviewGrid(
                          stats: provider.stats,
                          palette: palette,
                        ),
                        const SizedBox(height: 14),
                        FermentationCurveCard(
                          points: provider.chartPoints,
                          selectedRange: provider.selectedRange,
                          palette: palette,
                          onRangeSelected: provider.selectRange,
                        ),
                        const SizedBox(height: 20),
                        FermentationProgressList(
                          cards: provider.fermentationCards,
                          palette: palette,
                          total: provider.fermentationCards.length,
                        ),
                      ],
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
          },
        );
      },
    );
  }
}
