import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/presentation/app_theme_scope.dart';
import '../../../../core/presentation/responsive.dart';
import '../../../../shared/components/app_drawer.dart';
import '../../../../shared/components/app_drawer_item.dart';
import '../../../../shared/components/app_tab.dart';
import '../../../../shared/components/bottom_nav_bar.dart';
import '../../../../shared/components/main_app_bar.dart';
import '../../../../shared/utils/drawer_navigation.dart';
import '../../../../shared/utils/bottom_nav_navigation.dart';
import '../../../../features/profile/presentation/notifiers/drawer_notifier.dart';
import '../components/active_fermentation_card.dart';
import '../components/ai_recommendation_card.dart';
import '../components/fermentation_list_item.dart';
import '../components/home_glow.dart';
import '../notifiers/home_notifier.dart';
import '../../../../shared/theme/app_palette.dart';
import '../../../../core/presentation/tablet_text_scale.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'home_view_predict_button.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  Widget _greeting(
    HomeProvider provider,
    AppPalette palette,
    String firstName,
  ) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: firstName.isEmpty ? 'Hola, ' : 'Hola $firstName, ',
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
    );
  }

  /// Card de fermentación activa + botón de predicción + card IA.
  Widget _activeColumn(
    BuildContext context,
    HomeProvider provider,
    AppPalette palette,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ActiveFermentationCard(
          fermentation: provider.activeFermentation,
          palette: palette,
          elapsedFormatted: provider.elapsedFormatted,
          objectiveFormatted: provider.objectiveFormatted,
        ),
        const SizedBox(height: 10),
        _PredictButton(
          isLoading: provider.isPredicting,
          onTap: provider.requestPrediction,
        ),
        const SizedBox(height: 10),
        AiRecommendationCard(
          recommendation: provider.recommendation,
          palette: palette,
        ),
      ],
    );
  }

  /// Encabezado "Tus fermentaciones" + lista.
  Widget _fermentationsColumn(
    BuildContext context,
    HomeProvider provider,
    AppPalette palette,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
              onTap: item.sessionId != null
                  ? () => context.push('/report-detail', extra: item.sessionId)
                  : null,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(homeProvider);
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
    final drawer = ref.watch(drawerProvider);
    final firstName = (drawer.user?.fullName ?? '').trim().split(' ').first;
    final isDark = AppThemeScope.of(context).isDark;
    final palette = AppPalette.of(isDark);
    return Scaffold(
      key: provider.scaffoldKey,
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
        isScrolled: provider.isScrolled,
        onMenuTap: () => provider.scaffoldKey.currentState?.openDrawer(),
        onNotificationTap: () => context.push('/notifications'),
      ),
      body: TabletTextScale(
        child: Stack(
          children: [
            HomeGlow(palette: palette),
            SingleChildScrollView(
              controller: provider.scrollController,
              padding: EdgeInsets.fromLTRB(
                isTablet(context) ? 24 : 16,
                MediaQuery.of(context).padding.top + appBarHeight(context) + 8,
                isTablet(context) ? 24 : 16,
                24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  _greeting(provider, palette, firstName),
                  const SizedBox(height: 20),
                  if (isTablet(context) && isLandscape(context))
                    // Tablet horizontal: fermentación activa a la
                    // izquierda, lista a la derecha. En vertical se
                    // apila igual que en el teléfono.
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 5,
                          child: _activeColumn(context, provider, palette),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          flex: 4,
                          child: _fermentationsColumn(
                            context,
                            provider,
                            palette,
                          ),
                        ),
                      ],
                    )
                  else ...[
                    _activeColumn(context, provider, palette),
                    const SizedBox(height: 24),
                    _fermentationsColumn(context, provider, palette),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        selected: AppTab.inicio,
        palette: palette,
        onTabSelected: (tab) => onBottomNavSelected(context, tab),
      ),
    );
  }
}
