---
description: Flutter feature implementation with complete CRUD
globs:
  - lib/features/**/*.dart
alwaysApply: false
---

# Flutter Feature Implementation Rules

## Context7 Auto-Load

When this rule applies, automatically load:
```
@Docs Flutter StatefulWidget patterns
@Docs Flutter performance best practices
@Docs Flutter hooks lifecycle
```

For specific widgets, load dynamically:
```
if (uses ListView) → @Docs Flutter ListView.builder
if (uses Forms) → @Docs Flutter Form validation
if (uses Navigation) → @Docs Flutter navigation
```

---

This rule applies when working within `lib/features/` directory.

## Auto-Apply Standards

When creating or modifying files in features:

1. **Data Layer** (`data/`)
   - Models must use `@JsonSerializable()`
   - Repository must return `Either<Failure, T>`
   - Include `toDomain()` method in models
   
2. **Domain Layer** (`domain/`)
   - Entities must extend `Equatable`
   - Notifiers must extend `BaseNotifier<T>`
   - Use `prepareForBuild()` for repository init

3. **Presentation Layer** (`presentation/`)
   - Pages must use `HookConsumerWidget`
   - Use `useEffect` for data loading
   - Pattern match with `switch` expressions
   - Handle all states: Loading/Data/Error/Initial

## Automatic Imports

```dart
// Always include these when creating feature files:

// For Models
import 'package:json_annotation/json_annotation.dart';

// For Repositories
import 'package:either_dart/either_dart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// For Notifiers
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:q_architecture/base_notifier.dart';

// For Pages
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
```

## Design System Usage

```dart
// Colors (NEVER hardcode)
context.appColors.primary
context.appColors.secondary
context.appColors.background

// Text Styles (NEVER hardcode)
context.textStyles.titleLarge
context.textStyles.bodyMedium

// Spacing (use constants)
const EdgeInsets.all(16)
const SizedBox(height: 24)
```

## Error Messages

Must be user-friendly Croatian:

```dart
// ❌ BAD
"Exception: null check operator"

// ✅ GOOD
"Došlo je do greške pri učitavanju podataka. Molimo pokušajte ponovo."
```

## Loading States

Always include:

```dart
switch (state) {
  BaseLoading() => const LoadingShimmer(),
  BaseData(:final data) => ContentWidget(data),
  BaseError(:final failure) => ErrorView(
    message: failure.message,
    onRetry: () => ref.read(notifierProvider.notifier).load(),
  ),
  _ => const SizedBox.shrink(),
}
```

## Quality Checklist

Before completing, verify:
- [ ] All layers created (data/domain/presentation)
- [ ] BaseNotifier with BaseState used
- [ ] Either pattern for errors
- [ ] Loading/error/empty states
- [ ] Design system applied (no hardcoded values)
- [ ] User-friendly error messages in Croatian
- [ ] Const constructors used
- [ ] Null safety handled

@docs/07_FEATURE_TEMPLATE.md
@docs/templates/repository_template.dart
@docs/templates/notifier_template.dart
@docs/templates/page_template.dart

