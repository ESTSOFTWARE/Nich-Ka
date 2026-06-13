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
import '../components/active_fermentation_card.dart';
import '../components/ai_recommendation_card.dart';
import '../components/fermentation_list_item.dart';
import '../components/home_glow.dart';
import '../providers/home_provider.dart';
import '../theme/home_palette.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeProvider>(
      create: () => HomeProvider(),
      builder: (context, provider) {
        final isDark = AppThemeScope.of(context).isDark;
        final palette = HomePalette.of(isDark);
        return Scaffold(
          key: provider.scaffoldKey,
          backgroundColor: palette.background,
          extendBodyBehindAppBar: true,
          drawer: AppDrawer(
            palette: palette,
            selected: AppDrawerItem.inicio,
            onSelected: (_) {},
            onSettings: () => context.push('/profile'),
          ),
          appBar: MainAppBar(
            palette: palette,
            isScrolled: provider.isScrolled,
            onMenuTap: () => provider.scaffoldKey.currentState?.openDrawer(),
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
                            text: 'Hola Ameth, ',
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
                          onPressed: () {},
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
            onTabSelected: (_) {},
          ),
        );
      },
    );
  }
}
