import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'log_entry.dart';

/// Handles persistent storage of logs
class LogStorage {
  static const String _logsKey = 'app_logs';
  static const int _maxLogs = 1000; // Maximum number of logs to store

  /// Add a new log entry
  Future<void> addLog(LogEntry entry) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final logs = await getLogs();

      // Add new log
      logs.insert(0, entry); // Most recent first

      // Limit to max logs
      if (logs.length > _maxLogs) {
        logs.removeRange(_maxLogs, logs.length);
      }

      // Save to storage
      final jsonList = logs.map((log) => log.toJson()).toList();
      await prefs.setString(_logsKey, jsonEncode(jsonList));
    } catch (e) {
      // Silently fail - don't crash app if logging fails
      // ignore: avoid_print
      print('Failed to save log: $e');
    }
  }

  /// Get all stored logs
  Future<List<LogEntry>> getLogs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_logsKey);

      if (jsonString == null || jsonString.isEmpty) {
        return [];
      }

      final jsonList = jsonDecode(jsonString) as List<dynamic>;
      return jsonList
          .map((json) => LogEntry.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      // ignore: avoid_print
      print('Failed to load logs: $e');
      return [];
    }
  }

  /// Clear all stored logs
  Future<void> clearLogs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_logsKey);
    } catch (e) {
      // ignore: avoid_print
      print('Failed to clear logs: $e');
    }
  }

  /// Get logs count
  Future<int> getLogsCount() async {
    final logs = await getLogs();
    return logs.length;
  }

  /// Get logs by level
  Future<List<LogEntry>> getLogsByLevel(String level) async {
    final logs = await getLogs();
    return logs.where((log) => log.level == level).toList();
  }

  /// Get logs by date range
  Future<List<LogEntry>> getLogsByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    final logs = await getLogs();
    return logs.where((log) {
      return log.timestamp.isAfter(start) && log.timestamp.isBefore(end);
    }).toList();
  }

  /// Get error logs only
  Future<List<LogEntry>> getErrorLogs() async {
    final logs = await getLogs();
    return logs
        .where((log) => log.level == 'ERROR' || log.level == 'FATAL')
        .toList();
  }
}
