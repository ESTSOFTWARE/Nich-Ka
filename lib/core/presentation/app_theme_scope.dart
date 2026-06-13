import 'package:flutter/material.dart';
import 'app_theme_provider.dart';

class AppThemeScope extends InheritedNotifier<AppThemeProvider> {
  const AppThemeScope({
    super.key,
    required AppThemeProvider notifier,
    required super.child,
  }) : super(notifier: notifier);

  static AppThemeProvider of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<AppThemeScope>()!
        .notifier!;
  }
}
