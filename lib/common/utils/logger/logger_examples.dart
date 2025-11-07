import 'app_logger.dart';

/// Examples of how to use AppLogger throughout the application
class LoggerExamples {
  static final _logger = AppLogger.instance;

  /// Example: Logging in a repository
  static Future<void> fetchDataExample() async {
    _logger.debug('Fetching data from API...');

    try {
      // Simulated API call
      await Future.delayed(const Duration(seconds: 2));
      _logger.info('✅ Data fetched successfully');
    } catch (e, stackTrace) {
      _logger.error(
        'Failed to fetch data',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Example: Logging navigation
  static void navigateExample(String routeName) {
    _logger.debug('🧭 Navigating to: $routeName');
  }

  /// Example: Logging user actions
  static void userActionExample(String action) {
    _logger.info('👤 User action: $action');
  }

  /// Example: Logging state changes
  static void stateChangeExample(String oldState, String newState) {
    _logger.debug('State changed: $oldState → $newState');
  }

  /// Example: Logging authentication
  static void authExample(String userId) {
    _logger.info('🔐 User authenticated: $userId');
  }

  /// Example: Logging warnings
  static void warningExample() {
    _logger.warning('⚠️ This feature is deprecated, use newFeature() instead');
  }

  /// Example: Logging fatal errors
  static void fatalErrorExample(Object error) {
    _logger.fatal(
      '💀 Critical error occurred',
      error: error,
    );
  }

  /// Example: Logging network requests
  static void networkRequestExample(String method, String url) {
    _logger.debug('🌐 $method $url');
  }

  /// Example: Logging with additional data
  static void complexLogExample() {
    _logger.info(
      '📊 User analytics event',
      data: {
        'screen': 'home',
        'action': 'button_click',
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }
}

