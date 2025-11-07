import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const primary = Color(0xFF6366F1);
  static const secondary = Color(0xFF8B5CF6);

  // Backgrounds
  static const background = Color(0xFFFAFAFA);
  static const contentBackground = Colors.white;
  static const cardBackground = Colors.white;

  // Text Colors
  static const textPrimary = Color(0xFF1F2937);
  static const textSecondary = Color(0xFF6B7280);
  static const textDisabled = Color(0xFF9CA3AF);

  // Status Colors
  static const success = Color(0xFF10B981);
  static const error = Color(0xFFEF4444);
  static const warning = Color(0xFFF59E0B);
  static const info = Color(0xFF3B82F6);

  // UI Elements
  static const border = Color(0xFFE5E7EB);
  static const divider = Color(0xFFE5E7EB);
  static const shadow = Color(0x1A000000);

  // Greys
  static const grey50 = Color(0xFFF9FAFB);
  static const grey100 = Color(0xFFF3F4F6);
  static const grey200 = Color(0xFFE5E7EB);
  static const grey300 = Color(0xFFD1D5DB);
  static const grey400 = Color(0xFF9CA3AF);
  static const grey500 = Color(0xFF6B7280);
  static const grey600 = Color(0xFF4B5563);
  static const grey700 = Color(0xFF374151);
  static const grey800 = Color(0xFF1F2937);
  static const grey900 = Color(0xFF111827);
}

// Extension for easy access
extension AppColorsExtension on BuildContext {
  AppColorsData get appColors {
    final brightness = Theme.of(this).brightness;
    return AppColorsData(isDark: brightness == Brightness.dark);
  }
}

class AppColorsData {
  final bool isDark;

  AppColorsData({this.isDark = false});

  // Primary Colors
  Color get primary => AppColors.primary;
  Color get secondary => AppColors.secondary;

  // Backgrounds
  Color get background => isDark ? AppColors.grey900 : AppColors.background;
  Color get contentBackground =>
      isDark ? AppColors.grey800 : AppColors.contentBackground;
  Color get cardBackground =>
      isDark ? AppColors.grey800 : AppColors.cardBackground;

  // Text Colors
  Color get textPrimary => isDark ? AppColors.grey50 : AppColors.textPrimary;
  Color get textSecondary =>
      isDark ? AppColors.grey300 : AppColors.textSecondary;
  Color get textDisabled => isDark ? AppColors.grey500 : AppColors.textDisabled;
  Color get greyText => isDark ? AppColors.grey400 : AppColors.grey500;

  // Status Colors
  Color get success => AppColors.success;
  Color get error => AppColors.error;
  Color get warning => AppColors.warning;
  Color get info => AppColors.info;

  // UI Elements
  Color get border => isDark ? AppColors.grey700 : AppColors.border;
  Color get divider => isDark ? AppColors.grey700 : AppColors.divider;
  Color get shadow => AppColors.shadow;
}
