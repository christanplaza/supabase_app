import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  bool _isAuthenticated = false;
  String _userId = '';

  bool get isAuthenticated => _isAuthenticated;
  String get userId => _userId;

  void setAuthenticationState(bool isAuthenticated, String userId) {
    _isAuthenticated = isAuthenticated;
    _userId = userId;
    notifyListeners();
  }
}
