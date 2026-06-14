import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class JoinClassProvider extends ChangeNotifier {
  final TextEditingController codeController = TextEditingController();
  final TextEditingController linkController = TextEditingController();
  final FocusNode codeFocusNode = FocusNode();
  final MobileScannerController scannerController = MobileScannerController();
  final ScrollController scrollController = ScrollController();

  bool _isScrolled = false;
  bool get isScrolled => _isScrolled;

  JoinClassProvider() {
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

  void onSearch() {}

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
