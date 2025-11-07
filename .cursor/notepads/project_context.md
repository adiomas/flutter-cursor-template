# Project Context - GlowAI

> **Use @project_context.md when starting new feature or need project overview**

## Project Overview

**Type**: Smart photo editor powered by AI. Create perfect portraits in seconds.  
**Platform**: Flutter (iOS & Android)  
**Backend**: Supabase  
**State Management**: Riverpod + BaseNotifier pattern  
**Navigation**: go_router  
**Error Handling**: either_dart (Either pattern)

## Tech Stack

```yaml
Flutter: 3.16.0+
Dart: 3.0+

Core Packages:
  - hooks_riverpod: State management
  - flutter_hooks: Lifecycle management
  - go_router: Navigation
  - either_dart: Error handling
  - supabase_flutter: Backend
  - q_architecture: BaseNotifier pattern
  - json_annotation: JSON serialization
  - equatable: Value equality

Dev Dependencies:
  - json_serializable: Code generation
  - build_runner: Code generation runner
  - flutter_lints: Linting
```

## Project Structure

```
lib/
├── common/              # Shared across features
│   ├── constants/       # App-wide constants
│   ├── domain/          # Shared business logic
│   ├── presentation/    # Reusable widgets
│   └── utils/           # Helper functions
│
├── features/            # Feature modules (feature-first)
│   └── feature_name/
│       ├── data/        # Data layer
│       │   ├── models/      # Supabase JSON models
│       │   └── repositories/ # Data access
│       ├── domain/      # Domain layer
│       │   ├── entities/     # Business entities
│       │   └── notifiers/    # State management
│       └── presentation/ # Presentation layer
│           ├── pages/        # Screens
│           └── widgets/      # Feature widgets
│
├── theme/               # Design system
│   ├── app_colors.dart
│   ├── app_text_styles.dart
│   ├── decorator.dart
│   └── shadows.dart
│
└── main.dart            # App entry point
```

## Existing Features

[]

## Architecture Patterns

### Data Layer
- Models with `@JsonSerializable()`
- Repository pattern
- Either for error handling
- Supabase client injection

### Domain Layer
- Entities with `Equatable`
- BaseNotifier for state
- Business logic encapsulation

### Presentation Layer
- HookConsumerWidget
- useEffect for loading
- Switch expressions for states
- Design system usage

## Design System

### Colors
```dart
context.appColors.primary       // Primary brand color
context.appColors.secondary     // Secondary color
context.appColors.background    // Main background
context.appColors.contentBackground // Content areas
context.appColors.error         // Error states
context.appColors.success       // Success states
```

### Typography
```dart
context.textStyles.displayLarge  // Largest headlines
context.textStyles.titleLarge    // Page titles
context.textStyles.bodyLarge     // Body text
context.textStyles.bodyMedium    // Regular body
context.textStyles.labelSmall    // Small labels
```

### Spacing
```dart
const EdgeInsets.all(16)    // Standard padding
const SizedBox(height: 24)  // Vertical spacing
const Gap(16)               // Using gap package
```

## State Management Pattern

```dart
// Notifier
final featureNotifierProvider = 
  NotifierProvider<FeatureNotifier, BaseState<Data>>(
    () => FeatureNotifier(),
  );

class FeatureNotifier extends BaseNotifier<Data> {
  late FeatureRepository _repository;
  
  @override
  void prepareForBuild() {
    _repository = ref.watch(featureRepositoryProvider);
  }
  
  Future<void> load() async {
    state = const BaseLoading();
    final result = await _repository.getData();
    state = result.fold(
      (failure) => BaseError(failure),
      (data) => BaseData(data),
    );
  }
}

// Page
class FeaturePage extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(featureNotifierProvider);
    
    useEffect(() {
      Future.microtask(() {
        ref.read(featureNotifierProvider.notifier).load();
      });
      return null;
    }, const []);
    
    return switch (state) {
      BaseLoading() => const LoadingShimmer(),
      BaseData(:final data) => ContentWidget(data),
      BaseError(:final failure) => ErrorView(failure),
      _ => const SizedBox.shrink(),
    };
  }
}
```

## Error Handling

All async operations return `Either<Failure, Success>`:

```dart
// Repository
Future<Either<Failure, Entity>> getData() async {
  try {
    final response = await _client.from('table').select();
    return Right(Model.fromJson(response).toDomain());
  } catch (e) {
    return Left(Failure('Croatian user message'));
  }
}

// Usage
final result = await repository.getData();
result.fold(
  (failure) => showError(failure.message),
  (entity) => showSuccess(entity),
);
```

## Navigation

Using go_router with declarative routes:

```dart
GoRoute(
  path: '/feature',
  name: FeaturePage.routeName,
  builder: (context, state) => const FeaturePage(),
),
GoRoute(
  path: '/feature/:id',
  name: FeatureDetailsPage.routeName,
  builder: (context, state) {
    final id = state.pathParameters['id']!;
    return FeatureDetailsPage(id: id);
  },
),
```

## Environment Configuration

```dart
enum Environment { dev, staging, prod }

class Config {
  static Environment environment = Environment.dev;
  
  static String get supabaseUrl => switch (environment) {
    Environment.dev => 'dev_url',
    Environment.staging => 'staging_url',
    Environment.prod => 'prod_url',
  };
}
```

## Testing Strategy

- **Unit tests**: Repositories, notifiers, entities
- **Widget tests**: Complex widgets, pages
- **Integration tests**: Critical user flows

## Language

All user-facing text must be in English:
- Error messages
- Button labels
- Placeholders
- Validation messages

## Performance Standards

- **Load time**: Sub-second
- **FPS**: 60 minimum
- **Memory**: Optimized
- **Bundle size**: Minimal

## Accessibility

- WCAG 2.1 AA compliant
- Screen reader support
- Touch targets ≥44x44
- Color contrast ratios

## Development Workflow

1. Create feature branch
2. Implement using templates
3. Follow clean architecture
4. Apply design system
5. Add error handling & states
6. Test thoroughly
7. Create PR

## Deployment

- **iOS**: TestFlight via deploy_ios.sh
- **Android**: Google Play Console
- **CI/CD**: Automated via GitHub Actions

## Documentation

All patterns, standards, and guides are in `docs/` folder. AI automatically references them.

---

**Last Updated**: November 2025  
**Maintainer**: AI-Powered Development Framework

# Test edit
Test line 1762517751
# Test Fri Nov  7 13:23:52 CET 2025
