import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/presentation/app_theme_scope.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../home/presentation/components/fermentation_list_item.dart';
import '../../../../shared/theme/app_palette.dart';
import '../components/fermentation_filter_bar.dart';
import '../components/fermentation_search_bar.dart';
import '../notifiers/fermentation_list_notifier.dart';
import '../../../home/presentation/components/home_glow.dart';
import '../../../../core/presentation/responsive_center.dart';
import '../../../../core/presentation/responsive.dart';

class FermentationListView extends ConsumerWidget {
  const FermentationListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(fermentationListProvider);
    final notifier = ref.read(fermentationListProvider.notifier);
    final isDark = AppThemeScope.of(context).isDark;
    final palette = AppPalette.of(isDark);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        if (context.canPop()) {
          context.pop();
        } else {
          context.go('/home');
        }
      },
      child: Scaffold(
        backgroundColor: palette.background,
        extendBodyBehindAppBar: true,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(
            (kToolbarHeight) * (isTablet(context) ? kTabletHeaderScale : 1.0),
          ),
          child: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: state.isScrolled ? 20 : 0,
                sigmaY: state.isScrolled ? 20 : 0,
              ),
              child: MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaler: TextScaler.linear(
                    isTablet(context) ? kTabletTextScale : 1,
                  ),
                ),
                child: AppBar(
                  backgroundColor: state.isScrolled
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
                        'Lotes',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: palette.textPrimary,
                        ),
                      ),
                      Text(
                        '${state.total} fermentaciones registradas',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: palette.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  actions: const [],
                ),
              ),
            ),
          ),
        ),
        body: Stack(
          children: [
            HomeGlow(palette: palette),
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    16,
                    MediaQuery.of(context).padding.top +
                        (kToolbarHeight + 8) *
                            (isTablet(context) ? kTabletHeaderScale : 1.0),
                    16,
                    0,
                  ),
                  child: Column(
                    children: [
                      FermentationSearchBar(
                        palette: palette,
                        controller: notifier.searchController,
                      ),
                      const SizedBox(height: 12),
                      FermentationFilterBar(
                        selected: state.filter,
                        palette: palette,
                        onSelected: notifier.setFilter,
                      ),
                      const SizedBox(height: 4),
                    ],
                  ),
                ),
                Expanded(
                  child: ResponsiveCenter(
                    child: ListView.separated(
                      controller: notifier.scrollController,
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                      itemCount: state.items.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final item = state.items[index];
                        return FermentationListItem(
                          item: item,
                          palette: palette,
                          onTap: () => context.push(
                            '/report-detail',
                            extra: item.sessionId,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ), // Scaffold
    ); // PopScope
  }
}
