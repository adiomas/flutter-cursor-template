import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider for managing app locale/language
/// 
/// Usage:
/// ```dart
/// // In MaterialApp
/// final locale = ref.watch(localeProvider);
/// 
/// // Switch language
/// ref.read(localeProvider.notifier).setLocale(const Locale('hr'));
/// 
/// // Or use convenience methods
/// ref.read(localeProvider.notifier).setEnglish();
/// ref.read(localeProvider.notifier).setCroatian();
/// ```
final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier();
});

class LocaleNotifier extends StateNotifier<Locale> {
  static const String _storageKey = 'language_code';
  
  LocaleNotifier() : super(const Locale('en')) {
    _loadLocale();
  }
  
  /// Load saved locale from storage
  Future<void> _loadLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final languageCode = prefs.getString(_storageKey);
      
      if (languageCode != null) {
        state = Locale(languageCode);
      }
    } catch (e) {
      // If loading fails, stay with default (en)
      debugPrint('Failed to load locale: $e');
    }
  }
  
  /// Set locale and persist to storage
  Future<void> setLocale(Locale locale) async {
    state = locale;
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_storageKey, locale.languageCode);
    } catch (e) {
      debugPrint('Failed to save locale: $e');
    }
  }
  
  /// Convenience method: Set to English
  Future<void> setEnglish() => setLocale(const Locale('en'));
  
  /// Convenience method: Set to Croatian
  Future<void> setCroatian() => setLocale(const Locale('hr'));
  
  /// Convenience method: Set to German
  Future<void> setGerman() => setLocale(const Locale('de'));
  
  /// Convenience method: Set to Spanish
  Future<void> setSpanish() => setLocale(const Locale('es'));
  
  /// Convenience method: Set to French
  Future<void> setFrench() => setLocale(const Locale('fr'));
  
  /// Reset to default (English)
  Future<void> resetToDefault() => setEnglish();
}

