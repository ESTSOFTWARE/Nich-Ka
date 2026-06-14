import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/presentation/app_theme_scope.dart';
import '../../../../core/presentation/change_notifier_provider.dart';
import '../../../home/presentation/components/fermentation_list_item.dart';
import '../../../../shared/theme/app_palette.dart';
import '../components/fermentation_filter_bar.dart';
import '../components/fermentation_search_bar.dart';
import '../providers/fermentation_list_provider.dart';
import '../../../home/presentation/components/home_glow.dart';

class FermentationListView extends StatelessWidget {
  const FermentationListView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<FermentationListProvider>(
      create: () => FermentationListProvider(),
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
                        'Lotes',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: palette.textPrimary,
                        ),
                      ),
                      Text(
                        '${provider.total} fermentaciones registradas',
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
          body: Stack(
            children: [
              HomeGlow(palette: palette),
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      16,
                      MediaQuery.of(context).padding.top + kToolbarHeight + 8,
                      16,
                      0,
                    ),
                    child: Column(
                      children: [
                        FermentationSearchBar(
                          palette: palette,
                          controller: provider.searchController,
                        ),
                        const SizedBox(height: 12),
                        FermentationFilterBar(
                          selected: provider.filter,
                          palette: palette,
                          onSelected: provider.setFilter,
                        ),
                        const SizedBox(height: 4),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.separated(
                      controller: provider.scrollController,
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                      itemCount: provider.items.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final item = provider.items[index];
                        return FermentationListItem(
                          item: item,
                          palette: palette,
                          onTap: () => context.push('/fermentation'),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
