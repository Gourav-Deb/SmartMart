import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'theme/app_theme.dart';
import 'views/portal_selection_view.dart';
import 'views/login_view.dart';
import 'views/admin/admin_dashboard_view.dart';
import 'views/rider/rider_dashboard_view.dart';
import 'views/customer/customer_dashboard_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const SmartMartApp());
}

class SmartMartApp extends StatefulWidget {
  const SmartMartApp({super.key});

  @override
  State<SmartMartApp> createState() => _SmartMartAppState();
}

class _SmartMartAppState extends State<SmartMartApp> {
  bool isDark = true;
  String currentRoute = "PORTAL_SELECTION"; // "PORTAL_SELECTION", "LOGIN", "ADMIN", "RIDER", "CUSTOMER"
  String currentUserEmail = "admin@smartmart.ai";

  void _toggleTheme() {
    setState(() => isDark = !isDark);
  }

  void _setRoute(String route) {
    setState(() => currentRoute = route);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartMart Quick Commerce',
      debugShowCheckedModeBanner: false,
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      theme: AppTheme.lightTheme(context),
      darkTheme: AppTheme.darkTheme(context),
      home: Scaffold(
        backgroundColor: isDark ? AppTheme.bgDark : AppTheme.bgLight,
        body: _buildActiveView(),
      ),
    );
  }

  Widget _buildActiveView() {
    switch (currentRoute) {
      case "PORTAL_SELECTION":
        return PortalSelectionView(
          isDark: isDark,
          onToggleTheme: _toggleTheme,
          onSelectRole: (role) => _setRoute(role),
        );

      case "LOGIN":
        return LoginView(
          isDark: isDark,
          onToggleTheme: _toggleTheme,
          onLoginSuccess: (role, email) {
            setState(() {
              currentUserEmail = email;
              currentRoute = role;
            });
          },
        );

      case "ADMIN":
        return AdminDashboardView(
          isDark: isDark,
          onToggleTheme: _toggleTheme,
          onLogout: () => _setRoute("PORTAL_SELECTION"),
        );

      case "RIDER":
        return RiderDashboardView(
          isDark: isDark,
          onToggleTheme: _toggleTheme,
          onLogout: () => _setRoute("PORTAL_SELECTION"),
        );

      case "CUSTOMER":
        return CustomerDashboardView(
          isDark: isDark,
          onToggleTheme: _toggleTheme,
          onLogout: () => _setRoute("PORTAL_SELECTION"),
        );

      default:
        return PortalSelectionView(
          isDark: isDark,
          onToggleTheme: _toggleTheme,
          onSelectRole: (role) => _setRoute(role),
        );
    }
  }
}
