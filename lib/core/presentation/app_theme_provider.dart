import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme_choice.dart';

class AppThemeProvider extends ChangeNotifier with WidgetsBindingObserver {
  static const _prefsKey = 'theme_choice';

  ThemeChoice _choice = ThemeChoice.system;

  AppThemeProvider() {
    WidgetsBinding.instance.addObserver(this);
    _loadSaved();
  }

  ThemeChoice get choice => _choice;

  ThemeMode get themeMode => switch (_choice) {
    ThemeChoice.light => ThemeMode.light,
    ThemeChoice.dark => ThemeMode.dark,
    ThemeChoice.system => ThemeMode.system,
  };

  /// Resuelve si debe verse oscuro según la preferencia + el sistema.
  bool get isDark {
    switch (_choice) {
      case ThemeChoice.light:
        return false;
      case ThemeChoice.dark:
        return true;
      case ThemeChoice.system:
        return WidgetsBinding.instance.platformDispatcher.platformBrightness ==
            Brightness.dark;
    }
  }

  /// Si el usuario cambia el tema del sistema y la preferencia es "sistema",
  /// refrescamos en vivo.
  @override
  void didChangePlatformBrightness() {
    if (_choice == ThemeChoice.system) notifyListeners();
  }

  Future<void> _loadSaved() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_prefsKey);
    if (saved != null) {
      _choice = ThemeChoice.values.firstWhere(
        (c) => c.name == saved,
        orElse: () => ThemeChoice.system,
      );
      notifyListeners();
    }
  }

  Future<void> setChoice(ThemeChoice choice) async {
    if (_choice == choice) return;
    _choice = choice;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, choice.name);
  }

  /// Compatibilidad: alternar claro/oscuro (fuerza el modo).
  Future<void> setDark(bool value) =>
      setChoice(value ? ThemeChoice.dark : ThemeChoice.light);

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
