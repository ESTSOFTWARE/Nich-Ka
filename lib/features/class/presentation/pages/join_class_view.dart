import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/presentation/app_theme_scope.dart';
import '../../../../core/presentation/change_notifier_provider.dart';
import '../../../../shared/theme/app_palette.dart';
import '../../../home/presentation/components/home_glow.dart';
import '../components/class_code_input.dart';
import '../components/join_class_divider.dart';
import '../components/qr_scanner_frame.dart';
import '../providers/join_class_provider.dart';
import '../states/ui_state.dart';
import '../../../../core/presentation/responsive_center.dart';
import '../../../../core/presentation/responsive.dart';

class JoinClassView extends StatelessWidget {
  const JoinClassView({super.key, this.initialCode});

  /// Código pre-cargado desde un deep link (`/join?code=...`).
  final String? initialCode;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<JoinClassProvider>(
      create: () => JoinClassProvider(initialCode: initialCode),
      builder: (context, provider) {
        final isDark = AppThemeScope.of(context).isDark;
        final palette = AppPalette.of(isDark);
        return Scaffold(
          backgroundColor: palette.background,
          extendBodyBehindAppBar: true,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(
              (kToolbarHeight) * (isTablet(context) ? kTabletHeaderScale : 1.0),
            ),
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: provider.isScrolled ? 20 : 0,
                  sigmaY: provider.isScrolled ? 20 : 0,
                ),
                child: MediaQuery(
                  data: MediaQuery.of(context).copyWith(
                    textScaler: TextScaler.linear(
                      isTablet(context) ? kTabletTextScale : 1,
                    ),
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
                    title: Text(
                      'Unirme a una clase',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: palette.textPrimary,
                      ),
                    ),
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
                  Expanded(
                    child: ResponsiveCenter(
                      child: SingleChildScrollView(
                        controller: provider.scrollController,
                        padding: EdgeInsets.fromLTRB(
                          16,
                          MediaQuery.of(context).padding.top +
                              kToolbarHeight +
                              8,
                          16,
                          16,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            QrScannerFrame(
                              palette: palette,
                              controller: provider.scannerController,
                              onDetected: provider.onQrDetected,
                            ),
                            const SizedBox(height: 20),
                            JoinClassDivider(
                              label: 'O PEGA EL ENLACE',
                              palette: palette,
                            ),
                            const SizedBox(height: 12),
                            TextField(
                              controller: provider.linkController,
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: palette.textPrimary,
                              ),
                              decoration: InputDecoration(
                                hintText: 'nich-ka.space/join?code=...',
                                hintStyle: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: palette.textMuted,
                                ),
                                prefixIcon: Icon(
                                  Icons.link,
                                  size: 18,
                                  color: palette.textMuted,
                                ),
                                filled: true,
                                fillColor: palette.surface,
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 13,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: palette.border),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: palette.border),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: AppPalette.accent,
                                    width: 1.5,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            JoinClassDivider(
                              label: 'O INGRESA EL CÓDIGO',
                              palette: palette,
                            ),
                            const SizedBox(height: 12),
                            ClassCodeInput(
                              controller: provider.codeController,
                              focusNode: provider.codeFocusNode,
                              code: provider.code,
                              palette: palette,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      16,
                      8,
                      16,
                      MediaQuery.of(context).padding.bottom + 16,
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: provider.joinState is UiLoading
                            ? null
                            : () async {
                                final ok = await provider.onSearch();
                                if (!context.mounted) return;
                                if (ok) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Te uniste a la clase.'),
                                    ),
                                  );
                                  // Cierra esta vista y abre directo la clase
                                  // a la que se unió.
                                  final joined = provider.joinedClass;
                                  if (joined != null) {
                                    context.pushReplacement(
                                      '/class-detail',
                                      extra: joined,
                                    );
                                  } else {
                                    context.pop(true);
                                  }
                                } else if (provider.joinState is UiError) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        (provider.joinState as UiError).message,
                                      ),
                                      backgroundColor: Colors.red.shade700,
                                    ),
                                  );
                                }
                              },
                        style: FilledButton.styleFrom(
                          backgroundColor: AppPalette.accent,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: provider.joinState is UiLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.black,
                                ),
                              )
                            : Text(
                                'Unirme a la clase',
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
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
