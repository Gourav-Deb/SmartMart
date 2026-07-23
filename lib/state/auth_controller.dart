import 'package:flutter/foundation.dart';
import '../models/app_user.dart';
import '../services/auth_service.dart';

class AuthController extends ChangeNotifier {
  AppUser? _currentUser;
  String? _error;

  AppUser? get currentUser => _currentUser;
  String? get error => _error;
  bool get isLoggedIn => _currentUser != null;
  bool get isAdmin => _currentUser?.role == UserRole.admin;

  bool login(String email, String password) {
    final normalized = email.trim().toLowerCase();
    DemoAccount? match;
    for (final account in [AuthAccounts.admin, AuthAccounts.rider, AuthAccounts.customer]) {
      if (account.email == normalized && account.password == password) {
        match = account;
        break;
      }
    }

    if (match == null) {
      _error = 'Invalid email or password';
      notifyListeners();
      return false;
    }

    _currentUser = AppUser(
      uid: match.email,
      email: match.email,
      name: match.name,
      role: match.role,
    );
    _error = null;
    notifyListeners();
    return true;
  }

  void logout() {
    _currentUser = null;
    _error = null;
    notifyListeners();
  }

  void clearError() {
    if (_error == null) return;
    _error = null;
    notifyListeners();
  }
}

final authController = AuthController();
