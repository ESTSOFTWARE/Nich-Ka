import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/presentation/app_theme_scope.dart';
import '../../../../core/presentation/change_notifier_provider.dart';
import '../../../../shared/theme/app_palette.dart';
import '../../../home/presentation/components/home_glow.dart';
import '../components/sensor_card.dart';
import '../components/sensors_status_card.dart';
import '../providers/sensors_provider.dart';

class SensorsView extends StatelessWidget {
  const SensorsView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SensorsProvider>(
      create: () => SensorsProvider(),
      builder: (context, provider) {
        final isDark = AppThemeScope.of(context).isDark;
        final palette = AppPalette.of(isDark);
        return Scaffold(
          backgroundColor: palette.background,
          extendBodyBehindAppBar: true,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight + 20),
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
                  toolbarHeight: kToolbarHeight + 20,
                  leading: Center(
                    child: GestureDetector(
                      onTap: () =>
                          context.canPop() ? context.pop() : context.go('/'),
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
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Sensores en vivo',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: palette.textPrimary,
                        ),
                      ),
                      Text(
                        '${provider.status.fermentationId} · ${provider.status.variety} · Tanque 02',
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: palette.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    Container(
                      margin: const EdgeInsets.only(right: 16),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppPalette.accent.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppPalette.accent.withValues(alpha: 0.4),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: AppPalette.accent,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            'EN VIVO',
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: AppPalette.accent,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
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
              SingleChildScrollView(
                controller: provider.scrollController,
                padding: EdgeInsets.fromLTRB(
                  16,
                  MediaQuery.of(context).padding.top + kToolbarHeight + 28,
                  16,
                  MediaQuery.of(context).padding.bottom + 24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SensorsStatusCard(
                      status: provider.status,
                      palette: palette,
                    ),
                    const SizedBox(height: 16),
                    GridView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 0.88,
                          ),
                      itemCount: provider.readings.length,
                      itemBuilder: (context, index) => SensorCard(
                        reading: provider.readings[index],
                        palette: palette,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
