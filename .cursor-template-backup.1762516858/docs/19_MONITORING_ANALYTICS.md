# Monitoring & Analytics

Track app performance and user behavior with Firebase and Sentry.

## Firebase Analytics

```yaml
dependencies:
  firebase_core: ^3.6.0
  firebase_analytics: ^11.3.3
```

```dart
// Initialize
await Firebase.initializeApp();

// Log events
FirebaseAnalytics.instance.logEvent(
  name: 'user_action',
  parameters: {
    'action_type': 'button_click',
    'screen': 'home',
  },
);

// Set user properties
FirebaseAnalytics.instance.setUserProperty(
  name: 'user_type',
  value: 'premium',
);

// Set current screen
FirebaseAnalytics.instance.logScreenView(
  screenName: 'HomeScreen',
);
```

## Firebase Crashlytics

```yaml
dependencies:
  firebase_crashlytics: ^4.1.3
```

```dart
// Initialize
FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

// Log custom errors
try {
  // Code
} catch (e, stack) {
  FirebaseCrashlytics.instance.recordError(e, stack);
}

// Add custom keys
FirebaseCrashlytics.instance.setCustomKey('user_id', userId);
```

## Sentry

```yaml
dependencies:
  sentry_flutter: ^8.9.0
```

```dart
Future<void> main() async {
  await SentryFlutter.init(
    (options) {
      options.dsn = 'your-sentry-dsn';
      options.tracesSampleRate = 1.0;
    },
    appRunner: () => runApp(MyApp()),
  );
}

// Log custom events
Sentry.captureMessage('User action performed');

// Log errors
try {
  // Code
} catch (e, stack) {
  Sentry.captureException(e, stackTrace: stack);
}
```

---

**Your app is now monitored and tracked!**

