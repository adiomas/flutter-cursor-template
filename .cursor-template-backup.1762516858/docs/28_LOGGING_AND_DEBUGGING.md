# Logging and Debugging System

Complete guide to the GlowAI logging and debugging system with shake-to-open developer console.

## Overview

The logging system provides:
- **Environment-specific logging** (verbose in dev, minimal in production)
- **Shake-to-open developer console** (dev/staging only)
- **Real-time log monitoring**
- **Log persistence and export**
- **Beautiful UI for log inspection**

## Features

### 1. AppLogger - Application-Wide Logger

Located at: `lib/common/utils/logger/app_logger.dart`

**Key Features:**
- Singleton pattern for global access
- Environment-aware log levels
- Automatic log storage (dev/staging only)
- Real-time streaming
- Log export functionality

**Log Levels:**

| Level | When to Use | Production? |
|-------|-------------|-------------|
| `trace` | Very detailed debugging | ❌ No |
| `debug` | Debug information | ❌ No |
| `info` | General information | ✅ Yes (minimal) |
| `warning` | Warnings | ✅ Yes |
| `error` | Errors | ✅ Yes |
| `fatal` | Critical errors | ✅ Yes |

**Environment Configuration:**

```dart
// Development: All logs (TRACE and above)
// Staging: Debug logs (DEBUG and above)
// Production: Only warnings and errors (WARNING and above)
```

### 2. Shake Detection

Located at: `lib/common/presentation/widgets/developer_console/developer_console_overlay.dart`

**How It Works:**
1. User shakes the device
2. System detects shake gesture (3+ shakes in 500ms)
3. Developer console modal automatically opens
4. **Only active in dev and staging environments**

**Configuration:**
```dart
ShakeDetector.autoStart(
  onPhoneShake: _showDeveloperConsole,
  minimumShakeCount: 1,
  shakeSlopTimeMS: 500,
  shakeCountResetTime: 3000,
  shakeThresholdGravity: 2.7,
)
```

### 3. Developer Console Modal

Located at: `lib/common/presentation/widgets/developer_console/developer_console_modal.dart`

**Features:**
- Real-time log viewer
- Filter logs by level (ALL, TRACE, DEBUG, INFO, WARNING, ERROR, FATAL)
- Search logs by message or error
- View full log details (timestamp, message, error, stack trace)
- Export logs to file
- Copy individual logs to clipboard
- Clear all logs
- Beautiful dark theme UI

**UI Components:**
- **Header**: Shows environment, total log count, actions
- **Filters**: Quick filter chips for each log level
- **Search**: Full-text search across all logs
- **Log Cards**: Expandable cards with emoji indicators
- **Detail View**: Full log inspection with copy functionality

## Usage

### Basic Logging

```dart
import 'package:glow_ai/common/utils/logger/app_logger.dart';

final logger = AppLogger.instance;

// Trace (only in development)
logger.trace('Very detailed information');

// Debug
logger.debug('User tapped login button');

// Info
logger.info('✅ User logged in successfully');

// Warning
logger.warning('⚠️ API response took longer than expected');

// Error
logger.error(
  'Failed to load user data',
  error: error,
  stackTrace: stackTrace,
);

// Fatal
logger.fatal(
  '💀 Critical database error',
  error: error,
  stackTrace: stackTrace,
);
```

### Repository Example

```dart
class UserRepository {
  final _logger = AppLogger.instance;

  Future<Either<Failure, User>> getUser(String id) async {
    _logger.debug('Fetching user: $id');

    try {
      final response = await _client
          .from('users')
          .select()
          .eq('id', id)
          .single();

      _logger.info('✅ User fetched successfully: $id');
      return Right(UserModel.fromJson(response).toDomain());
    } catch (e, stackTrace) {
      _logger.error(
        'Failed to fetch user',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(Failure('Failed to load user'));
    }
  }
}
```

### Notifier Example

```dart
class UserNotifier extends BaseNotifier<User> {
  final _logger = AppLogger.instance;

  Future<void> loadUser(String id) async {
    _logger.debug('Loading user: $id');
    state = const BaseLoading();

    final result = await _repository.getUser(id);

    state = result.fold(
      (failure) {
        _logger.error('Failed to load user: ${failure.message}');
        return BaseError(failure);
      },
      (user) {
        _logger.info('User loaded successfully: ${user.name}');
        return BaseData(user);
      },
    );
  }
}
```

### Navigation Logging

```dart
class AppRouter {
  final _logger = AppLogger.instance;

  void navigateTo(String routeName) {
    _logger.debug('🧭 Navigating to: $routeName');
    context.go(routeName);
  }
}
```

### Network Logging

```dart
class ApiClient {
  final _logger = AppLogger.instance;

  Future<Response> get(String endpoint) async {
    _logger.debug('🌐 GET $endpoint');
    final startTime = DateTime.now();

    try {
      final response = await _dio.get(endpoint);
      final duration = DateTime.now().difference(startTime);

      _logger.info('✅ GET $endpoint completed in ${duration.inMilliseconds}ms');
      return response;
    } catch (e, stackTrace) {
      _logger.error(
        'Failed to GET $endpoint',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }
}
```

## Developer Console Usage

### Opening the Console

**Method 1: Shake Device** (Recommended)
1. Shake your phone 1-2 times quickly
2. Console opens automatically

**Method 2: Manual Button** (Optional)
```dart
// Add debug button in dev/staging
if (EnvInfo.isDevelopment || EnvInfo.isStaging) {
  FloatingActionButton(
    onPressed: () {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => const DeveloperConsoleModal(),
      );
    },
    child: const Icon(Icons.bug_report),
  );
}
```

### Filtering Logs

1. Tap on filter chips at the top
2. Options: ALL, TRACE, DEBUG, INFO, WARNING, ERROR, FATAL
3. Number in parentheses shows count for each level

### Searching Logs

1. Type in the search field
2. Searches through:
   - Log messages
   - Error messages
   - Stack traces

### Viewing Log Details

1. Tap on any log card
2. Dialog opens with full details:
   - Timestamp
   - Level
   - Message
   - Error (if present)
   - Stack trace (if present)
3. Use "Copy" button to copy entire log

### Exporting Logs

1. Tap share icon in header
2. Logs exported to text file
3. Share via system share sheet
4. File includes:
   - All logs (filtered if filter active)
   - Timestamp
   - Environment info
   - Full stack traces

### Clearing Logs

1. Tap delete icon in header
2. Confirmation dialog appears
3. All logs cleared from storage

## Best Practices

### When to Log

✅ **DO log:**
- User authentication events
- Navigation changes (debug level)
- API requests (debug level)
- Successful operations (info level)
- Warnings about deprecated features
- All errors with full context
- Critical failures

❌ **DON'T log:**
- Sensitive user data (passwords, tokens)
- PII without anonymization
- Inside tight loops (performance)
- Redundant information

### Log Messages

**Good Examples:**
```dart
logger.info('✅ User logged in successfully');
logger.debug('🧭 Navigating to profile page');
logger.error('Failed to upload image', error: e, stackTrace: st);
logger.warning('⚠️ API response time: 5s (threshold: 3s)');
```

**Bad Examples:**
```dart
logger.info('success'); // Too vague
logger.debug('user: $user'); // May contain sensitive data
logger.error('error'); // No context
```

### Performance Considerations

1. **Use appropriate log levels**
   - Don't use `trace` everywhere
   - Use `debug` for verbose logging

2. **Avoid logging in loops**
   ```dart
   // ❌ Bad
   for (var item in items) {
     logger.debug('Processing item: $item');
   }

   // ✅ Good
   logger.debug('Processing ${items.length} items');
   ```

3. **Lazy evaluation for expensive operations**
   ```dart
   // ✅ Good
   if (EnvInfo.isDevelopment) {
     logger.trace('Expensive data: ${expensiveOperation()}');
   }
   ```

## Environment-Specific Behavior

### Development
- **Log Level**: TRACE (all logs)
- **Shake Detection**: ✅ Enabled
- **Log Storage**: ✅ Enabled
- **Console Output**: ✅ Full details

### Staging
- **Log Level**: DEBUG
- **Shake Detection**: ✅ Enabled
- **Log Storage**: ✅ Enabled
- **Console Output**: ✅ Full details

### Production
- **Log Level**: WARNING (only warnings and errors)
- **Shake Detection**: ❌ Disabled
- **Log Storage**: ❌ Disabled
- **Console Output**: ⚠️ Minimal

## Integration with Error Handling

### Either Pattern Integration

```dart
final result = await repository.getData();

result.fold(
  (failure) {
    logger.error('Operation failed: ${failure.message}');
    // Handle error
  },
  (data) {
    logger.info('Operation successful');
    // Handle success
  },
);
```

### Global Error Handler

```dart
void main() async {
  // Catch Flutter framework errors
  FlutterError.onError = (details) {
    AppLogger.instance.fatal(
      'Flutter framework error',
      error: details.exception,
      stackTrace: details.stack,
    );
  };

  // Catch async errors
  PlatformDispatcher.instance.onError = (error, stack) {
    AppLogger.instance.fatal(
      'Uncaught async error',
      error: error,
      stackTrace: stack,
    );
    return true;
  };

  runApp(const MyApp());
}
```

## Storage and Limits

- **Maximum logs stored**: 1000
- **Storage location**: SharedPreferences
- **Auto-cleanup**: Oldest logs removed when limit reached
- **Persistence**: Only in dev/staging environments

## Troubleshooting

### Shake Detection Not Working

1. **Check environment**
   ```dart
   print(EnvInfo.environment); // Should be dev or staging
   ```

2. **Check permissions**
   - iOS: Motion sensors automatically available
   - Android: Ensure sensors_plus permissions granted

3. **Adjust sensitivity**
   ```dart
   ShakeDetector.autoStart(
     shakeThresholdGravity: 2.0, // Lower = more sensitive
   )
   ```

### Logs Not Appearing

1. **Check log level**
   ```dart
   // In dev, all levels should work
   logger.trace('Test'); // Should appear
   ```

2. **Check storage**
   ```dart
   final count = await LogStorage().getLogsCount();
   print('Logs stored: $count');
   ```

### Console Not Opening

1. **Verify overlay is added**
   ```dart
   // In main.dart
   DeveloperConsoleOverlay(
     child: MaterialApp(...),
   )
   ```

2. **Check for modal conflicts**
   - Close other modals first
   - Check for z-index issues

## Future Enhancements

Potential improvements:
- [ ] Remote logging (send logs to backend)
- [ ] Log analytics dashboard
- [ ] Performance metrics integration
- [ ] Network request inspector
- [ ] Memory usage tracking
- [ ] Screenshot capture on error
- [ ] Log grouping by feature
- [ ] Log tagging system

## Related Documentation

- [Error Handling](06_ERROR_HANDLING.md) - Either pattern integration
- [Environment Config](03_ENVIRONMENT_CONFIG.md) - Environment setup
- [Troubleshooting](26_TROUBLESHOOTING.md) - Common issues

## Summary

The GlowAI logging system provides a production-ready solution for:
- ✅ Environment-aware logging
- ✅ Shake-to-open developer console
- ✅ Real-time log monitoring
- ✅ Beautiful UI for debugging
- ✅ Log export and sharing
- ✅ Zero performance impact in production

**Remember:**
- Use appropriate log levels
- Include context in error logs
- Don't log sensitive data
- Shake to debug! 🎉

