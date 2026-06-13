import 'package:flutter/material.dart';

class AppThemeProvider extends ChangeNotifier {
  bool _isDark;

  AppThemeProvider()
    : _isDark =
          WidgetsBinding.instance.platformDispatcher.platformBrightness ==
          Brightness.dark;

  bool get isDark => _isDark;

  void setDark(bool value) {
    if (_isDark == value) return;
    _isDark = value;
    notifyListeners();
  }
}
