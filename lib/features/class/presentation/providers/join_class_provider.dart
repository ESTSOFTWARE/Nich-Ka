import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../data/repositories/class_repository_impl.dart';
import '../../domain/use_cases/join_class_use_case.dart';
import '../states/ui_state.dart';

class JoinClassProvider extends ChangeNotifier {
  final JoinClassUseCase _joinClass;

  final TextEditingController codeController = TextEditingController();
  final TextEditingController linkController = TextEditingController();
  final FocusNode codeFocusNode = FocusNode();
  final MobileScannerController scannerController = MobileScannerController();
  final ScrollController scrollController = ScrollController();

  bool _isScrolled = false;
  bool get isScrolled => _isScrolled;

  UiState<void> _joinState = const UiIdle();
  UiState<void> get joinState => _joinState;

  JoinClassProvider({JoinClassUseCase? joinClass, String? initialCode})
    : _joinClass = joinClass ?? JoinClassUseCase(ClassRepositoryImpl()) {
    if (initialCode != null && initialCode.trim().isNotEmpty) {
      codeController.text = initialCode.trim().toUpperCase();
    }
    codeController.addListener(notifyListeners);
    scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final scrolled = scrollController.offset > 4;
    if (scrolled != _isScrolled) {
      _isScrolled = scrolled;
      notifyListeners();
    }
  }

  String get code => codeController.text.toUpperCase();

  void onQrDetected(String value) {
    final uri = Uri.tryParse(value);
    final qrCode = uri?.queryParameters['code'] ?? value;
    if (qrCode.isNotEmpty) {
      codeController.text = qrCode.toUpperCase();
      if (!kIsWeb) scannerController.stop();
    }
  }

  void _setState(UiState<void> state) {
    _joinState = state;
    notifyListeners();
  }

  /// Une al alumno a la clase con el código actual (escaneado o tecleado).
  /// Devuelve true si se unió correctamente.
  Future<bool> onSearch() async {
    final value = code.trim();
    if (value.isEmpty) {
      _setState(const UiError('Ingresa o escanea un código de clase.'));
      return false;
    }

    _setState(const UiLoading());
    try {
      await _joinClass(value);
      _setState(const UiSuccess(null));
      return true;
    } catch (e) {
      _setState(UiError(e.toString().replaceFirst('Exception: ', '')));
      return false;
    }
  }

  @override
  void dispose() {
    codeController.removeListener(notifyListeners);
    scrollController.removeListener(_onScroll);
    codeController.dispose();
    linkController.dispose();
    codeFocusNode.dispose();
    scannerController.dispose();
    scrollController.dispose();
    super.dispose();
  }
}
