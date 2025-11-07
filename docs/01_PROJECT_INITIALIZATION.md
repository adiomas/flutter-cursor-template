# Project Initialization

Complete guide to setting up a new Flutter project with professional tooling, structure, and workflow.

## Prerequisites

### Required Tools

**Flutter SDK:**
```bash
# Install Flutter (macOS/Linux)
git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PATH:`pwd`/flutter/bin"

# Verify installation
flutter doctor -v
```

**Minimum versions:**
- Flutter: 3.16.0+
- Dart: 3.2.0+
- Xcode: 15.0+ (for iOS)
- Android Studio: 2023.1+ (for Android)

**Additional Tools:**
```bash
# Fastlane (for deployment automation)
sudo gem install fastlane

# CocoaPods (for iOS dependencies)
sudo gem install cocoapods

# FVM (Flutter Version Management) - Optional but recommended
dart pub global activate fvm
```

## Step 1: Create New Project

### Using Flutter CLI

```bash
# Create project with organization ID
flutter create \
  --org com.yourcompany \
  --project-name your_app_name \
  --platforms ios,android,web \
  --description "Your app description" \
  your_app_name

cd your_app_name
```

### Initial File Structure

After creation, you should have:

```
your_app_name/
├── android/
├── ios/
├── lib/
│   └── main.dart
├── test/
├── pubspec.yaml
├── analysis_options.yaml
└── README.md
```

## Step 2: Configure Git Repository

### Initialize Git

```bash
# Initialize repository
git init

# Create comprehensive .gitignore
cat > .gitignore << 'EOF'
# Flutter
.dart_tool/
.flutter-plugins
.flutter-plugins-dependencies
.packages
.pub-cache/
.pub/
build/
*.lock

# iOS
ios/Pods/
ios/.symlinks/
ios/Flutter/Flutter.framework
ios/Flutter/Flutter.podspec
.DS_Store

# Android
android/.gradle
android/captures/
android/local.properties
*.jks
key.properties

# IDE
.idea/
.vscode/
*.iml
*.ipr
*.iws

# Environment
.env
.env.local
.env.*.local

# Coverage
coverage/
*.lcov

# Build artifacts
*.aab
*.apk
*.ipa

# Miscellaneous
*.log
*.pyc
*.swp
.metadata
EOF

# Initial commit
git add .
git commit -m "Initial project setup"
```

### Git Workflow Strategy

**Branch Strategy:**

```bash
main          # Production releases
├── develop   # Development integration
│   ├── feature/user-authentication
│   ├── feature/dashboard
│   └── hotfix/critical-bug
```

**Commit Convention:**

```
feat: Add user authentication
fix: Resolve login validation issue
docs: Update API documentation
style: Format code with dartfmt
refactor: Simplify data repository
test: Add unit tests for auth service
chore: Update dependencies
```

## Step 3: Project Structure Setup

### Create Feature-First Architecture

```bash
# Create directory structure
mkdir -p lib/{common,features,main,theme,generated,l10n}
mkdir -p lib/common/{constants,data,domain,presentation,utils}
mkdir -p lib/common/data/{models,repositories,services}
mkdir -p lib/common/domain/{entities,notifiers,providers,router}
mkdir -p lib/common/presentation/{widgets,mixins}
mkdir -p lib/features/auth/{data,domain,presentation}
mkdir -p lib/features/auth/data/{models,repositories}
mkdir -p lib/features/auth/domain/{entities,notifiers}
mkdir -p lib/features/auth/presentation/{pages,widgets}
mkdir -p test/{unit,widget,integration}
```

### Final Structure

```
lib/
├── common/
│   ├── constants/           # App-wide constants
│   ├── data/               # Shared data layer
│   │   ├── models/        # API response models
│   │   ├── repositories/  # Data repositories
│   │   └── services/      # External services
│   ├── domain/             # Shared business logic
│   │   ├── entities/      # Business entities
│   │   ├── notifiers/     # Global state notifiers
│   │   ├── providers/     # Dependency injection
│   │   └── router/        # Navigation setup
│   ├── presentation/       # Reusable UI
│   │   ├── widgets/       # Common widgets
│   │   └── mixins/        # Widget mixins
│   └── utils/             # Helper functions
├── features/               # Feature modules
│   └── auth/              # Authentication feature
│       ├── data/          # Auth data layer
│       ├── domain/        # Auth business logic
│       └── presentation/  # Auth UI
├── generated/             # Generated code (l10n, etc.)
├── l10n/                  # Translation files
├── main/                  # Environment configs
│   ├── main_dev.dart
│   ├── main_staging.dart
│   └── main_prod.dart
├── theme/                 # App theming
└── main.dart              # App entry point
```

## Step 4: Configure pubspec.yaml

### Essential Dependencies

```yaml
name: your_app_name
description: Your app description
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: ">=3.2.0 <4.0.0"

dependencies:
  flutter:
    sdk: flutter
  
  # State Management
  hooks_riverpod: ^2.5.2
  flutter_hooks: ^0.20.5
  
  # Routing
  go_router: ^14.2.3
  
  # Backend
  supabase_flutter: ^2.6.0
  
  # Utilities
  either_dart: ^1.0.0
  equatable: ^2.0.5
  
  # Architecture
  q_architecture: ^1.0.1
  
  # UI
  flutter_svg: ^2.0.10
  google_fonts: ^6.2.1
  flutter_animate: ^3.0.0
  
  # Localization
  intl: ^0.19.0
  flutter_localizations:
    sdk: flutter
  
  # Forms
  flutter_form_builder: ^9.4.1
  form_builder_validators: ^11.0.0
  
  # Storage
  shared_preferences: ^2.2.2
  
  # HTTP
  dio: ^5.6.0
  
  # Logging
  loggy: ^2.0.3
  flutter_loggy: ^2.0.3

dev_dependencies:
  flutter_test:
    sdk: flutter
  
  # Linting
  flutter_lints: ^4.0.0
  custom_lint: ^0.6.4
  riverpod_lint: ^2.3.10
  
  # Code Generation
  build_runner: ^2.4.12
  json_serializable: ^6.8.0
  
  # Testing
  mocktail: ^1.0.4
  
  # Tools
  intl_utils: ^2.8.7
  flutter_launcher_icons: ^0.14.1
  flutter_native_splash: ^2.4.3

flutter:
  uses-material-design: true
  generate: true
  
  assets:
    - assets/images/
    - assets/icons/
  
  fonts:
    - family: Roboto
      fonts:
        - asset: assets/fonts/Roboto-Regular.ttf
        - asset: assets/fonts/Roboto-Bold.ttf
          weight: 700
```

### Install Dependencies

```bash
flutter pub get
```

## Step 5: Configure Analysis Options

### Create analysis_options.yaml

```yaml
include: package:flutter_lints/flutter.yaml

analyzer:
  exclude:
    - "**/*.g.dart"
    - "**/*.freezed.dart"
    - "**/generated/**"
  
  errors:
    invalid_annotation_target: ignore
    missing_required_param: error
    missing_return: error
    todo: ignore
  
  language:
    strict-casts: true
    strict-raw-types: true

linter:
  rules:
    # Error Rules
    avoid_dynamic_calls: true
    avoid_empty_else: true
    avoid_relative_lib_imports: true
    avoid_slow_async_io: true
    avoid_type_to_string: true
    cancel_subscriptions: true
    close_sinks: true
    literal_only_boolean_expressions: true
    no_adjacent_strings_in_list: true
    test_types_in_equals: true
    throw_in_finally: true
    unnecessary_statements: true
    
    # Style Rules
    always_declare_return_types: true
    always_put_required_named_parameters_first: true
    always_use_package_imports: true
    annotate_overrides: true
    avoid_bool_literals_in_conditional_expressions: true
    avoid_catching_errors: true
    avoid_escaping_inner_quotes: true
    avoid_multiple_declarations_per_line: true
    avoid_positional_boolean_parameters: true
    avoid_redundant_argument_values: true
    avoid_returning_null_for_void: true
    avoid_types_on_closure_parameters: true
    avoid_unnecessary_containers: true
    cascade_invocations: true
    constant_identifier_names: true
    curly_braces_in_flow_control_structures: true
    file_names: true
    leading_newlines_in_multiline_strings: true
    library_private_types_in_public_api: true
    lines_longer_than_80_chars: false
    no_runtimeType_toString: true
    noop_primitive_operations: true
    only_throw_errors: true
    overridden_fields: true
    prefer_adjacent_string_concatenation: true
    prefer_asserts_in_initializer_lists: true
    prefer_collection_literals: true
    prefer_conditional_assignment: true
    prefer_const_constructors: true
    prefer_const_constructors_in_immutables: true
    prefer_const_declarations: true
    prefer_const_literals_to_create_immutables: true
    prefer_final_fields: true
    prefer_final_in_for_each: true
    prefer_final_locals: true
    prefer_for_elements_to_map_fromIterable: true
    prefer_if_elements_to_conditional_expressions: true
    prefer_if_null_operators: true
    prefer_interpolation_to_compose_strings: true
    prefer_is_empty: true
    prefer_is_not_empty: true
    prefer_is_not_operator: true
    prefer_null_aware_method_calls: true
    prefer_single_quotes: true
    prefer_spread_collections: true
    require_trailing_commas: true
    sized_box_for_whitespace: true
    sort_child_properties_last: true
    sort_constructors_first: true
    unawaited_futures: true
    unnecessary_await_in_return: true
    unnecessary_late: true
    unnecessary_null_checks: true
    unnecessary_overrides: true
    unnecessary_parenthesis: true
    unnecessary_raw_strings: true
    unnecessary_string_escapes: true
    unnecessary_string_interpolations: true
    use_build_context_synchronously: true
    use_colored_box: true
    use_decorated_box: true
    use_enums: true
    use_full_hex_values_for_flutter_colors: true
    use_function_type_syntax_for_parameters: true
    use_if_null_to_convert_nulls_to_bools: true
    use_is_even_rather_than_modulo: true
    use_late_for_private_fields_and_variables: true
    use_named_constants: true
    use_raw_strings: true
    use_string_buffers: true
    use_super_parameters: true
    use_test_throws_matchers: true
    use_to_and_as_if_applicable: true

custom_lint:
  rules:
    - avoid_dynamic_calls
```

## Step 6: Setup Main Entry Points

### Create Environment Configuration

**lib/main/app_environment.dart:**

```dart
enum AppEnvironment {
  dev,
  staging,
  prod,
}

class EnvInfo {
  static AppEnvironment _environment = AppEnvironment.dev;
  
  static void initialize(AppEnvironment environment) {
    _environment = environment;
  }
  
  static AppEnvironment get environment => _environment;
  
  static bool get isDevelopment => _environment == AppEnvironment.dev;
  static bool get isStaging => _environment == AppEnvironment.staging;
  static bool get isProduction => _environment == AppEnvironment.prod;
  
  static String get appTitle {
    return switch (_environment) {
      AppEnvironment.dev => 'App (DEV)',
      AppEnvironment.staging => 'App (STAGING)',
      AppEnvironment.prod => 'App',
    };
  }
  
  static String get supabaseUrl {
    return switch (_environment) {
      AppEnvironment.dev => 'https://your-dev-project.supabase.co',
      AppEnvironment.staging => 'https://your-staging-project.supabase.co',
      AppEnvironment.prod => 'https://your-prod-project.supabase.co',
    };
  }
  
  static String get supabaseAnonKey {
    return switch (_environment) {
      AppEnvironment.dev => 'your-dev-anon-key',
      AppEnvironment.staging => 'your-staging-anon-key',
      AppEnvironment.prod => 'your-prod-anon-key',
    };
  }
}
```

### Create Environment Entry Points

**lib/main/main_dev.dart:**

```dart
import 'package:flutter/material.dart';
import '../main.dart';
import 'app_environment.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await mainCommon(AppEnvironment.dev);
}
```

**lib/main/main_staging.dart:**

```dart
import 'package:flutter/material.dart';
import '../main.dart';
import 'app_environment.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
  await mainCommon(AppEnvironment.prod);
}
```

### Main Application

**lib/main.dart:**

```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'main/app_environment.dart';

Future<void> mainCommon(AppEnvironment environment) async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // System UI configuration
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  
  // Initialize environment
  EnvInfo.initialize(environment);
  
  // Initialize Supabase
  await Supabase.initialize(
    url: EnvInfo.supabaseUrl,
    anonKey: EnvInfo.supabaseAnonKey,
  );
  
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: EnvInfo.appTitle,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('hr', ''),
      ],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const Scaffold(
        body: Center(
          child: Text('Welcome to Elite Flutter App'),
        ),
      ),
    );
  }
}
```

## Step 7: Run and Verify

### Run Development Build

```bash
# iOS
flutter run --flavor dev --target lib/main/main_dev.dart

# Android
flutter run --flavor dev --target lib/main/main_dev.dart

# Web
flutter run -d chrome --target lib/main/main_dev.dart
```

### Verify Setup

```bash
# Run static analysis
flutter analyze

# Run tests
flutter test

# Check formatting
dart format --set-exit-if-changed .

# Check for outdated dependencies
flutter pub outdated
```

## Step 8: IDE Configuration

### VS Code Settings

**.vscode/settings.json:**

```json
{
  "editor.formatOnSave": true,
  "editor.codeActionsOnSave": {
    "source.fixAll": true,
    "source.organizeImports": true
  },
  "dart.lineLength": 100,
  "dart.flutterSdkPath": "/path/to/flutter",
  "[dart]": {
    "editor.rulers": [100],
    "editor.tabSize": 2,
    "editor.defaultFormatter": "Dart-Code.dart-code"
  }
}
```

**.vscode/launch.json:**

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Development",
      "request": "launch",
      "type": "dart",
      "program": "lib/main/main_dev.dart"
    },
    {
      "name": "Staging",
      "request": "launch",
      "type": "dart",
      "program": "lib/main/main_staging.dart"
    },
    {
      "name": "Production",
      "request": "launch",
      "type": "dart",
      "program": "lib/main/main_prod.dart"
    }
  ]
}
```

## Step 9: Additional Setup Files

### README.md

```markdown
# Your App Name

Description of your application.

## Getting Started

### Prerequisites
- Flutter 3.16.0+
- Dart 3.2.0+

### Installation
1. Clone the repository
2. Run `flutter pub get`
3. Run `flutter run --flavor dev --target lib/main/main_dev.dart`

### Build Variants
- **Development:** `--flavor dev --target lib/main/main_dev.dart`
- **Staging:** `--flavor staging --target lib/main/main_staging.dart`
- **Production:** `--flavor prod --target lib/main/main_prod.dart`

## Project Structure
See [Architecture Documentation](docs/04_CLEAN_ARCHITECTURE.md)

## Contributing
See [Contributing Guidelines](CONTRIBUTING.md)
```

### Makefile (Optional but Recommended)

```makefile
.PHONY: help

help:
	@echo "Available commands:"
	@echo "  make run-dev        - Run app in development mode"
	@echo "  make run-staging    - Run app in staging mode"
	@echo "  make run-prod       - Run app in production mode"
	@echo "  make test           - Run all tests"
	@echo "  make analyze        - Run static analysis"
	@echo "  make format         - Format code"
	@echo "  make clean          - Clean build artifacts"

run-dev:
	flutter run --flavor dev --target lib/main/main_dev.dart

run-staging:
	flutter run --flavor staging --target lib/main/main_staging.dart

run-prod:
	flutter run --flavor prod --target lib/main/main_prod.dart

test:
	flutter test

analyze:
	flutter analyze

format:
	dart format .

clean:
	flutter clean
	flutter pub get

build-ios:
	flutter build ios --flavor prod --target lib/main/main_prod.dart

build-android:
	flutter build apk --flavor prod --target lib/main/main_prod.dart
```

## Checklist

Before proceeding to development:

- [ ] Flutter SDK installed and verified (`flutter doctor`)
- [ ] Project created with proper organization ID
- [ ] Git repository initialized with .gitignore
- [ ] Feature-first folder structure created
- [ ] Dependencies added to pubspec.yaml
- [ ] Analysis options configured
- [ ] Environment configurations setup
- [ ] Main entry points created
- [ ] IDE configured (VS Code/Android Studio)
- [ ] Can run app in all environments
- [ ] Static analysis passes (`flutter analyze`)
- [ ] README.md updated with project info

## Next Steps

- **Architecture:** Read [04_CLEAN_ARCHITECTURE.md](04_CLEAN_ARCHITECTURE.md)
- **State Management:** Setup in [05_STATE_MANAGEMENT.md](05_STATE_MANAGEMENT.md)
- **Navigation:** Configure in [08_NAVIGATION_SYSTEM.md](08_NAVIGATION_SYSTEM.md)
- **Theme:** Design in [11_DESIGN_SYSTEM.md](11_DESIGN_SYSTEM.md)

---

**Your project is now ready for elite development!**

