import 'package:flutter/material.dart';
import '../../features/auth/domain/entities/auth_token.dart';

class AuthProvider extends ChangeNotifier {
  AuthToken? _user;

  AuthToken? get user => _user;
  bool get isLoggedIn => _user != null;
  String get role => _user?.role ?? '';
  int? get userId => _user?.userId;
  String get displayName =>
      _user != null ? '${_user!.name} ${_user!.lastName}' : '';

  void setUser(AuthToken token) {
    _user = token;
    notifyListeners();
  }

  void clearUser() {
    _user = null;
    notifyListeners();
  }
}
