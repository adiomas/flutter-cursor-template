import 'package:equatable/equatable.dart';

/// Represents a single log entry
class LogEntry extends Equatable {
  final String level;
  final String message;
  final DateTime timestamp;
  final String? error;
  final String? stackTrace;

  const LogEntry({
    required this.level,
    required this.message,
    required this.timestamp,
    this.error,
    this.stackTrace,
  });

  /// Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'level': level,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
      'error': error,
      'stackTrace': stackTrace,
    };
  }

  /// Create from JSON
  factory LogEntry.fromJson(Map<String, dynamic> json) {
    return LogEntry(
      level: json['level'] as String,
      message: json['message'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      error: json['error'] as String?,
      stackTrace: json['stackTrace'] as String?,
    );
  }

  /// Get emoji for level
  String get emoji {
    return switch (level) {
      'TRACE' => '🔍',
      'DEBUG' => '🐛',
      'INFO' => '💡',
      'WARNING' => '⚠️',
      'ERROR' => '❌',
      'FATAL' => '💀',
      _ => '📝',
    };
  }

  /// Get color for level
  String get colorHex {
    return switch (level) {
      'TRACE' => '#9E9E9E',
      'DEBUG' => '#2196F3',
      'INFO' => '#4CAF50',
      'WARNING' => '#FF9800',
      'ERROR' => '#F44336',
      'FATAL' => '#B71C1C',
      _ => '#000000',
    };
  }

  @override
  List<Object?> get props => [level, message, timestamp, error, stackTrace];
}

