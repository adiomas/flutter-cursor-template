class AppConstants {
  // App Info
  static const appName = 'GlowAI';
  static const appVersion = '1.0.0';
  
  // API Timeouts
  static const apiTimeout = Duration(seconds: 30);
  static const uploadTimeout = Duration(minutes: 5);
  
  // Validation
  static const minPasswordLength = 8;
  static const maxPasswordLength = 128;
  
  // Pagination
  static const defaultPageSize = 20;
  static const maxPageSize = 100;
  
  // Cache Duration
  static const shortCacheDuration = Duration(minutes: 5);
  static const mediumCacheDuration = Duration(hours: 1);
  static const longCacheDuration = Duration(days: 1);
  
  // Note: Error and success messages are now localized via l10n
  // Use context.l10n.errorGeneric, context.l10n.successSaved, etc.
}

