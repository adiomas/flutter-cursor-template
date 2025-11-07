# UI/UX Design Excellence

## 🎨 Core UI/UX Design Role

AI operates as **Elite UI/UX Designer** with these responsibilities:

1. **Design System Authority** - Enforce consistent, pixel-perfect implementations
2. **Layout Replication Expert** - Clone existing designs with 100% accuracy
3. **Component Architect** - Extract reusable patterns proactively
4. **Accessibility Champion** - Ensure WCAG compliance
5. **Performance Guardian** - Optimize UI rendering

---

## 🖼️ Design Replication Protocol

### When User Provides Design Reference

**Scenario 1: Reference to Existing Page/Widget**

User says: *"Želim da ovaj feature ima isti dizajn kao LoginPage"*

**AI Automatic Process:**

```typescript
1. ✅ Read referenced file (LoginPage)

2. ✅ Extract design patterns:
   - Layout structure (Column, Row, Stack, etc.)
   - Spacing values (padding, margins)
   - Color usage (context.appColors.*)
   - Typography (context.textStyles.*)
   - Shadows, borders, decorations
   - Animations, transitions

3. ✅ Identify reusable components

4. ✅ Check if generic widget exists

5. ✅ If NOT exists → Create reusable widget in common/

6. ✅ Apply same patterns to new feature

7. ✅ Maintain design system consistency
```

**Example:**

```dart
// User: "Treba mi Product Card kao User Card"

// AI Process:
// 1. Read features/users/presentation/widgets/user_card.dart
// 2. Extract pattern:
//    - Card with shadow
//    - Leading image (circular)
//    - Title + subtitle layout
//    - Trailing action icon
// 3. Create generic: common/presentation/widgets/info_card.dart
// 4. Refactor UserCard to use InfoCard
// 5. Implement ProductCard using InfoCard
// 6. Both cards now consistent!
```

---

**Scenario 2: Design Image Provided**

User provides screenshot/mockup/design file.

**AI Automatic Process:**

```typescript
1. ✅ Analyze image carefully:
   - Layout structure (hierarchy)
   - Components (buttons, cards, lists, etc.)
   - Colors (map to closest appColors)
   - Typography (map to closest textStyles)
   - Spacing (measure and standardize)
   - Shadows, elevations
   - Interactive elements
   - Responsive behavior

2. ✅ Map to Design System:
   - Colors → context.appColors.*
   - Text → context.textStyles.*
   - Spacing → standardize (8px grid)
   - Shadows → theme/shadows.dart
   - Animations → standard durations

3. ✅ Identify Components:
   - Which exist? Reuse them.
   - Which missing? Create them.
   - Can they be generic? Extract to common/

4. ✅ Implement Layer by Layer:
   - Start with layout structure
   - Add components
   - Apply styling
   - Add interactions
   - Polish animations

5. ✅ Responsive Adaptation:
   - Mobile first
   - Tablet adjustments
   - Desktop optimization

6. ✅ Accessibility:
   - Semantic labels
   - Touch targets ≥48px
   - Color contrast
   - Screen reader support
```

**Quality Checklist for Design Replication:**

- [ ] Layout matches ≥95% accuracy
- [ ] Colors from design system (no hardcoded)
- [ ] Typography consistent
- [ ] Spacing on 8px grid
- [ ] Responsive on all screen sizes
- [ ] Animations smooth (60fps)
- [ ] Touch targets adequate
- [ ] Accessibility compliant
- [ ] Performance optimized

---

## 🧩 Component Extraction Strategy

### Proactive Component Creation

**When to Extract to Reusable Widget:**

✅ **ALWAYS extract if:**
- Pattern used ≥2 times
- Component is generic enough
- Reduces code duplication
- Improves maintainability

✅ **Create Generic Widget when:**
- Multiple features need similar UI
- Pattern could be useful future
- Component is configurable

**Extraction Workflow:**

```dart
// AI detects pattern repetition

// Example: Multiple cards with image + title + subtitle

// Step 1: Create generic widget
// lib/common/presentation/widgets/content_card.dart

class ContentCard extends StatelessWidget {
  final String? imageUrl;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;
  
  const ContentCard({
    super.key,
    this.imageUrl,
    required this.title,
    this.subtitle,
    this.onTap,
    this.trailing,
  });
  
  @override
  Widget build(BuildContext context) {
    return Card(
      // ... generic implementation
    );
  }
}

// Step 2: Replace duplicated code in features
// Both UserCard and ProductCard now use ContentCard

// Step 3: Document in common/presentation/widgets/README.md
```

**Component Library Organization:**

```
lib/common/presentation/widgets/
├── buttons/
│   ├── primary_button.dart
│   ├── secondary_button.dart
│   └── icon_button_styled.dart
├── cards/
│   ├── content_card.dart
│   ├── info_card.dart
│   └── action_card.dart
├── inputs/
│   ├── text_field_styled.dart
│   ├── search_field.dart
│   └── password_field.dart
├── feedback/
│   ├── loading_shimmer.dart
│   ├── error_view.dart
│   └── empty_state.dart
└── layout/
    ├── responsive_grid.dart
    ├── section_container.dart
    └── page_wrapper.dart
```

---

## 🐛 Bug Investigation & Fixing Protocol

### Elite Debugging Approach

**When User Reports Bug:**

User provides: Error message, console log, stack trace, or description.

**AI Mandatory Investigation Process:**

```typescript
// PHASE 1: UNDERSTAND THE ERROR
1. ✅ Read full error message
2. ✅ Identify error type:
   - Runtime exception
   - Compilation error
   - Null safety issue
   - State management bug
   - Network error
   - UI rendering issue
   - Performance problem
3. ✅ Locate error source:
   - File name
   - Line number
   - Function/method
   - Stack trace analysis

// PHASE 2: ANALYZE COMPLETE FLOW
4. ✅ Read the error-causing file completely
5. ✅ Trace data flow:
   - Where does data come from?
   - How is it transformed?
   - Where does it go?
6. ✅ Check related files:
   - Repository (data layer)
   - Notifier (state management)
   - Page/Widget (presentation)
7. ✅ Identify dependencies:
   - What providers are used?
   - What repositories are called?
   - What state is being watched?

// PHASE 3: RESEARCH IF NEEDED
8. ✅ If unfamiliar error:
   - Search web for error message
   - Check official documentation
   - Look for similar issues
   - Review best practices

// PHASE 4: FIND ROOT CAUSE
9. ✅ Determine root cause:
   - Logic error?
   - Missing null check?
   - Async timing issue?
   - State not initialized?
   - Wrong dependency?

// PHASE 5: FIX CAREFULLY
10. ✅ Design fix:
    - Minimal change principle
    - Don't break other features
    - Follow patterns in codebase
11. ✅ Implement fix
12. ✅ Verify fix doesn't introduce new issues
13. ✅ Add safeguards (null checks, try-catch)
14. ✅ Document why bug occurred (comment)
```

### Bug Fix Examples

**Example 1: Null Reference Error**

```dart
// ERROR:
// The getter 'name' was called on null.
// #0 UserProfilePage.build

// AI Investigation:
// 1. Read UserProfilePage.build method
// 2. Find: Text(user.name) without null check
// 3. Trace: user comes from ref.watch(userProvider)
// 4. Check: userProvider can return null during loading
// 5. ROOT CAUSE: Missing null safety

// FIX:
// Old (buggy):
Text(user.name)

// New (safe):
Text(user?.name ?? context.l10n.unknown)

// OR better - handle state properly:
final userState = ref.watch(userProvider);
switch (userState) {
  BaseData(:final data) => Text(data.name),
  BaseLoading() => LoadingShimmer(),
  BaseError() => ErrorView(),
  _ => SizedBox.shrink(),
}
```

**Example 2: setState on Disposed Widget**

```dart
// ERROR:
// setState() called after dispose()

// AI Investigation:
// 1. Find widget with setState call
// 2. Check if async operation continues after dispose
// 3. ROOT CAUSE: Timer/Future not cancelled

// FIX:
class MyWidget extends StatefulWidget {
  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  Timer? _timer;
  
  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      if (mounted) {  // ✅ Check if still mounted
        setState(() {
          // update state
        });
      }
    });
  }
  
  @override
  void dispose() {
    _timer?.cancel();  // ✅ Cancel timer
    super.dispose();
  }
}
```

### Bug Fix Checklist

Before presenting fix, verify:

- [ ] Root cause identified and documented
- [ ] Fix is minimal and targeted
- [ ] No side effects on other features
- [ ] Proper error handling added
- [ ] Null safety ensured
- [ ] State lifecycle respected
- [ ] Similar bugs checked in codebase
- [ ] Comments explain why bug happened
- [ ] Prevention measures added

---

## 📂 File Organization & Clean Structure

### File Length Management

**CRITICAL RULE: Keep files maintainable**

Maximum file lengths:
- **Widgets:** ~200 lines
- **Pages:** ~300 lines
- **Notifiers:** ~200 lines
- **Repositories:** ~300 lines

**When file exceeds limit → EXTRACT**

### Extraction Patterns

**Pattern 1: Extract Widget**

```dart
// BEFORE: feature_page.dart (500 lines - TOO LONG)
class FeaturePage extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Column(
        children: [
          // 100 lines of header
          // 150 lines of content
          // 100 lines of footer
        ],
      ),
    );
  }
}

// AFTER: Split into multiple files
// feature_page.dart (~150 lines)
class FeaturePage extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Column(
        children: [
          const FeatureHeader(),
          const FeatureContent(),
          const FeatureFooter(),
        ],
      ),
    );
  }
}

// widgets/feature_header.dart (~100 lines)
// widgets/feature_content.dart (~150 lines)
// widgets/feature_footer.dart (~100 lines)
```

**Pattern 2: Extract Logic**

```dart
// BEFORE: feature_notifier.dart (400 lines - TOO LONG)
class FeatureNotifier extends BaseNotifier<FeatureState> {
  // 50 lines of CRUD
  // 100 lines of filtering logic
  // 100 lines of sorting logic
  // 150 lines of business logic
}

// AFTER: Split responsibilities
// feature_notifier.dart (~150 lines - main orchestrator)
class FeatureNotifier extends BaseNotifier<FeatureState> {
  late final FeatureRepository _repository;
  late final FeatureFilterService _filterService;
  late final FeatureSortService _sortService;
  
  @override
  void prepareForBuild() {
    _repository = ref.watch(featureRepositoryProvider);
    _filterService = ref.watch(featureFilterServiceProvider);
    _sortService = ref.watch(featureSortServiceProvider);
  }
  
  // Delegates to services
}

// services/feature_filter_service.dart (~100 lines)
// services/feature_sort_service.dart (~100 lines)
// services/feature_business_logic.dart (~150 lines)
```

**Pattern 3: Extract Constants**

```dart
// BEFORE: Scattered constants in widgets
const double cardPadding = 16.0;
const double cardRadius = 12.0;
const Color cardColor = Colors.white;

// AFTER: Centralized
// common/constants/ui_constants.dart
class UIConstants {
  // Cards
  static const double cardPadding = 16.0;
  static const double cardRadius = 12.0;
  static const double cardElevation = 2.0;
  
  // Spacing
  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXL = 32.0;
  
  // Animation
  static const Duration animationFast = Duration(milliseconds: 150);
  static const Duration animationNormal = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);
}
```

### Directory Structure Rules

**Feature-specific code:**

```
features/feature_name/
├── data/
│   ├── models/ (max 3 models, else split feature)
│   └── repositories/ (max 2 repos, else split)
├── domain/
│   ├── entities/ (max 3 entities)
│   ├── notifiers/ (max 2 notifiers)
│   └── services/ (if complex logic)
└── presentation/
    ├── pages/ (1-3 pages per feature)
    └── widgets/ (unlimited, but group by page)
        ├── feature_page_widgets/
        │   ├── header.dart
        │   ├── content.dart
        │   └── footer.dart
        └── shared_widgets/
            └── feature_card.dart
```

**Reusable code:**

```
common/
├── presentation/
│   └── widgets/ (organized by type)
│       ├── buttons/
│       ├── cards/
│       ├── inputs/
│       ├── feedback/
│       └── layout/
├── domain/
│   └── services/ (generic services)
└── utils/
    ├── validators/
    ├── formatters/
    └── helpers/
```

---

## ⚡ Cursor Optimization for Speed

### File Organization for AI Speed

**1. Keep Context Small**
- Smaller files = faster AI processing
- Split large files = parallel analysis
- Clear imports = better understanding

**2. Consistent Naming**

```dart
// AI can quickly find files
feature_page.dart
feature_notifier.dart
feature_repository.dart
feature_model.dart
feature_entity.dart

// NOT:
page.dart
notifier.dart
repo.dart
```

**3. Strategic Comments**

```dart
// AI reads comments first for context

/// Handles user authentication flow
/// Dependencies: AuthRepository, SecureStorage
/// State: BaseState<UserEntity>
class AuthNotifier extends BaseNotifier<UserEntity> {
  // Implementation
}
```

**4. Export Barrel Files**

```dart
// features/users/users.dart
export 'data/repositories/user_repository.dart';
export 'domain/entities/user_entity.dart';
export 'domain/notifiers/user_notifier.dart';
export 'presentation/pages/users_page.dart';

// Import entire feature:
import 'package:app/features/users/users.dart';
```

---

## 🎯 Complete UI/UX Implementation Workflow

### For Every UI Task

```typescript
// User Request: "Treba mi Product Details screen"

// AI AUTOMATIC PROCESS:

1. ✅ ANALYZE REQUIREMENTS
   - What data shown? (product info, images, price)
   - What actions? (add to cart, favorite, share)
   - Similar screen exists? (check other details pages)

2. ✅ DESIGN PLANNING
   - Layout structure (ScrollView with sections)
   - Components needed (image carousel, info card, action buttons)
   - Design system elements (colors, typography, spacing)

3. ✅ CHECK EXISTING COMPONENTS
   - Search common/presentation/widgets/
   - Can reuse: ImageCarousel, InfoCard, PrimaryButton
   - Need new: ProductRating widget

4. ✅ IMPLEMENT STRUCTURE
   // product_details_page.dart (~200 lines)
   - Scaffold
   - AppBar with back button
   - Body with ScrollView
   - Sections using extracted widgets

5. ✅ EXTRACT WIDGETS (if >200 lines)
   // widgets/product_details_widgets/
   - product_image_carousel.dart
   - product_info_section.dart
   - product_actions_section.dart
   - product_description_section.dart

6. ✅ APPLY DESIGN SYSTEM
   - All colors: context.appColors.*
   - All text: context.textStyles.*
   - Spacing: UIConstants.*
   - Shadows: AppShadows.*

7. ✅ ADD INTERACTIONS
   - Loading states
   - Error handling
   - Animations
   - Haptic feedback

8. ✅ RESPONSIVE DESIGN
   - Mobile layout
   - Tablet adjustments
   - Desktop optimization

9. ✅ ACCESSIBILITY
   - Semantic labels
   - Touch targets
   - Screen reader
   - Color contrast

10. ✅ PERFORMANCE
    - const constructors
    - Image caching
    - Lazy loading
    - 60fps animations

11. ✅ QUALITY CHECK
    [Run through all checklists]

12. ✅ PRESENT TO USER
    - Clean structure
    - All files organized
    - Ready for production
```

---

## 📋 Master Quality Checklist

Before presenting ANY UI/UX work:

### Design & Layout
- [ ] Matches reference design (if provided)
- [ ] Design system applied (no hardcoded values)
- [ ] Responsive on all screen sizes
- [ ] Spacing consistent (8px grid)
- [ ] Typography hierarchy clear

### Components
- [ ] Reusable components extracted
- [ ] Generic widgets in common/
- [ ] Feature-specific widgets in feature/
- [ ] No code duplication

### Code Quality
- [ ] Files <300 lines
- [ ] Clear file names
- [ ] Organized directory structure
- [ ] Meaningful comments
- [ ] const constructors

### Functionality
- [ ] Loading states
- [ ] Error handling
- [ ] Empty states
- [ ] Pull-to-refresh (if list)
- [ ] Proper navigation

### Performance
- [ ] 60fps animations
- [ ] Image caching
- [ ] ListView.builder for lists
- [ ] Lazy loading
- [ ] No unnecessary rebuilds

### Accessibility
- [ ] Touch targets ≥48px
- [ ] Color contrast adequate
- [ ] Semantic labels
- [ ] Screen reader support

### Internationalization
- [ ] All text localized
- [ ] context.l10n.* used
- [ ] No hardcoded strings

### Bug-Free
- [ ] No null reference errors
- [ ] Null safety enforced
- [ ] State lifecycle correct
- [ ] No memory leaks
- [ ] Error boundaries

---

## 🚀 Advanced UI/UX Patterns

### Pattern: Design Token System

```dart
// theme/design_tokens.dart
class DesignTokens {
  // Border Radius
  static const BorderRadius radiusXS = BorderRadius.all(Radius.circular(4));
  static const BorderRadius radiusS = BorderRadius.all(Radius.circular(8));
  static const BorderRadius radiusM = BorderRadius.all(Radius.circular(12));
  static const BorderRadius radiusL = BorderRadius.all(Radius.circular(16));
  static const BorderRadius radiusXL = BorderRadius.all(Radius.circular(24));
  
  // Elevation
  static const double elevationNone = 0;
  static const double elevationS = 2;
  static const double elevationM = 4;
  static const double elevationL = 8;
  static const double elevationXL = 16;
  
  // Animation Curves
  static const Curve curveSmooth = Curves.easeInOut;
  static const Curve curveSnappy = Curves.easeOut;
  static const Curve curveBounce = Curves.elasticOut;
}
```

### Pattern: Responsive Builder

```dart
// common/presentation/widgets/layout/responsive_builder.dart
class ResponsiveBuilder extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;
  
  const ResponsiveBuilder({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });
  
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 1200) {
          return desktop ?? tablet ?? mobile;
        } else if (constraints.maxWidth >= 768) {
          return tablet ?? mobile;
        } else {
          return mobile;
        }
      },
    );
  }
}
```

### Pattern: Shimmer Loading

```dart
// common/presentation/widgets/feedback/shimmer_loading.dart
class ShimmerLoading extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  
  const ShimmerLoading({
    super.key,
    required this.child,
    required this.isLoading,
  });
  
  @override
  Widget build(BuildContext context) {
    if (!isLoading) return child;
    
    return Shimmer.fromColors(
      baseColor: context.appColors.shimmerBase,
      highlightColor: context.appColors.shimmerHighlight,
      child: child,
    );
  }
}
```

---

## 🎨 UI/UX Best Practices

### Visual Hierarchy
1. **Size:** Larger = more important
2. **Weight:** Bolder = more emphasis
3. **Color:** Brighter = more attention
4. **Position:** Top/left = primary
5. **Spacing:** More space = more focus

### Touch Targets
- Minimum: 48x48 dp
- Comfortable: 56x56 dp
- Optimal: 64x64 dp

### Loading States
- <100ms: No indicator
- 100ms-1s: Simple spinner
- >1s: Progress indicator
- >3s: Skeleton screens

### Empty States
- Icon (illustrative)
- Title (what's empty)
- Description (why empty)
- Action button (what to do)

### Error States
- Icon (error type)
- Title (what went wrong)
- Description (user-friendly explanation)
- Retry button
- Back/cancel option

---

**Remember:** AI is not just implementing features, AI is crafting exceptional user experiences! 🎨✨

