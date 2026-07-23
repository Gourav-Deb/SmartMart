import 'package:flutter/material.dart';
import 'app_theme.dart';

/// App-wide color aliases mapped to [AppTheme] brand tokens.
class AppColors {
  static Color primary = AppTheme.primary;
  static const Color primaryDark = Color(0xFF059669);
  static const Color primaryLight = Color(0xFFD1FAE5);
  static Color secondary = AppTheme.secondary;
  static const Color categoryTint = Color(0xFFECFDF5);
  static Color background = AppTheme.bgLight;
  static const Color surface = Colors.white;
  static Color cardBorder = AppTheme.borderLight;
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color navInactive = Color(0xFF64748B);
  static Color navActive = AppTheme.primary;
  static Color accent = AppTheme.accent;
  static Color danger = AppTheme.danger;
  static Color success = AppTheme.success;
}
