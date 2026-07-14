import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../../core/presentation/app_theme_scope.dart';
import '../../../../shared/theme/app_palette.dart';
import '../../../home/presentation/components/home_glow.dart';
import '../components/class_code_input.dart';
import '../components/join_class_divider.dart';
import '../components/qr_scanner_frame.dart';
import '../notifiers/join_class_notifier.dart';
import '../states/ui_state.dart';

class JoinClassView extends ConsumerStatefulWidget {
  const JoinClassView({super.key, this.initialCode});

  final String? initialCode;

  @override
  ConsumerState<JoinClassView> createState() => _JoinClassViewState();
}

class _JoinClassViewState extends ConsumerState<JoinClassView> {
  final _codeController = TextEditingController();
  final _linkController = TextEditingController();
  final _codeFocusNode = FocusNode();
  final _scannerController = MobileScannerController();
  final _scrollController = ScrollController();
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialCode != null && widget.initialCode!.trim().isNotEmpty) {
      _codeController.text = widget.initialCode!.trim().toUpperCase();
    }
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final scrolled = _scrollController.offset > 4;
    if (scrolled != _isScrolled) {
      setState(() => _isScrolled = scrolled);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _codeController.dispose();
    _linkController.dispose();
    _codeFocusNode.dispose();
    _scannerController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  String get _code => _codeController.text.toUpperCase();

  void _onQrDetected(String value) {
    final uri = Uri.tryParse(value);
    final qrCode = uri?.queryParameters['code'] ?? value;
    if (qrCode.isNotEmpty) {
      _codeController.text = qrCode.toUpperCase();
      if (!kIsWeb) _scannerController.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final joinState = ref.watch(joinClassProvider).joinState;
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
              sigmaX: _isScrolled ? 20 : 0,
              sigmaY: _isScrolled ? 20 : 0,
            ),
            child: AppBar(
              backgroundColor: _isScrolled
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
                  controller: _scrollController,
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
                        controller: _scannerController,
                        onDetected: _onQrDetected,
                      ),
                      const SizedBox(height: 20),
                      JoinClassDivider(
                        label: 'O PEGA EL ENLACE',
                        palette: palette,
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _linkController,
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
                        controller: _codeController,
                        focusNode: _codeFocusNode,
                        code: _code,
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
                    onPressed: joinState is UiLoading
                        ? null
                        : () async {
                            final ok = await ref
                                .read(joinClassProvider.notifier)
                                .onSearch(_code);
                            if (!context.mounted) return;
                            if (ok) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Te uniste a la clase.'),
                                ),
                              );
                              context.pop(true);
                            } else if (joinState is UiError) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(joinState.message),
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
                    child: joinState is UiLoading
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
  }
}
