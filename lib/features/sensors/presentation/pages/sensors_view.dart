import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/presentation/app_theme_scope.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/presentation/responsive.dart';
import '../../../../shared/theme/app_palette.dart';
import '../../../home/presentation/components/home_glow.dart';
import '../components/sensor_card.dart';
import '../components/sensors_status_card.dart';
import '../notifiers/sensors_notifier.dart';
import '../../../../core/presentation/tablet_text_scale.dart';

class SensorsView extends ConsumerWidget {
  const SensorsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(sensorsProvider);
    final notifier = ref.read(sensorsProvider.notifier);
    final isDark = AppThemeScope.of(context).isDark;
    final palette = AppPalette.of(isDark);
    final tablet = isTablet(context);
    final barScale = tablet ? kTabletHeaderScale : 1.0;
    return Scaffold(
      backgroundColor: palette.background,
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight((kToolbarHeight + 20) * barScale),
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: state.isScrolled ? 20 : 0,
              sigmaY: state.isScrolled ? 20 : 0,
            ),
            child: MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: TextScaler.linear(tablet ? kTabletTextScale : 1),
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
                leadingWidth: 56 * barScale,
                toolbarHeight: (kToolbarHeight + 20) * barScale,
                leading: Center(
                  child: GestureDetector(
                    onTap: () =>
                        context.canPop() ? context.pop() : context.go('/'),
                    child: Container(
                      width: 36 * barScale,
                      height: 36 * barScale,
                      margin: EdgeInsets.only(left: 16 * barScale),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: palette.border),
                      ),
                      child: Icon(
                        Icons.chevron_left,
                        color: palette.textPrimary,
                        size: 22 * barScale,
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
                      '${state.status.fermentationId} · ${state.status.variety} · Tanque 02',
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
      ),
      body: TabletTextScale(
        child: Stack(
          children: [
            HomeGlow(palette: palette),
            SingleChildScrollView(
              controller: notifier.scrollController,
              padding: EdgeInsets.fromLTRB(
                16,
                MediaQuery.of(context).padding.top +
                    (kToolbarHeight + 28) * barScale,
                16,
                MediaQuery.of(context).padding.bottom + 24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SensorsStatusCard(status: state.status, palette: palette),
                  const SizedBox(height: 16),
                  GridView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    // Tablet: altura fija ajustada al contenido (incluye la
                    // descripción); 3 columnas en horizontal para que las
                    // cards no queden tan anchas. Teléfono: proporción alta.
                    gridDelegate: isTablet(context)
                        ? SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: isLandscape(context) ? 3 : 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            mainAxisExtent: 250,
                          )
                        : const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 0.88,
                          ),
                    itemCount: state.readings.length,
                    itemBuilder: (context, index) => SensorCard(
                      reading: state.readings[index],
                      palette: palette,
                      onTap: () => context.push(
                        '/sensor-detail',
                        extra: state.readings[index],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
