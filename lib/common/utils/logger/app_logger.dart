import 'dart:async';
import 'dart:io';

import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

import '../../domain/app_environment.dart';
import 'log_entry.dart';
import 'log_storage.dart';

/// Application-wide logger with environment-specific configuration
class AppLogger {
  static AppLogger? _instance;
  static AppLogger get instance => _instance ??= AppLogger._();

  late Logger _logger;
  late LogStorage _storage;
  final _logStreamController = StreamController<LogEntry>.broadcast();

  AppLogger._() {
    _initLogger();
    _storage = LogStorage();
  }

  /// Stream of log entries for real-time monitoring
  Stream<LogEntry> get logStream => _logStreamController.stream;

  void _initLogger() {
    final level = _getLogLevel();

    _logger = Logger(
      filter: ProductionFilter(),
      printer: _CustomLogPrinter(),
      output: _CustomLogOutput(
        onLog: _handleLogOutput,
      ),
      level: level,
    );
  }

  Level _getLogLevel() {
    if (EnvInfo.isDevelopment) {
      return Level.trace; // All logs
    } else if (EnvInfo.isStaging) {
      return Level.debug; // Debug and above
    } else {
      return Level.warning; // Only warnings and errors in production
    }
  }

  void _handleLogOutput(LogEntry entry) {
    // Add to stream for real-time monitoring
    _logStreamController.add(entry);

    // Save to storage (only in dev and staging)
    if (!EnvInfo.isProduction) {
      _storage.addLog(entry);
    }
  }

  /// Log trace message (only in development)
  void trace(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, dynamic>? data,
  }) {
    _logger.t(
      message,
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Log debug message
  void debug(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, dynamic>? data,
  }) {
    _logger.d(
      message,
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Log info message
  void info(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, dynamic>? data,
  }) {
    _logger.i(
      message,
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Log warning message
  void warning(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, dynamic>? data,
  }) {
    _logger.w(
      message,
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Log error message
  void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, dynamic>? data,
  }) {
    _logger.e(
      message,
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Log fatal error
  void fatal(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, dynamic>? data,
  }) {
    _logger.f(
      message,
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Get all stored logs
  Future<List<LogEntry>> getLogs() async {
    return _storage.getLogs();
  }

  /// Clear all stored logs
  Future<void> clearLogs() async {
    await _storage.clearLogs();
  }

  /// Export logs to file
  Future<File> exportLogs() async {
    final logs = await getLogs();
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/logs_${DateTime.now().millisecondsSinceEpoch}.txt');

    final buffer = StringBuffer();
    buffer.writeln('GlowAI Logs Export');
    buffer.writeln('Generated: ${DateTime.now()}');
    buffer.writeln('Environment: ${EnvInfo.environment.name}');
    buffer.writeln('=' * 80);
    buffer.writeln();

    for (final log in logs) {
      buffer.writeln('[${log.timestamp}] [${log.level}] ${log.message}');
      if (log.error != null) {
        buffer.writeln('Error: ${log.error}');
      }
      if (log.stackTrace != null) {
        buffer.writeln('Stack trace:\n${log.stackTrace}');
      }
      buffer.writeln('-' * 80);
    }

    await file.writeAsString(buffer.toString());
    return file;
  }

  void dispose() {
    _logStreamController.close();
  }
}

/// Custom log printer with formatted output
class _CustomLogPrinter extends LogPrinter {
  static final _levelEmojis = {
    Level.trace: '🔍',
    Level.debug: '🐛',
    Level.info: '💡',
    Level.warning: '⚠️',
    Level.error: '❌',
    Level.fatal: '💀',
  };

  @override
  List<String> log(LogEvent event) {
    final emoji = _levelEmojis[event.level] ?? '📝';
    final time = DateTime.now().toString().split('.')[0];
    final message = event.message;

    final output = <String>['$emoji [$time] $message'];

    if (event.error != null) {
      output.add('└─ Error: ${event.error}');
    }

    if (event.stackTrace != null) {
      output.add('└─ Stack trace:');
      output.add(event.stackTrace.toString());
    }

    return output;
  }
}

/// Custom log output handler
class _CustomLogOutput extends LogOutput {
  final void Function(LogEntry entry) onLog;

  _CustomLogOutput({required this.onLog});

  @override
  void output(OutputEvent event) {
    final lines = event.lines;
    if (lines.isEmpty) return;

    // Check if this is a harmless plugin error that should be filtered
    final allText = lines.join('\n').toLowerCase();
    if (_isHarmlessPluginError(allText)) {
      // Silently ignore harmless plugin registration errors
      return;
    }

    // Parse the first line to extract information
    final firstLine = lines[0];
    final level = _parseLevel(event.level);
    final message = _extractMessage(firstLine);
    final timestamp = DateTime.now();

    String? error;
    String? stackTrace;

    // Extract error and stack trace if present
    for (var i = 1; i < lines.length; i++) {
      final line = lines[i];
      if (line.contains('Error:')) {
        error = line.replaceFirst('└─ Error:', '').trim();
      } else if (line.contains('Stack trace:')) {
        stackTrace = lines.sublist(i + 1).join('\n');
        break;
      }
    }

    final entry = LogEntry(
      level: level,
      message: message,
      timestamp: timestamp,
      error: error,
      stackTrace: stackTrace,
    );

    // Print to console (but skip harmless plugin errors)
    if (!_isHarmlessPluginError(allText)) {
      for (final line in lines) {
        // ignore: avoid_print
        print(line);
      }

      // Send to handler
      onLog(entry);
    }
  }

  /// Check if log entry is a harmless plugin registration error
  bool _isHarmlessPluginError(String logText) {
    return logText.contains('flutter_keyboard_visibility') ||
        logText.contains('pointer_interceptor') ||
        logText.contains('missingpluginexception') ||
        logText.contains('unregistered_view_type') ||
        logText.contains('no implementation found for method') ||
        logText.contains('platformexception') ||
        (logText.contains('listen') && logText.contains('channel'));
  }

  String _parseLevel(Level level) {
    return switch (level) {
      Level.trace => 'TRACE',
      Level.debug => 'DEBUG',
      Level.info => 'INFO',
      Level.warning => 'WARNING',
      Level.error => 'ERROR',
      Level.fatal => 'FATAL',
      _ => 'UNKNOWN',
    };
  }

  String _extractMessage(String line) {
    // Remove emoji and timestamp
    final regex = RegExp(r'[🔍🐛💡⚠️❌💀📝]\s*\[.*?\]\s*(.*)');
    final match = regex.firstMatch(line);
    return match?.group(1) ?? line;
  }
}

