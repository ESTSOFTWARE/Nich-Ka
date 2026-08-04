import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../data/repositories/class_repository_impl.dart';
import '../../domain/use_cases/join_class_use_case.dart';
import '../states/ui_state.dart';
import 'join_class_state.dart';

/// Family sobre el código inicial (deep link /join?code=...).
class JoinClassNotifier extends FamilyNotifier<JoinClassState, String?> {
  final TextEditingController codeController = TextEditingController();
  final TextEditingController linkController = TextEditingController();
  final FocusNode codeFocusNode = FocusNode();
  final MobileScannerController scannerController = MobileScannerController();
  final ScrollController scrollController = ScrollController();

  late final JoinClassUseCase _joinClass;

  @override
  JoinClassState build(String? initialCode) {
    _joinClass = JoinClassUseCase(ClassRepositoryImpl());
    if (initialCode != null && initialCode.trim().isNotEmpty) {
      codeController.text = initialCode.trim().toUpperCase();
    }
    codeController.addListener(_onCodeChanged);
    scrollController.addListener(_onScroll);
    ref.onDispose(() {
      codeController.removeListener(_onCodeChanged);
      scrollController.removeListener(_onScroll);
      codeController.dispose();
      linkController.dispose();
      codeFocusNode.dispose();
      scannerController.dispose();
      scrollController.dispose();
    });
    return JoinClassState(code: codeController.text.toUpperCase());
  }

  void _onCodeChanged() =>
      state = state.copyWith(code: codeController.text.toUpperCase());

  void _onScroll() {
    final scrolled = scrollController.offset > 4;
    if (scrolled != state.isScrolled) {
      state = state.copyWith(isScrolled: scrolled);
    }
  }

  void onQrDetected(String value) {
    final uri = Uri.tryParse(value);
    final qrCode = uri?.queryParameters['code'] ?? value;
    if (qrCode.isNotEmpty) {
      codeController.text = qrCode.toUpperCase();
      if (!kIsWeb) scannerController.stop();
    }
  }

  /// Une al alumno a la clase con el código actual. true si se unió.
  Future<bool> onSearch() async {
    final value = state.code.trim();
    if (value.isEmpty) {
      state = state.copyWith(
        joinState: const UiError('Ingresa o escanea un código de clase.'),
      );
      return false;
    }
    state = state.copyWith(joinState: const UiLoading());
    try {
      final joined = await _joinClass(value);
      state = state.copyWith(
        joinState: const UiSuccess(null),
        joinedClass: joined,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        joinState: UiError(e.toString().replaceFirst('Exception: ', '')),
      );
      return false;
    }
  }
}

final joinClassProvider =
    NotifierProvider.family<JoinClassNotifier, JoinClassState, String?>(
      JoinClassNotifier.new,
    );
