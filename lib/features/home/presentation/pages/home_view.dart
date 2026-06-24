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
import '../components/active_fermentation_card.dart';
import '../components/ai_recommendation_card.dart';
import '../components/fermentation_list_item.dart';
import '../components/home_glow.dart';
import '../providers/home_provider.dart';
import '../../../../shared/theme/app_palette.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeProvider>(
      create: () => HomeProvider(),
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
                        const SizedBox(height: 8),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: firstName.isEmpty
                                    ? 'Hola, '
                                    : 'Hola $firstName, ',
                                style: GoogleFonts.poppins(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w400,
                                  color: palette.textPrimary,
                                  height: 1.2,
                                ),
                              ),
                              TextSpan(
                                text: provider.greeting,
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
                        ActiveFermentationCard(
                          fermentation: provider.activeFermentation,
                          palette: palette,
                          elapsedFormatted: provider.elapsedFormatted,
                          objectiveFormatted: provider.objectiveFormatted,
                        ),
                        const SizedBox(height: 16),
                        AiRecommendationCard(
                          recommendation: provider.recommendation,
                          palette: palette,
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Tus fermentaciones',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: palette.textPrimary,
                              ),
                            ),
                            TextButton(
                              onPressed: () => context.push('/fermentations'),
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text(
                                'Ver todo →',
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: palette.textSecondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ...provider.fermentations.map(
                          (item) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: FermentationListItem(
                              item: item,
                              palette: palette,
                            ),
                          ),
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
