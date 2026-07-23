import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  bool _isDark = true;
  String _currentRoute = "PORTAL_SELECTION"; // "LOGIN", "PORTAL_SELECTION", "ADMIN", "RIDER", "CUSTOMER"
  String _currentUserEmail = "admin@smartmart.ai";
  UserRole _currentRole = UserRole.admin;
  bool _isLoading = false;
  String? _errorMessage;

  bool get isDark => _isDark;
  String get currentRoute => _currentRoute;
  String get currentUserEmail => _currentUserEmail;
  UserRole get currentRole => _currentRole;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void toggleTheme() {
    _isDark = !_isDark;
    notifyListeners();
  }

  void selectPortal(String role) {
    switch (role.toUpperCase()) {
      case "ADMIN":
      case "SUPER_ADMIN":
        _currentRole = UserRole.admin;
        _currentRoute = "ADMIN";
        break;
      case "RIDER":
        _currentRole = UserRole.rider;
        _currentRoute = "RIDER";
        break;
      case "CUSTOMER":
        _currentRole = UserRole.customer;
        _currentRoute = "CUSTOMER";
        break;
      default:
        _currentRoute = "PORTAL_SELECTION";
    }
    notifyListeners();
  }

  void setRoute(String route) {
    _currentRoute = route;
    notifyListeners();
  }

  Future<bool> login(String email, String password, String selectedRole) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    _currentUserEmail = email;
    _currentRole = await AuthService.authenticate(
      email: email,
      password: password,
      selectedRole: selectedRole,
    );

    selectPortal(_currentRole.toRoleString());
    _isLoading = false;
    notifyListeners();
    return true;
  }

  void logout() {
    _currentRoute = "PORTAL_SELECTION";
    notifyListeners();
  }
}
