import 'dart:convert';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/logger/app_logger.dart';

/// Provider for credentials storage service
final credentialsStorageProvider = Provider<CredentialsStorage>(
  (ref) => CredentialsStorage(),
);

/// Model for saved email entry
class SavedEmail {
  final String email;
  final DateTime lastUsed;

  SavedEmail({
    required this.email,
    required this.lastUsed,
  });

  Map<String, dynamic> toJson() => {
        'email': email,
        'lastUsed': lastUsed.toIso8601String(),
      };

  factory SavedEmail.fromJson(Map<String, dynamic> json) => SavedEmail(
        email: json['email'] as String,
        lastUsed: DateTime.parse(json['lastUsed'] as String),
      );
}

/// Service for securely storing and retrieving user credentials
/// Uses flutter_secure_storage on mobile platforms, falls back to shared_preferences on web
class CredentialsStorage {
  static const String _emailsListKey = 'saved_emails_list';
  static const int _maxSavedEmails = 10; // Maximum number of saved emails

  FlutterSecureStorage? _secureStorage;
  bool _useSecureStorage = false; // Start with false, enable after verification
  bool _availabilityChecked = false;

  final _logger = AppLogger.instance;

  CredentialsStorage() {
    // Only attempt to use secure storage on mobile platforms
    if (!kIsWeb) {
      try {
        _secureStorage = const FlutterSecureStorage(
          aOptions: AndroidOptions(
            encryptedSharedPreferences: true,
          ),
          iOptions: IOSOptions(
            accessibility: KeychainAccessibility.first_unlock_this_device,
          ),
        );
        // Will verify availability on first use
      } catch (e) {
        // If initialization fails, use shared_preferences
        _secureStorage = null;
        _useSecureStorage = false;
        _logger.debug(
          'Secure storage initialization failed, using shared_preferences',
        );
      }
    } else {
      _secureStorage = null;
      _useSecureStorage = false;
    }
  }

  /// Check if secure storage is actually available by attempting a test read
  Future<bool> _checkSecureStorageAvailability() async {
    if (_availabilityChecked) {
      return _useSecureStorage;
    }

    if (kIsWeb || _secureStorage == null) {
      _useSecureStorage = false;
      _availabilityChecked = true;
      return false;
    }

    try {
      // Try a test read to verify plugin is available
      await _secureStorage!.read(key: '__test_availability__');
      _useSecureStorage = true;
      _availabilityChecked = true;
      return true;
    } catch (e) {
      // Plugin not available, use shared_preferences
      _useSecureStorage = false;
      _availabilityChecked = true;
      _secureStorage = null; // Clear reference to avoid future attempts
      return false;
    }
  }

  /// Save email and password securely
  /// Adds email to saved emails list and stores password for that email
  Future<void> saveCredentials({
    required String email,
    required String password,
  }) async {
    try {
      final normalizedEmail = email.trim().toLowerCase();
      final passwordKey = 'password_$normalizedEmail';

      // Check availability first
      final isSecureStorageAvailable = await _checkSecureStorageAvailability();

      // Save password for this email
      if (isSecureStorageAvailable && _secureStorage != null) {
        try {
          await _secureStorage!.write(key: passwordKey, value: password);
        } catch (e) {
          // If secure storage fails, switch to fallback permanently
          _useSecureStorage = false;
          _secureStorage = null;
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(passwordKey, password);
        }
      } else {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(passwordKey, password);
      }

      // Update saved emails list
      final savedEmails = await getSavedEmails();

      // Remove existing entry if present
      savedEmails.removeWhere((e) => e.email.toLowerCase() == normalizedEmail);

      // Add to beginning (most recent first)
      savedEmails.insert(
          0,
          SavedEmail(
            email: normalizedEmail,
            lastUsed: DateTime.now(),
          ));

      // Limit to max saved emails
      if (savedEmails.length > _maxSavedEmails) {
        savedEmails.removeRange(_maxSavedEmails, savedEmails.length);
      }

      // Save emails list
      final emailsJson = jsonEncode(
        savedEmails.map((e) => e.toJson()).toList(),
      );

      // Reuse availability check from above
      if (isSecureStorageAvailable && _secureStorage != null) {
        try {
          await _secureStorage!.write(key: _emailsListKey, value: emailsJson);
        } catch (e) {
          // If secure storage fails, switch to fallback permanently
          _useSecureStorage = false;
          _secureStorage = null;
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(_emailsListKey, emailsJson);
        }
      } else {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_emailsListKey, emailsJson);
      }

      _logger.debug('✅ Credentials saved successfully for: $normalizedEmail');
    } catch (e, stackTrace) {
      _logger.error(
        'Failed to save credentials',
        error: e,
        stackTrace: stackTrace,
      );
      // If we're still trying to use secure storage, switch to fallback and retry once
      if (_useSecureStorage) {
        _logger.debug('Retrying with shared_preferences fallback');
        _useSecureStorage = false;
        try {
          await saveCredentials(email: email, password: password);
          _logger.debug('✅ Credentials saved using fallback');
        } catch (e2) {
          _logger.error('Fallback save also failed', error: e2);
        }
      }
    }
  }

  /// Get list of saved emails (sorted by last used, most recent first)
  Future<List<SavedEmail>> getSavedEmails() async {
    try {
      String? emailsJson;

      // Check availability first
      final isSecureStorageAvailable = await _checkSecureStorageAvailability();

      // Try secure storage first if available
      if (isSecureStorageAvailable && _secureStorage != null) {
        try {
          emailsJson = await _secureStorage!.read(key: _emailsListKey);
        } catch (e) {
          // If secure storage fails, switch to fallback permanently
          _useSecureStorage = false;
          _secureStorage = null;
          final prefs = await SharedPreferences.getInstance();
          emailsJson = prefs.getString(_emailsListKey);
        }
      } else {
        // Use shared_preferences directly
        final prefs = await SharedPreferences.getInstance();
        emailsJson = prefs.getString(_emailsListKey);
      }

      if (emailsJson == null || emailsJson.isEmpty) {
        return [];
      }

      final List<dynamic> jsonList = jsonDecode(emailsJson) as List<dynamic>;
      return jsonList
          .map((json) => SavedEmail.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e, stackTrace) {
      _logger.error(
        'Failed to read saved emails list',
        error: e,
        stackTrace: stackTrace,
      );
      return [];
    }
  }

  /// Get saved password for a specific email
  Future<String?> getSavedPassword(String email) async {
    try {
      final normalizedEmail = email.trim().toLowerCase();
      final passwordKey = 'password_$normalizedEmail';

      // Check availability first
      final isSecureStorageAvailable = await _checkSecureStorageAvailability();

      // Try secure storage first if available
      if (isSecureStorageAvailable && _secureStorage != null) {
        try {
          return await _secureStorage!.read(key: passwordKey);
        } catch (e) {
          // If secure storage fails, switch to fallback permanently
          _useSecureStorage = false;
          _secureStorage = null;
          final prefs = await SharedPreferences.getInstance();
          return prefs.getString(passwordKey);
        }
      } else {
        // Use shared_preferences directly
        final prefs = await SharedPreferences.getInstance();
        return prefs.getString(passwordKey);
      }
    } catch (e, stackTrace) {
      _logger.error(
        'Failed to read saved password for: $email',
        error: e,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  /// Get most recently used email and password
  Future<({String? email, String? password})> getLastUsedCredentials() async {
    try {
      final savedEmails = await getSavedEmails();
      if (savedEmails.isEmpty) {
        return (email: null, password: null);
      }

      final lastEmail = savedEmails.first.email;
      final password = await getSavedPassword(lastEmail);
      return (email: lastEmail, password: password);
    } catch (e, stackTrace) {
      _logger.error(
        'Failed to read last used credentials',
        error: e,
        stackTrace: stackTrace,
      );
      return (email: null, password: null);
    }
  }

  /// Remove saved email and its password
  Future<void> removeSavedEmail(String email) async {
    try {
      final normalizedEmail = email.trim().toLowerCase();
      final passwordKey = 'password_$normalizedEmail';

      // Check availability first
      final isSecureStorageAvailable = await _checkSecureStorageAvailability();

      // Remove password
      if (isSecureStorageAvailable && _secureStorage != null) {
        try {
          await _secureStorage!.delete(key: passwordKey);
        } catch (e) {
          // If secure storage fails, use fallback
          final prefs = await SharedPreferences.getInstance();
          await prefs.remove(passwordKey);
        }
      } else {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove(passwordKey);
      }

      // Remove from emails list
      final savedEmails = await getSavedEmails();
      savedEmails.removeWhere((e) => e.email.toLowerCase() == normalizedEmail);

      // Save updated list
      final emailsJson = jsonEncode(
        savedEmails.map((e) => e.toJson()).toList(),
      );

      // Reuse availability check from above
      if (isSecureStorageAvailable && _secureStorage != null) {
        try {
          await _secureStorage!.write(key: _emailsListKey, value: emailsJson);
        } catch (e) {
          // If secure storage fails, use fallback
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(_emailsListKey, emailsJson);
        }
      } else {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_emailsListKey, emailsJson);
      }

      _logger.debug('✅ Removed saved email: $normalizedEmail');
    } catch (e, stackTrace) {
      _logger.error(
        'Failed to remove saved email',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Clear all saved credentials
  Future<void> clearCredentials() async {
    try {
      final savedEmails = await getSavedEmails();

      // Check availability first
      final isSecureStorageAvailable = await _checkSecureStorageAvailability();

      // Delete all passwords
      for (final savedEmail in savedEmails) {
        final passwordKey = 'password_${savedEmail.email}';
        if (isSecureStorageAvailable && _secureStorage != null) {
          try {
            await _secureStorage!.delete(key: passwordKey);
          } catch (e) {
            // If secure storage fails, use fallback
            final prefs = await SharedPreferences.getInstance();
            await prefs.remove(passwordKey);
          }
        } else {
          final prefs = await SharedPreferences.getInstance();
          await prefs.remove(passwordKey);
        }
      }

      // Clear emails list
      if (isSecureStorageAvailable && _secureStorage != null) {
        try {
          await _secureStorage!.delete(key: _emailsListKey);
        } catch (e) {
          // If secure storage fails, use fallback
          final prefs = await SharedPreferences.getInstance();
          await prefs.remove(_emailsListKey);
        }
      } else {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove(_emailsListKey);
      }

      _logger.debug('✅ All credentials cleared successfully');
    } catch (e, stackTrace) {
      _logger.error(
        'Failed to clear credentials',
        error: e,
        stackTrace: stackTrace,
      );
      // Try fallback if secure storage failed
      if (_useSecureStorage) {
        _useSecureStorage = false;
        await clearCredentials();
      }
    }
  }
}
