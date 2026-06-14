import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/presentation/app_theme_scope.dart';
import '../../../../core/presentation/change_notifier_provider.dart';
import '../../../../shared/theme/app_palette.dart';
import '../components/class_code_input.dart';
import '../components/qr_scanner_frame.dart';
import '../providers/join_class_provider.dart';
import '../../../home/presentation/components/home_glow.dart';

class JoinClassView extends StatelessWidget {
  const JoinClassView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<JoinClassProvider>(
      create: () => JoinClassProvider(),
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
          body: Stack(
            children: [
              HomeGlow(palette: palette),
              Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      controller: provider.scrollController,
                      padding: EdgeInsets.fromLTRB(
                        16,
                        MediaQuery.of(context).padding.top + kToolbarHeight + 8,
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
                          _Divider(label: 'O PEGA EL ENLACE', palette: palette),
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
                          _Divider(
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
                        onPressed: provider.onSearch,
                        style: FilledButton.styleFrom(
                          backgroundColor: AppPalette.accent,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Text(
                          'Buscar clase',
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

class _Divider extends StatelessWidget {
  final String label;
  final AppPalette palette;

  const _Divider({required this.label, required this.palette});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider(color: palette.border, thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: palette.textMuted,
              letterSpacing: 0.6,
            ),
          ),
        ),
        Expanded(child: Divider(color: palette.border, thickness: 1)),
      ],
    );
  }
}
