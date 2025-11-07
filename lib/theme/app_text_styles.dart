import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTextStyles {
  // Display Styles (without color - will be set dynamically)
  static const displayLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    height: 1.2,
  );

  static const displayMedium = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    height: 1.2,
  );

  // Title Styles (without color - will be set dynamically)
  static const titleLarge = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  static const titleMedium = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  static const titleSmall = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  // Body Styles (without color - will be set dynamically)
  static const bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    height: 1.5,
  );

  static const bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    height: 1.5,
  );

  static const bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    height: 1.5,
  );

  // Label Styles (without color - will be set dynamically)
  static const labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  static const labelMedium = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );

  static const labelSmall = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
  );

  // Button Styles (white color is fine for buttons)
  static const button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  // Caption (without color - will be set dynamically)
  static const caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
  );
}

// Extension for easy access
extension AppTextStylesExtension on BuildContext {
  AppTextStylesData get textStyles {
    final colors = appColors;
    return AppTextStylesData(colors: colors);
  }
}

class AppTextStylesData {
  final AppColorsData colors;

  AppTextStylesData({required this.colors});

  // Display
  TextStyle get displayLarge =>
      AppTextStyles.displayLarge.copyWith(color: colors.textPrimary);
  TextStyle get displayMedium =>
      AppTextStyles.displayMedium.copyWith(color: colors.textPrimary);

  // Titles
  TextStyle get titleLarge =>
      AppTextStyles.titleLarge.copyWith(color: colors.textPrimary);
  TextStyle get titleMedium =>
      AppTextStyles.titleMedium.copyWith(color: colors.textPrimary);
  TextStyle get titleSmall =>
      AppTextStyles.titleSmall.copyWith(color: colors.textPrimary);
  TextStyle get headline1 =>
      AppTextStyles.titleLarge.copyWith(color: colors.textPrimary);
  TextStyle get headline2 =>
      AppTextStyles.titleMedium.copyWith(color: colors.textPrimary);

  // Body
  TextStyle get bodyLarge =>
      AppTextStyles.bodyLarge.copyWith(color: colors.textPrimary);
  TextStyle get bodyMedium =>
      AppTextStyles.bodyMedium.copyWith(color: colors.textPrimary);
  TextStyle get bodySmall =>
      AppTextStyles.bodySmall.copyWith(color: colors.textSecondary);
  TextStyle get bodyText1 =>
      AppTextStyles.bodyLarge.copyWith(color: colors.textPrimary);
  TextStyle get bodyText2 =>
      AppTextStyles.bodyMedium.copyWith(color: colors.textPrimary);

  // Grey variants (uses greyText which adapts to dark mode)
  TextStyle get greyBodyText1 =>
      AppTextStyles.bodyLarge.copyWith(color: colors.greyText);
  TextStyle get greyBodyText2 =>
      AppTextStyles.bodyMedium.copyWith(color: colors.greyText);

  // Labels
  TextStyle get labelLarge =>
      AppTextStyles.labelLarge.copyWith(color: colors.textPrimary);
  TextStyle get labelMedium =>
      AppTextStyles.labelMedium.copyWith(color: colors.textSecondary);
  TextStyle get labelSmall =>
      AppTextStyles.labelSmall.copyWith(color: colors.textSecondary);

  // Others
  TextStyle get button => AppTextStyles.button;
  TextStyle get caption =>
      AppTextStyles.caption.copyWith(color: colors.textSecondary);
}
