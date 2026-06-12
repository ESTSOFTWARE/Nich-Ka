import 'package:flutter/material.dart';
import '../../domain/entities/profile_user.dart';
import '../theme/profile_palette.dart';

class ProfileProvider extends ChangeNotifier {
  final ProfileUser user = const ProfileUser(
    firstName: 'Ameth',
    lastName: 'Toledo',
    email: 'ameth@nich-ka.space',
    role: 'ESTUDIANTE',
    circuit: 'NK-7HJ2-9KM4',
    memberSince: '15 mar 2026',
  );

  final bool isGoogleLinked = true;

  bool _isDarkMode = true;
  bool get isDarkMode => _isDarkMode;

  ProfilePalette get palette => ProfilePalette.of(_isDarkMode);

  void setDarkMode(bool value) {
    if (_isDarkMode == value) return;
    _isDarkMode = value;
    notifyListeners();
  }
}
