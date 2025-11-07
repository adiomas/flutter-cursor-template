import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';

import '../logger/app_logger.dart';

/// Global error handler for catching uncaught errors
class GlobalErrorHandler {
  static void initialize() {
    // Catch Flutter framework errors
    FlutterError.onError = (FlutterErrorDetails details) {
      // Ignore harmless plugin registration errors
      final errorString = details.exception.toString();
      final stackString = details.stack?.toString() ?? '';
      final library = details.library ?? '';
      final context = details.context?.toString() ?? '';

      if (_isHarmlessError(errorString) ||
          _isHarmlessError(stackString) ||
          _isHarmlessError(library) ||
          _isHarmlessError(context)) {
        // Silently ignore these errors - they don't affect functionality
        // These are known iOS plugin registration timing issues
        return;
      }

      AppLogger.instance.fatal(
        'Flutter framework error',
        error: details.exception,
        stackTrace: details.stack,
      );

      // In debug mode, also print to console (but not for harmless errors)
      FlutterError.presentError(details);
    };

    // Catch async errors outside of Flutter
    PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
      // Ignore harmless plugin registration errors
      final errorString = error.toString();
      final stackString = stack.toString();

      if (_isHarmlessError(errorString) || _isHarmlessError(stackString)) {
        // Silently ignore these errors - they don't affect functionality
        // These are known iOS plugin registration timing issues
        return true;
      }

      AppLogger.instance.fatal(
        'Uncaught async error',
        error: error,
        stackTrace: stack,
      );
      return true; // Handled
    };
  }

  /// Check if error is a harmless plugin registration error
  /// These errors occur on iOS when plugins try to register before
  /// the platform channel is fully initialized. They don't affect functionality.
  static bool _isHarmlessError(String errorString) {
    if (errorString.isEmpty) return false;

    final lowerError = errorString.toLowerCase();
    return lowerError.contains('flutter_keyboard_visibility') ||
        lowerError.contains('pointer_interceptor') ||
        lowerError.contains('missingpluginexception') ||
        lowerError.contains('unregistered_view_type') ||
        lowerError.contains('no implementation found for method') ||
        lowerError.contains('platformexception') ||
        lowerError.contains('methodchannel') ||
        lowerError.contains('eventchannel') ||
        (lowerError.contains('listen') && lowerError.contains('channel'));
  }

  /// Wrap a callback with error handling
  static Future<T?> runProtected<T>(
    Future<T> Function() callback, {
    String? context,
  }) async {
    try {
      return await callback();
    } catch (error, stackTrace) {
      AppLogger.instance.error(
        context ?? 'Error in protected callback',
        error: error,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  /// Run callback and log errors without rethrowing
  static void runSilent(
    void Function() callback, {
    String? context,
  }) {
    try {
      callback();
    } catch (error, stackTrace) {
      AppLogger.instance.error(
        context ?? 'Error in silent callback',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }
}
