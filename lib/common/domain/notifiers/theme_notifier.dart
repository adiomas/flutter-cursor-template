import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/logger/app_logger.dart';

/// Provider for theme mode state management
final themeNotifierProvider =
    StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier();
});

/// Notifier for managing app theme mode (light/dark/system)
/// Persists theme preference to SharedPreferences
class ThemeNotifier extends StateNotifier<ThemeMode> {
  static const String _storageKey = 'theme_mode';
  final _logger = AppLogger.instance;

  ThemeNotifier() : super(ThemeMode.system) {
    _loadTheme();
  }

  /// Load saved theme from storage
  Future<void> _loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeModeString = prefs.getString(_storageKey);

      if (themeModeString != null) {
        final themeMode = _parseThemeMode(themeModeString);
        state = themeMode;
        _logger.debug('✅ Loaded theme mode: $themeModeString');
      } else {
        _logger.debug('No saved theme mode, using system default');
      }
    } catch (e, stackTrace) {
      _logger.error(
        'Failed to load theme mode',
        error: e,
        stackTrace: stackTrace,
      );
      // Stay with default (system)
    }
  }

  /// Set theme mode and persist to storage
  Future<void> setThemeMode(ThemeMode themeMode) async {
    state = themeMode;
    _logger.debug('Theme mode changed to: $themeMode');

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_storageKey, themeMode.name);
      _logger.debug('✅ Theme mode saved to storage');
    } catch (e, stackTrace) {
      _logger.error(
        'Failed to save theme mode',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Toggle between light and dark (skips system)
  Future<void> toggleTheme() async {
    final newMode = switch (state) {
      ThemeMode.light => ThemeMode.dark,
      ThemeMode.dark => ThemeMode.light,
      ThemeMode.system => ThemeMode.dark, // Default to dark when toggling from system
    };
    await setThemeMode(newMode);
  }

  /// Parse theme mode string to ThemeMode enum
  ThemeMode _parseThemeMode(String value) {
    return switch (value) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      'system' => ThemeMode.system,
      _ => ThemeMode.system,
    };
  }
}

