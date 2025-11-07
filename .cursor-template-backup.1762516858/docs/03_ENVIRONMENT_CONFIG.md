# Environment Configuration

Complete guide to managing multiple environments (development, staging, production) with proper secret management and feature flags.

## Why Multiple Environments?

**Development (dev):**
- Local/test backend
- Verbose logging
- Debug tools enabled
- Rapid iteration

**Staging:**
- Production-like environment
- Real data (anonymized)
- Performance testing
- Pre-release validation

**Production (prod):**
- Live users
- Minimal logging
- Optimized performance
- Strict error handling

## Architecture Overview

```
lib/main/
├── app_environment.dart      # Environment enum & config
├── main_dev.dart            # Development entry
├── main_staging.dart        # Staging entry
└── main_prod.dart           # Production entry
```

## Step 1: Create Environment System

### app_environment.dart

```dart
enum AppEnvironment {
  dev,
  staging,
  prod,
}

class EnvInfo {
  static AppEnvironment _environment = AppEnvironment.dev;
  static Map<String, String> _secrets = {};
  
  /// Initialize environment and load secrets
  static void initialize(
    AppEnvironment environment, {
    Map<String, String>? secrets,
  }) {
    _environment = environment;
    if (secrets != null) {
      _secrets = secrets;
    }
  }
  
  // Environment checks
  static AppEnvironment get environment => _environment;
  static bool get isDevelopment => _environment == AppEnvironment.dev;
  static bool get isStaging => _environment == AppEnvironment.staging;
  static bool get isProduction => _environment == AppEnvironment.prod;
  
  // App configuration
  static String get appTitle {
    return switch (_environment) {
      AppEnvironment.dev => 'MyApp (DEV)',
      AppEnvironment.staging => 'MyApp (STAGING)',
      AppEnvironment.prod => 'MyApp',
    };
  }
  
  static String get appSuffix {
    return switch (_environment) {
      AppEnvironment.dev => '.dev',
      AppEnvironment.staging => '.staging',
      AppEnvironment.prod => '',
    };
  }
  
  // Backend URLs
  static String get apiBaseUrl {
    return _getSecret('API_BASE_URL') ?? _defaultApiUrl;
  }
  
  static String get _defaultApiUrl {
    return switch (_environment) {
      AppEnvironment.dev => 'https://dev-api.example.com',
      AppEnvironment.staging => 'https://staging-api.example.com',
      AppEnvironment.prod => 'https://api.example.com',
    };
  }
  
  // Supabase configuration
  static String get supabaseUrl {
    return _getSecret('SUPABASE_URL') ?? _defaultSupabaseUrl;
  }
  
  static String get _defaultSupabaseUrl {
    return switch (_environment) {
      AppEnvironment.dev => 'https://xxxxx.supabase.co',
      AppEnvironment.staging => 'https://yyyyy.supabase.co',
      AppEnvironment.prod => 'https://zzzzz.supabase.co',
    };
  }
  
  static String get supabaseAnonKey {
    return _getSecret('SUPABASE_ANON_KEY') ?? _defaultSupabaseAnonKey;
  }
  
  static String get _defaultSupabaseAnonKey {
    return switch (_environment) {
      AppEnvironment.dev => 'dev-anon-key-here',
      AppEnvironment.staging => 'staging-anon-key-here',
      AppEnvironment.prod => 'prod-anon-key-here',
    };
  }
  
  // Feature flags
  static bool get enableAnalytics => !isDevelopment;
  static bool get enableCrashReporting => isProduction;
  static bool get showDebugInfo => isDevelopment;
  static bool get enableDetailedLogging => !isProduction;
  
  // Timeouts
  static Duration get apiTimeout {
    return switch (_environment) {
      AppEnvironment.dev => const Duration(seconds: 60),
      AppEnvironment.staging => const Duration(seconds: 30),
      AppEnvironment.prod => const Duration(seconds: 30),
    };
  }
  
  // Secrets helper
  static String? _getSecret(String key) => _secrets[key];
}
```

### Entry Point Files

**lib/main/main_dev.dart:**

```dart
import 'package:flutter/material.dart';
import '../main.dart';
import 'app_environment.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load secrets from environment or secure storage
  final secrets = await _loadSecrets();
  
  EnvInfo.initialize(
    AppEnvironment.dev,
    secrets: secrets,
  );
  
  await mainCommon(AppEnvironment.dev);
}

Future<Map<String, String>> _loadSecrets() async {
  // In development, you might load from local file
  // In production, use more secure methods
  return {
    'API_BASE_URL': 'https://dev-api.example.com',
    'SUPABASE_URL': 'https://xxxxx.supabase.co',
    'SUPABASE_ANON_KEY': 'dev-anon-key',
  };
}
```

**lib/main/main_staging.dart:**

```dart
import 'package:flutter/material.dart';
import '../main.dart';
import 'app_environment.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  EnvInfo.initialize(AppEnvironment.staging);
  await mainCommon(AppEnvironment.staging);
}
```

**lib/main/main_prod.dart:**

```dart
import 'package:flutter/material.dart';
import '../main.dart';
import 'app_environment.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  EnvInfo.initialize(AppEnvironment.prod);
  await mainCommon(AppEnvironment.prod);
}
```

## Step 2: Secret Management

### Option 1: Environment Variables (Development)

Create `.env` files (DO NOT commit to git):

**.env.dev:**
```
API_BASE_URL=https://dev-api.example.com
SUPABASE_URL=https://xxxxx.supabase.co
SUPABASE_ANON_KEY=your-dev-anon-key
```

**.env.staging:**
```
API_BASE_URL=https://staging-api.example.com
SUPABASE_URL=https://yyyyy.supabase.co
SUPABASE_ANON_KEY=your-staging-anon-key
```

**.env.prod:**
```
API_BASE_URL=https://api.example.com
SUPABASE_URL=https://zzzzz.supabase.co
SUPABASE_ANON_KEY=your-prod-anon-key
```

**Add to .gitignore:**
```
.env
.env.*
.env.local
```

### Using flutter_dotenv

```yaml
dependencies:
  flutter_dotenv: ^5.1.0
```

```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env.dev");
  
  final secrets = {
    'API_BASE_URL': dotenv.env['API_BASE_URL']!,
    'SUPABASE_URL': dotenv.env['SUPABASE_URL']!,
    'SUPABASE_ANON_KEY': dotenv.env['SUPABASE_ANON_KEY']!,
  };
  
  EnvInfo.initialize(AppEnvironment.dev, secrets: secrets);
  await mainCommon(AppEnvironment.dev);
}
```

### Option 2: Dart Define (Build-Time)

```bash
# Build with secrets
flutter run \
  --dart-define=API_BASE_URL=https://dev-api.example.com \
  --dart-define=SUPABASE_URL=https://xxxxx.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=your-key
```

**Access in code:**

```dart
class EnvInfo {
  static String get apiBaseUrl {
    return const String.fromEnvironment(
      'API_BASE_URL',
      defaultValue: 'https://dev-api.example.com',
    );
  }
  
  static String get supabaseUrl {
    return const String.fromEnvironment(
      'SUPABASE_URL',
      defaultValue: 'https://xxxxx.supabase.co',
    );
  }
}
```

### Option 3: Config Files (Not Recommended for Secrets)

**assets/config/dev.json:**
```json
{
  "apiBaseUrl": "https://dev-api.example.com",
  "enableLogging": true,
  "apiTimeout": 60
}
```

```dart
Future<Map<String, dynamic>> loadConfig() async {
  final configString = await rootBundle.loadString(
    'assets/config/${EnvInfo.environment.name}.json',
  );
  return json.decode(configString);
}
```

⚠️ **Warning:** Don't store secrets in config files - they're included in the app bundle!

## Step 3: Platform-Specific Configuration

### iOS Configuration

**ios/Runner/Info.plist:**

```xml
<!-- Environment-specific display name -->
<key>CFBundleDisplayName</key>
<string>$(APP_DISPLAY_NAME)</string>

<!-- Environment-specific bundle ID -->
<key>CFBundleIdentifier</key>
<string>$(PRODUCT_BUNDLE_IDENTIFIER)</string>
```

**Create schemes:**

1. Open `ios/Runner.xcworkspace` in Xcode
2. Product → Scheme → Manage Schemes
3. Duplicate Runner scheme, rename to "Runner-Dev"
4. Edit scheme → Build Configuration → Debug
5. Repeat for Staging and Prod

**ios/Flutter/Dev.xcconfig:**
```
#include "Pods/Target Support Files/Pods-Runner/Pods-Runner.dev.xcconfig"
#include "Generated.xcconfig"

APP_DISPLAY_NAME=MyApp (DEV)
PRODUCT_BUNDLE_IDENTIFIER=com.example.myapp.dev
```

**ios/Flutter/Staging.xcconfig:**
```
#include "Pods/Target Support Files/Pods-Runner/Pods-Runner.staging.xcconfig"
#include "Generated.xcconfig"

APP_DISPLAY_NAME=MyApp (STAGING)
PRODUCT_BUNDLE_IDENTIFIER=com.example.myapp.staging
```

**ios/Flutter/Prod.xcconfig:**
```
#include "Pods/Target Support Files/Pods-Runner/Pods-Runner.prod.xcconfig"
#include "Generated.xcconfig"

APP_DISPLAY_NAME=MyApp
PRODUCT_BUNDLE_IDENTIFIER=com.example.myapp
```

### Android Configuration

**android/app/build.gradle:**

```gradle
android {
    // ... existing config
    
    flavorDimensions "environment"
    
    productFlavors {
        dev {
            dimension "environment"
            applicationIdSuffix ".dev"
            versionNameSuffix "-dev"
            resValue "string", "app_name", "MyApp (DEV)"
        }
        
        staging {
            dimension "environment"
            applicationIdSuffix ".staging"
            versionNameSuffix "-staging"
            resValue "string", "app_name", "MyApp (STAGING)"
        }
        
        prod {
            dimension "environment"
            resValue "string", "app_name", "MyApp"
        }
    }
    
    buildTypes {
        debug {
            // Debug config
            debuggable true
        }
        
        release {
            // Release config
            minifyEnabled true
            shrinkResources true
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
            
            // Signing configs per flavor
            signingConfig signingConfigs.release
        }
    }
}
```

**android/app/src/main/AndroidManifest.xml:**

```xml
<application
    android:label="@string/app_name"
    android:icon="@mipmap/ic_launcher">
    <!-- ... -->
</application>
```

## Step 4: Feature Flags

### Simple Feature Flags

```dart
class FeatureFlags {
  // Remote config features
  static bool get enableNewDashboard {
    return EnvInfo.isDevelopment || _remoteConfig['new_dashboard'] == true;
  }
  
  // A/B test features
  static bool get enableExperimentalUI {
    return EnvInfo.isDevelopment;
  }
  
  // Staged rollout
  static bool get enableBetaFeatures {
    return !EnvInfo.isProduction;
  }
  
  // Debug features
  static bool get showPerformanceOverlay {
    return EnvInfo.isDevelopment;
  }
  
  // Platform-specific
  static bool get enablePlatformFeature {
    return Platform.isIOS && EnvInfo.isProduction;
  }
}
```

### Using Feature Flags

```dart
Widget build(BuildContext context) {
  return Scaffold(
    body: FeatureFlags.enableNewDashboard
        ? NewDashboard()
        : LegacyDashboard(),
  );
}
```

### Advanced: Firebase Remote Config

```yaml
dependencies:
  firebase_remote_config: ^5.1.3
```

```dart
class RemoteConfigService {
  final FirebaseRemoteConfig _remoteConfig;
  
  RemoteConfigService(this._remoteConfig);
  
  Future<void> initialize() async {
    await _remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: EnvInfo.isDevelopment
            ? const Duration(minutes: 5)
            : const Duration(hours: 1),
      ),
    );
    
    // Set defaults
    await _remoteConfig.setDefaults({
      'enable_new_feature': false,
      'api_timeout_seconds': 30,
      'max_retry_attempts': 3,
    });
    
    await _remoteConfig.fetchAndActivate();
  }
  
  bool getBool(String key) => _remoteConfig.getBool(key);
  int getInt(String key) => _remoteConfig.getInt(key);
  String getString(String key) => _remoteConfig.getString(key);
}
```

## Step 5: Logging Configuration

### Environment-Specific Logging

```dart
import 'package:loggy/loggy.dart';

void setupLogging() {
  Loggy.initLoggy(
    logPrinter: EnvInfo.enableDetailedLogging
        ? PrettyPrinter()
        : ProductionPrinter(),
    logOptions: LogOptions(
      EnvInfo.isDevelopment
          ? LogLevel.all
          : LogLevel.warning,
    ),
  );
}

class ProductionPrinter extends LoggyPrinter {
  @override
  void onLog(LogRecord record) {
    // Send to crash reporting service
    if (record.level >= LogLevel.error) {
      _sendToCrashReporting(record);
    }
  }
}
```

### Usage

```dart
class UserRepository with UiLoggy {
  Future<User> getUser() async {
    loggy.debug('Fetching user data');
    
    try {
      final user = await _api.getUser();
      loggy.info('User fetched successfully: ${user.id}');
      return user;
    } catch (e) {
      loggy.error('Failed to fetch user', e);
      rethrow;
    }
  }
}
```

## Step 6: Running Different Environments

### Command Line

```bash
# Development
flutter run \
  --flavor dev \
  --target lib/main/main_dev.dart

# Staging
flutter run \
  --flavor staging \
  --target lib/main/main_staging.dart

# Production
flutter run \
  --flavor prod \
  --target lib/main/main_prod.dart
```

### VS Code Launch Configurations

**.vscode/launch.json:**

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Development",
      "request": "launch",
      "type": "dart",
      "program": "lib/main/main_dev.dart",
      "args": [
        "--flavor",
        "dev"
      ]
    },
    {
      "name": "Staging",
      "request": "launch",
      "type": "dart",
      "program": "lib/main/main_staging.dart",
      "args": [
        "--flavor",
        "staging"
      ]
    },
    {
      "name": "Production",
      "request": "launch",
      "type": "dart",
      "program": "lib/main/main_prod.dart",
      "args": [
        "--flavor",
        "prod"
      ]
    }
  ]
}
```

### Build Scripts

**Makefile:**

```makefile
run-dev:
	flutter run --flavor dev --target lib/main/main_dev.dart

run-staging:
	flutter run --flavor staging --target lib/main/main_staging.dart

run-prod:
	flutter run --flavor prod --target lib/main/main_prod.dart

build-dev-android:
	flutter build apk --flavor dev --target lib/main/main_dev.dart

build-prod-android:
	flutter build apk --flavor prod --target lib/main/main_prod.dart --release

build-prod-ios:
	flutter build ios --flavor prod --target lib/main/main_prod.dart --release
```

## Step 7: CI/CD Integration

### GitHub Actions

**.github/workflows/build.yml:**

```yaml
name: Build and Test

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main, develop]

jobs:
  build:
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v3
      
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.16.0'
      
      - name: Install dependencies
        run: flutter pub get
      
      - name: Run tests
        run: flutter test
      
      - name: Build Dev APK
        run: flutter build apk --flavor dev --target lib/main/main_dev.dart
        env:
          API_BASE_URL: ${{ secrets.DEV_API_URL }}
          SUPABASE_URL: ${{ secrets.DEV_SUPABASE_URL }}
          SUPABASE_ANON_KEY: ${{ secrets.DEV_SUPABASE_KEY }}
      
      - name: Build Prod APK
        if: github.ref == 'refs/heads/main'
        run: flutter build apk --flavor prod --target lib/main/main_prod.dart --release
        env:
          API_BASE_URL: ${{ secrets.PROD_API_URL }}
          SUPABASE_URL: ${{ secrets.PROD_SUPABASE_URL }}
          SUPABASE_ANON_KEY: ${{ secrets.PROD_SUPABASE_KEY }}
```

## Best Practices

### ✅ Do

- **Use environment-specific configurations**
- **Never commit secrets to version control**
- **Use feature flags for gradual rollouts**
- **Test in staging before production**
- **Log appropriately per environment**
- **Use different app icons per environment**
- **Separate analytics per environment**

### ❌ Don't

- **Don't hardcode API keys in code**
- **Don't use same database for all environments**
- **Don't skip staging environment**
- **Don't enable debug logging in production**
- **Don't use production secrets in development**

## Security Checklist

- [ ] Secrets not in version control
- [ ] `.env` files in `.gitignore`
- [ ] Production keys never in development
- [ ] API keys rotated regularly
- [ ] Certificate pinning for production
- [ ] Obfuscation enabled for production builds
- [ ] Secure storage for sensitive data
- [ ] Environment verification on app start

## Troubleshooting

### Issue: Wrong environment loaded

```dart
// Add verification on app start
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  EnvInfo.initialize(AppEnvironment.prod);
  
  // Verify environment
  assert(
    EnvInfo.isProduction,
    'Expected production environment!',
  );
  
  runApp(MyApp());
}
```

### Issue: Secrets not loading

```dart
// Add error handling
Future<Map<String, String>> loadSecrets() async {
  try {
    await dotenv.load(fileName: ".env.${EnvInfo.environment.name}");
    return dotenv.env;
  } catch (e) {
    // Fall back to defaults or throw
    if (EnvInfo.isProduction) {
      throw Exception('Failed to load production secrets');
    }
    return {}; // Use defaults in dev
  }
}
```

## Next Steps

- **Architecture:** Study [04_CLEAN_ARCHITECTURE.md](04_CLEAN_ARCHITECTURE.md)
- **State Management:** Learn [05_STATE_MANAGEMENT.md](05_STATE_MANAGEMENT.md)
- **Navigation:** Setup [08_NAVIGATION_SYSTEM.md](08_NAVIGATION_SYSTEM.md)

---

**Your app is now ready for multi-environment deployment!**

