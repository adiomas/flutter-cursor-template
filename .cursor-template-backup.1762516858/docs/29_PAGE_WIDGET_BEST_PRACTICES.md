# Page Widget Best Practices

**CRITICAL DOCUMENT** - Ensures page widgets follow clean architecture principles and avoid common anti-patterns.

## Core Principles

### 1. Single Responsibility Principle

**Page widgets should ONLY orchestrate UI, not contain business logic.**

```dart
// ❌ BAD: Page contains complex business logic
class ProfilePage extends HookConsumerWidget {
  Future<void> _showImagePicker(BuildContext context, WidgetRef ref) async {
    // 217 lines of image picker logic, error handling, file validation...
    // This belongs in a SERVICE, not a page widget!
  }
}

// ✅ GOOD: Page delegates to services/notifiers
class ProfilePage extends HookConsumerWidget {
  Future<void> _handleAvatarTap(BuildContext context, WidgetRef ref) async {
    final result = await ref.read(imagePickerServiceProvider).pickImage();
    result.fold(
      (failure) => _showError(context, failure),
      (file) => ref.read(profileNotifierProvider.notifier).uploadAvatar(file),
    );
  }
}
```

### 2. Maximum Page Size: 300 Lines

**If a page exceeds 300 lines, extract components or logic.**

**Red Flags:**
- Page widget > 300 lines
- Single method > 50 lines
- Multiple nested conditionals
- Repeated code blocks

**Solution:**
- Extract complex logic to services
- Extract UI sections to separate widgets
- Extract reusable dialogs/bottom sheets to common widgets

### 3. No Business Logic in Pages

**Business logic belongs in:**
- **Services** (`common/data/services/`) - External operations (image picker, file operations)
- **Repositories** (`data/repositories/`) - Data access
- **Notifiers** (`domain/notifiers/`) - State management

**Pages should only:**
- Watch state from notifiers
- Call notifier methods
- Show UI based on state
- Handle user interactions (delegate to notifiers/services)

## Common Anti-Patterns

### ❌ Anti-Pattern 1: Massive Methods in Pages

```dart
// ❌ BAD: 217-line method in page widget
Future<void> _showImagePicker(BuildContext context, WidgetRef ref) async {
  final logger = AppLogger.instance;
  logger.debug('📷 Opening image picker bottom sheet...');
  
  final picker = ImagePicker();
  ImageSource? source;
  try {
    // ... 200+ lines of logic ...
  } catch (e) {
    // ... error handling ...
  }
}

// ✅ GOOD: Extract to service
// lib/common/data/services/image_picker_service.dart
class ImagePickerService {
  Future<Either<Failure, File>> pickImage({
    int maxWidth = 1024,
    int maxHeight = 1024,
    int quality = 85,
  }) async {
    // All logic here
  }
}

// Page widget (simple delegation)
Future<void> _handleAvatarTap(BuildContext context, WidgetRef ref) async {
  final result = await ref.read(imagePickerServiceProvider).pickImage();
  result.fold(
    (failure) => SnackbarHelper.showError(context, failure),
    (file) => ref.read(profileNotifierProvider.notifier).uploadAvatar(file),
  );
}
```

### ❌ Anti-Pattern 2: Code Duplication

```dart
// ❌ BAD: Same callback repeated 3 times
data: (user) => _ProfileContent(
  onSave: () async {
    final success = await ref.read(profileNotifierProvider.notifier)
        .updateDisplayName(displayNameController.text);
    if (success && context.mounted) {
      isEditing.value = false;
      ScaffoldMessenger.of(context).showSnackBar(/* ... */);
    }
  },
),
loading: () => _ProfileContent(
  onSave: () async {
    // EXACT SAME CODE REPEATED
  },
),
orElse: () => _ProfileContent(
  onSave: () async {
    // EXACT SAME CODE REPEATED AGAIN
  },
),

// ✅ GOOD: Extract to method
void _handleSave(BuildContext context, WidgetRef ref) async {
  final success = await ref.read(profileNotifierProvider.notifier)
      .updateDisplayName(displayNameController.text);
  if (success && context.mounted) {
    isEditing.value = false;
    SnackbarHelper.showSuccess(context, context.l10n.successUpdated);
  }
}

// Use in all places
data: (user) => _ProfileContent(onSave: () => _handleSave(context, ref)),
loading: () => _ProfileContent(onSave: () => _handleSave(context, ref)),
orElse: () => _ProfileContent(onSave: () => _handleSave(context, ref)),
```

### ❌ Anti-Pattern 3: Inline Complex UI

```dart
// ❌ BAD: Bottom sheet UI defined inline in page
Future<void> _showImagePicker(BuildContext context, WidgetRef ref) async {
  source = await BottomSheetHelper.show<ImageSource>(
    builder: (context) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(/* ... */),
          ListTile(/* ... */),
          ListTile(/* ... */),
        ],
      ),
    ),
  );
}

// ✅ GOOD: Extract to reusable widget
// lib/common/presentation/widgets/image_source_bottom_sheet.dart
class ImageSourceBottomSheet extends StatelessWidget {
  static Future<ImageSource?> show(BuildContext context) {
    return BottomSheetHelper.show<ImageSource>(
      context: context,
      builder: (context) => const ImageSourceBottomSheet(),
    );
  }
  
  // Widget implementation
}

// Page widget (simple call)
Future<void> _handleAvatarTap(BuildContext context, WidgetRef ref) async {
  final source = await ImageSourceBottomSheet.show(context);
  if (source == null) return;
  // Continue with image picking...
}
```

### ❌ Anti-Pattern 4: Hardcoded Values

```dart
// ❌ BAD: Magic numbers in page
image = await picker.pickImage(
  source: source,
  maxWidth: 1024,      // Magic number
  maxHeight: 1024,    // Magic number
  imageQuality: 85,   // Magic number
);

// ✅ GOOD: Constants in service/config
// lib/common/data/services/image_picker_service.dart
class ImagePickerConfig {
  static const int maxWidth = 1024;
  static const int maxHeight = 1024;
  static const int quality = 85;
}

// Or in service
class ImagePickerService {
  static const int defaultMaxWidth = 1024;
  static const int defaultMaxHeight = 1024;
  static const int defaultQuality = 85;
  
  Future<Either<Failure, File>> pickImage({
    int maxWidth = defaultMaxWidth,
    int maxHeight = defaultMaxHeight,
    int quality = defaultQuality,
  }) async {
    // Use parameters
  }
}
```

### ❌ Anti-Pattern 5: Direct Error Handling in Pages

```dart
// ❌ BAD: Error handling scattered throughout page
try {
  // ... operation ...
} catch (e, stackTrace) {
  logger.error('❌ Error', error: e, stackTrace: stackTrace);
  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error: ${e.toString()}'),
        backgroundColor: context.appColors.error,
      ),
    );
  }
}

// ✅ GOOD: Centralized error handling
// lib/common/presentation/utils/snackbar_helper.dart
class SnackbarHelper {
  static void showError(BuildContext context, Failure failure) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(failure.userMessage),
        backgroundColor: context.appColors.error,
      ),
    );
  }
  
  static void showSuccess(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: context.appColors.success,
      ),
    );
  }
}

// Page widget (simple call)
result.fold(
  (failure) => SnackbarHelper.showError(context, failure),
  (success) => SnackbarHelper.showSuccess(context, context.l10n.successUpdated),
);
```

## Page Widget Structure Template

```dart
class FeaturePage extends HookConsumerWidget {
  static const routeName = '/feature';

  const FeaturePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(featureNotifierProvider);
    final controller = useTextEditingController();
    final isEditing = useState(false);

    // Load data on mount
    useEffect(() {
      Future.microtask(() {
        ref.read(featureNotifierProvider.notifier).load();
      });
      return null;
    }, const []);

    return Scaffold(
      appBar: _buildAppBar(context, isEditing, ref),
      body: SafeArea(
        child: state.maybeWhen(
          data: (data) => _FeatureContent(
            data: data,
            controller: controller,
            isEditing: isEditing.value,
            onSave: () => _handleSave(context, ref, controller, isEditing),
            onAction: () => _handleAction(context, ref),
          ),
          loading: () => const LoadingShimmer(),
          error: (failure) => ErrorView(
            failure: failure,
            onRetry: () => ref.read(featureNotifierProvider.notifier).load(),
          ),
          orElse: () => const SizedBox.shrink(),
        ),
      ),
    );
  }

  // Extract app bar to method if complex
  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    ValueNotifier<bool> isEditing,
    WidgetRef ref,
  ) {
    return AppBar(
      title: Text(context.l10n.featureTitle),
      actions: [
        if (isEditing.value)
          TextButton(
            onPressed: () => isEditing.value = false,
            child: Text(context.l10n.cancel),
          ),
      ],
    );
  }

  // Extract handlers to methods (max 20 lines each)
  Future<void> _handleSave(
    BuildContext context,
    WidgetRef ref,
    TextEditingController controller,
    ValueNotifier<bool> isEditing,
  ) async {
    final success = await ref
        .read(featureNotifierProvider.notifier)
        .update(controller.text);
    
    if (success && context.mounted) {
      isEditing.value = false;
      SnackbarHelper.showSuccess(context, context.l10n.successUpdated);
    }
  }

  Future<void> _handleAction(BuildContext context, WidgetRef ref) async {
    final result = await ref.read(someServiceProvider).doAction();
    result.fold(
      (failure) => SnackbarHelper.showError(context, failure),
      (success) => ref.read(featureNotifierProvider.notifier).refresh(),
    );
  }
}
```

## Extraction Guidelines

### When to Extract to Service

Extract to service (`common/data/services/`) when:
- ✅ Operation involves external dependencies (ImagePicker, File operations, etc.)
- ✅ Method exceeds 50 lines
- ✅ Contains complex error handling
- ✅ Contains business logic (validation, transformation)
- ✅ Could be reused in multiple features

**Examples:**
- Image picker operations
- File upload/download
- Camera operations
- Location services
- Biometric authentication

### When to Extract to Widget

Extract to widget (`presentation/widgets/`) when:
- ✅ UI component is reusable
- ✅ UI component is complex (>30 lines)
- ✅ UI component has its own state
- ✅ UI component appears in multiple places

**Examples:**
- Bottom sheets
- Dialogs
- Form fields
- List items
- Cards

### When to Extract to Helper

Extract to helper (`common/presentation/utils/`) when:
- ✅ Pure function (no side effects)
- ✅ Used in multiple places
- ✅ Simple utility (formatting, validation)

**Examples:**
- Date formatting
- String validation
- Snackbar helpers
- Dialog helpers

## Size Limits

| Component Type | Maximum Lines | Action if Exceeded |
|----------------|---------------|-------------------|
| **Page Widget** | 300 | Extract components/logic |
| **Single Method** | 50 | Extract to service/helper |
| **Widget Class** | 200 | Split into smaller widgets |
| **Service Method** | 100 | Split into smaller methods |

## Checklist for Page Widgets

Before completing a page widget, verify:

- [ ] Page widget < 300 lines
- [ ] No method > 50 lines
- [ ] No business logic in page (only UI orchestration)
- [ ] No code duplication
- [ ] Complex operations extracted to services
- [ ] Reusable UI extracted to widgets
- [ ] Error handling centralized (SnackbarHelper)
- [ ] No hardcoded values (use constants)
- [ ] State management delegated to notifiers
- [ ] Loading/error/empty states handled
- [ ] All strings localized (`context.l10n.*`)
- [ ] Design system used (no hardcoded colors/styles)

## Examples

### ✅ Good Page Widget Structure

```dart
class ProfilePage extends HookConsumerWidget {
  // ~150 lines total
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // State watching
    // useEffect for loading
    // Return Scaffold with state handling
  }
  
  // Helper methods (each < 20 lines)
  Future<void> _handleSave(...) { /* ... */ }
  Future<void> _handleAvatarTap(...) { /* ... */ }
  
  // Delegates to:
  // - ImagePickerService (for image picking)
  // - ProfileNotifier (for state)
  // - SnackbarHelper (for messages)
  // - ImageSourceBottomSheet (for UI)
}
```

### ❌ Bad Page Widget Structure

```dart
class ProfilePage extends HookConsumerWidget {
  // ~774 lines total ❌
  
  Future<void> _showImagePicker(...) {
    // 217 lines of complex logic ❌
    // Direct ImagePicker usage ❌
    // Inline error handling ❌
    // Inline bottom sheet UI ❌
  }
  
  // Code duplication ❌
  // Hardcoded values ❌
  // Business logic in page ❌
}
```

## Related Documents

- **Feature Template:** [07_FEATURE_TEMPLATE.md](07_FEATURE_TEMPLATE.md)
- **Clean Architecture:** [04_CLEAN_ARCHITECTURE.md](04_CLEAN_ARCHITECTURE.md)
- **Refactoring Guide:** [30_REFACTORING_GUIDE.md](30_REFACTORING_GUIDE.md)
- **Code Patterns:** [25_CODE_PATTERNS.md](25_CODE_PATTERNS.md)

---

**Remember:** Page widgets are orchestrators, not implementers. Keep them thin and delegate!

