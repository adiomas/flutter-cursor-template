# Refactoring Guide

**COMPREHENSIVE GUIDE** - Step-by-step process for refactoring code to follow best practices and clean architecture principles.

## When to Refactor

Refactor when you encounter:

- ✅ **Code duplication** - Same logic repeated multiple times
- ✅ **Large files** - Page/widget > 300 lines, method > 50 lines
- ✅ **Business logic in UI** - Complex operations in page widgets
- ✅ **Hardcoded values** - Magic numbers/strings scattered throughout
- ✅ **Tight coupling** - Components directly depend on implementation details
- ✅ **Poor separation of concerns** - UI handling business logic
- ✅ **Difficult to test** - Logic mixed with UI makes testing hard

## Refactoring Process

### Step 1: Analyze Current Code

**Before refactoring, thoroughly analyze:**

1. **Read the entire file** - Understand all responsibilities
2. **Identify violations:**
   - Code duplication
   - Methods > 50 lines
   - Business logic in UI
   - Hardcoded values
   - Missing error handling
   - Tight coupling

3. **Map dependencies:**
   - What does this code depend on?
   - What depends on this code?
   - Are dependencies appropriate?

4. **Identify extraction opportunities:**
   - Services (external operations)
   - Widgets (reusable UI)
   - Helpers (pure functions)
   - Constants (magic values)

### Step 2: Create Refactoring Plan

**Document your plan:**

```markdown
## Refactoring Plan: profile_page.dart

### Current Issues:
1. ❌ _showImagePicker method: 217 lines (should be < 50)
2. ❌ Code duplication: onSave callback repeated 3 times
3. ❌ Business logic in page: ImagePicker operations
4. ❌ Hardcoded values: maxWidth=1024, quality=85
5. ❌ Inline error handling: Scattered try-catch blocks

### Extraction Plan:
1. ✅ Create ImagePickerService (common/data/services/)
2. ✅ Create ImageSourceBottomSheet widget (common/presentation/widgets/)
3. ✅ Create SnackbarHelper (common/presentation/utils/)
4. ✅ Extract onSave handler to method
5. ✅ Extract constants to ImagePickerConfig

### Files to Create:
- lib/common/data/services/image_picker_service.dart
- lib/common/presentation/widgets/image_source_bottom_sheet.dart
- lib/common/presentation/utils/snackbar_helper.dart

### Files to Modify:
- lib/features/profile/presentation/pages/profile_page.dart
```

### Step 3: Extract Services First

**Services handle external operations:**

```dart
// 1. Create service interface (if needed)
abstract class ImagePickerService {
  Future<Either<Failure, File>> pickImage({
    int maxWidth = 1024,
    int maxHeight = 1024,
    int quality = 85,
  });
}

// 2. Implement service
class ImagePickerServiceImpl implements ImagePickerService {
  final ImagePicker _picker = ImagePicker();
  final AppLogger _logger = AppLogger.instance;

  @override
  Future<Either<Failure, File>> pickImage({
    int maxWidth = 1024,
    int maxHeight = 1024,
    int quality = 85,
  }) async {
    try {
      // All image picker logic here
      // Error handling
      // File validation
      // Return Either<Failure, File>
    } catch (e, stackTrace) {
      _logger.error('Image picker error', error: e, stackTrace: stackTrace);
      return Left(Failure.generic(error: e.toString()));
    }
  }
}

// 3. Create provider
final imagePickerServiceProvider = Provider<ImagePickerService>(
  (ref) => ImagePickerServiceImpl(),
);
```

### Step 4: Extract Widgets

**Extract reusable UI components:**

```dart
// lib/common/presentation/widgets/image_source_bottom_sheet.dart
class ImageSourceBottomSheet extends StatelessWidget {
  static Future<ImageSource?> show(BuildContext context) {
    return BottomSheetHelper.show<ImageSource>(
      context: context,
      backgroundColor: context.appColors.contentBackground,
      builder: (context) => const ImageSourceBottomSheet(),
    );
  }

  const ImageSourceBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: paddingAll16,
            child: Text(
              context.l10n.profileSelectAvatarSource,
              style: context.textStyles.titleMedium,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: Text(context.l10n.profileSelectFromGallery),
            onTap: () => Navigator.pop(context, ImageSource.gallery),
          ),
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: Text(context.l10n.profileTakePhoto),
            onTap: () => Navigator.pop(context, ImageSource.camera),
          ),
          spacing16,
        ],
      ),
    );
  }
}
```

### Step 5: Extract Helpers

**Extract pure functions and utilities:**

```dart
// lib/common/presentation/utils/snackbar_helper.dart
class SnackbarHelper {
  static void showError(BuildContext context, Failure failure) {
    if (!context.mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(failure.userMessage ?? context.l10n.errorGeneric),
        backgroundColor: context.appColors.error,
      ),
    );
  }

  static void showSuccess(BuildContext context, String message) {
    if (!context.mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: context.appColors.success,
      ),
    );
  }
}
```

### Step 6: Refactor Page Widget

**Simplify page widget to orchestration only:**

```dart
class ProfilePage extends HookConsumerWidget {
  // Now ~200 lines instead of 774 ✅

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // State watching
    // useEffect for loading
    // Return Scaffold
  }

  // Simple handlers (each < 20 lines)
  Future<void> _handleSave(BuildContext context, WidgetRef ref) async {
    final success = await ref
        .read(profileNotifierProvider.notifier)
        .updateDisplayName(displayNameController.text);
    
    if (success && context.mounted) {
      isEditing.value = false;
      SnackbarHelper.showSuccess(context, context.l10n.successUpdated);
    }
  }

  Future<void> _handleAvatarTap(BuildContext context, WidgetRef ref) async {
    final result = await ref.read(imagePickerServiceProvider).pickImage();
    
    result.fold(
      (failure) => SnackbarHelper.showError(context, failure),
      (file) async {
        final success = await ref
            .read(profileNotifierProvider.notifier)
            .uploadAvatar(file);
        
        if (success && context.mounted) {
          SnackbarHelper.showSuccess(
            context,
            context.l10n.profileAvatarUpdated,
          );
        }
      },
    );
  }
}
```

### Step 7: Remove Duplication

**Extract repeated code to methods:**

```dart
// ❌ BEFORE: Duplication
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
    // SAME CODE REPEATED
  },
),

// ✅ AFTER: Single method
void _buildProfileContent({
  required UserEntity user,
  required bool isLoading,
}) {
  return _ProfileContent(
    user: user,
    isLoading: isLoading,
    onSave: () => _handleSave(context, ref),
  );
}

// Use everywhere
data: (user) => _buildProfileContent(user: user, isLoading: false),
loading: () => _buildProfileContent(user: currentUser, isLoading: true),
```

### Step 8: Extract Constants

**Move hardcoded values to constants:**

```dart
// ❌ BEFORE: Hardcoded values
image = await picker.pickImage(
  source: source,
  maxWidth: 1024,
  maxHeight: 1024,
  imageQuality: 85,
);

// ✅ AFTER: Constants in service
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

### Step 9: Test Refactored Code

**Verify everything still works:**

1. **Manual testing:**
   - Test all user flows
   - Test error cases
   - Test edge cases

2. **Automated testing:**
   - Run existing tests
   - Add tests for new services
   - Test extracted widgets

3. **Code quality:**
   - Run linter
   - Check for warnings
   - Verify no regressions

### Step 10: Update Documentation

**Update related documentation:**

- Update feature documentation
- Update API docs (if service is public)
- Update README if needed
- Add migration notes if breaking changes

## Refactoring Patterns

### Pattern 1: Extract Service

**When:** Complex external operation in page/widget

**Steps:**
1. Create service class in `common/data/services/`
2. Move logic to service method
3. Return `Either<Failure, T>`
4. Create provider
5. Update page to use service

### Pattern 2: Extract Widget

**When:** Reusable UI component

**Steps:**
1. Create widget file in `presentation/widgets/`
2. Move UI code to widget
3. Make widget configurable (parameters)
4. Update page to use widget

### Pattern 3: Extract Helper

**When:** Pure function or utility

**Steps:**
1. Create helper file in `common/presentation/utils/`
2. Move function to helper
3. Make it static if no state
4. Update usages

### Pattern 4: Remove Duplication

**When:** Same code repeated

**Steps:**
1. Identify repeated code
2. Extract to method/function
3. Parameterize differences
4. Replace all occurrences

### Pattern 5: Extract Constants

**When:** Magic numbers/strings

**Steps:**
1. Create constants file or class
2. Define constants with meaningful names
3. Replace all occurrences
4. Document why values chosen

## Common Refactoring Scenarios

### Scenario 1: Large Page Widget

**Problem:** Page widget > 300 lines

**Solution:**
1. Extract complex methods to services
2. Extract UI sections to widgets
3. Extract handlers to methods
4. Simplify state management

### Scenario 2: Business Logic in UI

**Problem:** Complex operations in page/widget

**Solution:**
1. Identify business logic
2. Create service for operation
3. Move logic to service
4. Update page to call service

### Scenario 3: Code Duplication

**Problem:** Same code repeated multiple times

**Solution:**
1. Identify duplication
2. Extract to method/function
3. Parameterize differences
4. Replace all occurrences

### Scenario 4: Hardcoded Values

**Problem:** Magic numbers/strings throughout code

**Solution:**
1. Create constants class/file
2. Define constants
3. Replace all occurrences
4. Document values

### Scenario 5: Complex Error Handling

**Problem:** Error handling scattered throughout

**Solution:**
1. Create error helper/service
2. Centralize error handling
3. Standardize error messages
4. Update all error handling

## Refactoring Checklist

Before starting refactoring:

- [ ] Analyzed current code thoroughly
- [ ] Created refactoring plan
- [ ] Identified all dependencies
- [ ] Identified extraction opportunities
- [ ] Documented current behavior
- [ ] Created backup/branch

During refactoring:

- [ ] Extract services first
- [ ] Extract widgets second
- [ ] Extract helpers third
- [ ] Remove duplication
- [ ] Extract constants
- [ ] Update all usages
- [ ] Test after each step

After refactoring:

- [ ] All tests passing
- [ ] Manual testing complete
- [ ] Code quality verified
- [ ] Documentation updated
- [ ] No regressions
- [ ] Code review completed

## Anti-Patterns to Avoid

### ❌ Big Bang Refactoring

Don't refactor everything at once. Refactor incrementally:
- Extract one service at a time
- Test after each extraction
- Commit after each successful step

### ❌ Changing Behavior

Refactoring should NOT change behavior:
- Same inputs → Same outputs
- Same error handling
- Same user experience

### ❌ Breaking Tests

Don't break existing tests:
- Update tests as you refactor
- Add tests for new code
- Ensure all tests pass

### ❌ Premature Extraction

Don't extract too early:
- Extract when code is actually reused
- Extract when complexity justifies it
- Don't create unnecessary abstractions

## Tools for Refactoring

### IDE Features

- **Extract Method** - Extract code to method
- **Extract Widget** - Extract widget to file
- **Rename** - Safe renaming across codebase
- **Find Usages** - Find all references

### Static Analysis

- **dart analyze** - Find issues
- **dart fix** - Auto-fix issues
- **Linter rules** - Enforce standards

### Testing

- **Unit tests** - Test services/helpers
- **Widget tests** - Test widgets
- **Integration tests** - Test flows

## Related Documents

- **Page Widget Best Practices:** [29_PAGE_WIDGET_BEST_PRACTICES.md](29_PAGE_WIDGET_BEST_PRACTICES.md)
- **Clean Architecture:** [04_CLEAN_ARCHITECTURE.md](04_CLEAN_ARCHITECTURE.md)
- **Code Patterns:** [25_CODE_PATTERNS.md](25_CODE_PATTERNS.md)
- **Feature Template:** [07_FEATURE_TEMPLATE.md](07_FEATURE_TEMPLATE.md)

---

**Remember:** Refactor incrementally, test frequently, and maintain behavior!

