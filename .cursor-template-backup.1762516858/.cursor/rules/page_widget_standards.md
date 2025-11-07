---
description: Page widget implementation standards - ensures clean architecture and prevents anti-patterns
globs:
  - lib/features/**/presentation/pages/*.dart
alwaysApply: true
---

# Page Widget Standards

## CRITICAL RULES

### Size Limits (Non-Negotiable)

- **Page widget maximum: 300 lines**
- **Single method maximum: 50 lines**
- **If exceeded → MUST extract to service/widget/helper**

### Responsibility Separation (Non-Negotiable)

**Page widgets MUST ONLY:**
- ✅ Watch state from notifiers
- ✅ Call notifier methods
- ✅ Show UI based on state
- ✅ Handle user interactions (delegate to notifiers/services)

**Page widgets MUST NOT:**
- ❌ Contain business logic
- ❌ Handle external operations directly (ImagePicker, File operations, etc.)
- ❌ Contain complex error handling (>10 lines)
- ❌ Have methods > 50 lines
- ❌ Contain code duplication

## Auto-Detection Rules

### When Page Widget > 300 Lines

**AI MUST:**
1. Analyze file for extraction opportunities
2. Identify services to extract
3. Identify widgets to extract
4. Create refactoring plan
5. Ask user if they want to refactor before implementing

### When Method > 50 Lines

**AI MUST:**
1. Identify method purpose
2. Determine extraction target:
   - External operation → Service
   - UI component → Widget
   - Pure function → Helper
3. Extract before completing implementation

### When Code Duplication Detected

**AI MUST:**
1. Identify duplicated code
2. Extract to method/function
3. Replace all occurrences
4. Verify no duplication remains

### When Business Logic in Page

**AI MUST:**
1. Identify business logic
2. Extract to appropriate layer:
   - External operation → Service (`common/data/services/`)
   - State management → Notifier (`domain/notifiers/`)
   - Data access → Repository (`data/repositories/`)
3. Update page to delegate

## Extraction Guidelines

### Extract to Service When:

- ✅ Operation involves external dependencies (ImagePicker, File, Camera, etc.)
- ✅ Method exceeds 50 lines
- ✅ Contains complex error handling
- ✅ Contains business logic (validation, transformation)
- ✅ Could be reused in multiple features

**Location:** `common/data/services/`

**Pattern:**
```dart
class FeatureService {
  Future<Either<Failure, T>> operation() async {
    // Logic here
  }
}

final featureServiceProvider = Provider<FeatureService>(
  (ref) => FeatureServiceImpl(),
);
```

### Extract to Widget When:

- ✅ UI component is reusable
- ✅ UI component is complex (>30 lines)
- ✅ UI component has its own state
- ✅ UI component appears in multiple places

**Location:** `presentation/widgets/` or `common/presentation/widgets/`

**Pattern:**
```dart
class FeatureWidget extends StatelessWidget {
  const FeatureWidget({super.key});
  
  @override
  Widget build(BuildContext context) {
    // UI here
  }
}
```

### Extract to Helper When:

- ✅ Pure function (no side effects)
- ✅ Used in multiple places
- ✅ Simple utility (formatting, validation)

**Location:** `common/presentation/utils/`

**Pattern:**
```dart
class FeatureHelper {
  static String format(String input) {
    // Logic here
  }
}
```

## Required Patterns

### Error Handling

**MUST use centralized helpers:**

```dart
// ❌ FORBIDDEN: Inline error handling
try {
  // operation
} catch (e) {
  ScaffoldMessenger.of(context).showSnackBar(/* ... */);
}

// ✅ REQUIRED: Centralized helper
result.fold(
  (failure) => SnackbarHelper.showError(context, failure),
  (success) => SnackbarHelper.showSuccess(context, message),
);
```

### Constants

**MUST extract hardcoded values:**

```dart
// ❌ FORBIDDEN: Magic numbers
maxWidth: 1024
quality: 85

// ✅ REQUIRED: Constants
maxWidth: ImagePickerConfig.defaultMaxWidth
quality: ImagePickerConfig.defaultQuality
```

### State Management

**MUST delegate to notifiers:**

```dart
// ❌ FORBIDDEN: Business logic in page
void _handleSave() {
  // Complex validation
  // API call
  // State update
}

// ✅ REQUIRED: Delegate to notifier
Future<void> _handleSave() async {
  final success = await ref
      .read(notifierProvider.notifier)
      .update(data);
  // Only handle UI feedback
}
```

## Quality Checklist

Before completing page widget, verify:

- [ ] Page widget < 300 lines
- [ ] No method > 50 lines
- [ ] No business logic in page
- [ ] No code duplication
- [ ] Complex operations extracted to services
- [ ] Reusable UI extracted to widgets
- [ ] Error handling centralized
- [ ] No hardcoded values
- [ ] State management delegated to notifiers
- [ ] Loading/error/empty states handled
- [ ] All strings localized
- [ ] Design system used

## References

- **Full Guide:** `docs/29_PAGE_WIDGET_BEST_PRACTICES.md`
- **Refactoring:** `docs/30_REFACTORING_GUIDE.md`
- **Feature Template:** `docs/07_FEATURE_TEMPLATE.md`
- **Clean Architecture:** `docs/04_CLEAN_ARCHITECTURE.md`

---

**AI MUST enforce these standards automatically when working with page widgets!**

