# Design System

Comprehensive design system for consistent, beautiful UI - colors, typography, spacing, and more.

## Color System

### Theme Colors

```dart
// lib/theme/app_colors.dart
class AppColors extends ThemeExtension<AppColors> {
  // Primary colors
  final Color primary;
  final Color primaryDark;
  final Color primaryLight;
  
  // Secondary colors
  final Color secondary;
  final Color secondaryDark;
  final Color secondaryLight;
  
  // Neutral colors
  final Color background;
  final Color surface;
  final Color border;
  
  // Semantic colors
  final Color success;
  final Color warning;
  final Color error;
  final Color info;
  
  // Text colors
  final Color textPrimary;
  final Color textSecondary;
  final Color textDisabled;
  
  const AppColors({
    required this.primary,
    required this.primaryDark,
    required this.primaryLight,
    required this.secondary,
    required this.secondaryDark,
    required this.secondaryLight,
    required this.background,
    required this.surface,
    required this.border,
    required this.success,
    required this.warning,
    required this.error,
    required this.info,
    required this.textPrimary,
    required this.textSecondary,
    required this.textDisabled,
  });
  
  // Light theme
  static const light = AppColors(
    primary: Color(0xFF2196F3),
    primaryDark: Color(0xFF1976D2),
    primaryLight: Color(0xFF64B5F6),
    secondary: Color(0xFF03A9F4),
    secondaryDark: Color(0xFF0288D1),
    secondaryLight: Color(0xFF4FC3F7),
    background: Color(0xFFF5F5F5),
    surface: Color(0xFFFFFFFF),
    border: Color(0xFFE0E0E0),
    success: Color(0xFF4CAF50),
    warning: Color(0xFFFFC107),
    error: Color(0xFFF44336),
    info: Color(0xFF2196F3),
    textPrimary: Color(0xFF212121),
    textSecondary: Color(0xFF757575),
    textDisabled: Color(0xFFBDBDBD),
  );
  
  // Dark theme
  static const dark = AppColors(
    primary: Color(0xFF90CAF9),
    primaryDark: Color(0xFF42A5F5),
    primaryLight: Color(0xFFBBDEFB),
    secondary: Color(0xFF81D4FA),
    secondaryDark: Color(0xFF29B6F6),
    secondaryLight: Color(0xFFB3E5FC),
    background: Color(0xFF121212),
    surface: Color(0xFF1E1E1E),
    border: Color(0xFF2C2C2C),
    success: Color(0xFF81C784),
    warning: Color(0xFFFFD54F),
    error: Color(0xFFE57373),
    info: Color(0xFF64B5F6),
    textPrimary: Color(0xFFFFFFFF),
    textSecondary: Color(0xFFB0B0B0),
    textDisabled: Color(0xFF616161),
  );
  
  @override
  ThemeExtension<AppColors> copyWith({/* ... */}) { /* ... */ }
  
  @override
  ThemeExtension<AppColors> lerp(/* ... */) { /* ... */ }
}

// Usage
final color = context.appColors.primary;
```

## Typography

### Text Styles

```dart
// lib/theme/app_text_styles.dart
class AppTextStyles extends ThemeExtension<AppTextStyles> {
  final TextStyle displayLarge;    // 32sp, Bold
  final TextStyle displayMedium;   // 28sp, Bold
  final TextStyle displaySmall;    // 24sp, Bold
  
  final TextStyle headlineLarge;   // 20sp, SemiBold
  final TextStyle headlineMedium;  // 18sp, SemiBold
  final TextStyle headlineSmall;   // 16sp, SemiBold
  
  final TextStyle bodyLarge;       // 16sp, Regular
  final TextStyle bodyMedium;      // 14sp, Regular
  final TextStyle bodySmall;       // 12sp, Regular
  
  final TextStyle labelLarge;      // 14sp, Medium
  final TextStyle labelMedium;     // 12sp, Medium
  final TextStyle labelSmall;      // 10sp, Medium
  
  const AppTextStyles({
    required this.displayLarge,
    required this.displayMedium,
    required this.displaySmall,
    required this.headlineLarge,
    required this.headlineMedium,
    required this.headlineSmall,
    required this.bodyLarge,
    required this.bodyMedium,
    required this.bodySmall,
    required this.labelLarge,
    required this.labelMedium,
    required this.labelSmall,
  });
  
  factory AppTextStyles.fromTheme(ThemeData theme) {
    return AppTextStyles(
      displayLarge: GoogleFonts.roboto(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        height: 1.2,
      ),
      displayMedium: GoogleFonts.roboto(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        height: 1.2,
      ),
      // ... other styles
    );
  }
  
  // ... copyWith and lerp
}

// Usage
Text('Heading', style: context.textStyles.displayLarge);
```

## Spacing System

### Fixed Spacing

```dart
// lib/common/presentation/spacing.dart
const spacing4 = SizedBox(height: 4);
const spacing8 = SizedBox(height: 8);
const spacing12 = SizedBox(height: 12);
const spacing16 = SizedBox(height: 16);
const spacing24 = SizedBox(height: 24);
const spacing32 = SizedBox(height: 32);
const spacing48 = SizedBox(height: 48);
const spacing64 = SizedBox(height: 64);

const spacingH4 = SizedBox(width: 4);
const spacingH8 = SizedBox(width: 8);
const spacingH12 = SizedBox(width: 12);
const spacingH16 = SizedBox(width: 16);
const spacingH24 = SizedBox(width: 24);
const spacingH32 = SizedBox(width: 32);

// Usage
Column(
  children: [
    Text('Title'),
    spacing16,
    Text('Content'),
  ],
)
```

### Spacing Scale

```dart
class AppSizes {
  static const double space4 = 4.0;
  static const double space8 = 8.0;
  static const double space12 = 12.0;
  static const double space16 = 16.0;
  static const double space24 = 24.0;
  static const double space32 = 32.0;
  static const double space48 = 48.0;
  static const double space64 = 64.0;
  
  static const double borderRadius = 12.0;
  static const double borderRadiusLarge = 16.0;
  static const double borderRadiusSmall = 8.0;
  
  static const double iconSize = 24.0;
  static const double iconSizeLarge = 32.0;
  static const double iconSizeSmall = 16.0;
}
```

## Elevation & Shadows

```dart
class AppShadows {
  static List<BoxShadow> small(BuildContext context) => [
    BoxShadow(
      color: Colors.black.withOpacity(0.05),
      blurRadius: 4,
      offset: const Offset(0, 2),
    ),
  ];
  
  static List<BoxShadow> medium(BuildContext context) => [
    BoxShadow(
      color: Colors.black.withOpacity(0.1),
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
  ];
  
  static List<BoxShadow> large(BuildContext context) => [
    BoxShadow(
      color: Colors.black.withOpacity(0.15),
      blurRadius: 16,
      offset: const Offset(0, 8),
    ),
  ];
}

// Usage
Container(
  decoration: BoxDecoration(
    boxShadow: AppShadows.medium(context),
  ),
)
```

## Border Radius

```dart
class AppBorderRadius {
  static const small = BorderRadius.all(Radius.circular(8));
  static const medium = BorderRadius.all(Radius.circular(12));
  static const large = BorderRadius.all(Radius.circular(16));
  static const extraLarge = BorderRadius.all(Radius.circular(24));
  static const circle = BorderRadius.all(Radius.circular(999));
}
```

## Component Patterns

### Card

```dart
Container(
  padding: const EdgeInsets.all(AppSizes.space16),
  decoration: BoxDecoration(
    color: context.appColors.surface,
    borderRadius: AppBorderRadius.medium,
    border: Border.all(color: context.appColors.border),
    boxShadow: AppShadows.small(context),
  ),
  child: content,
)
```

### Button

```dart
ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: context.appColors.primary,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(
      horizontal: AppSizes.space24,
      vertical: AppSizes.space16,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: AppBorderRadius.medium,
    ),
  ),
  onPressed: onPressed,
  child: Text('Button', style: context.textStyles.labelLarge),
)
```

## Accessibility

### Contrast Ratios

- Normal text: 4.5:1 minimum
- Large text (18pt+): 3:1 minimum
- UI components: 3:1 minimum

### Touch Targets

- Minimum size: 44x44pt (iOS) or 48x48dp (Android)
- Spacing between targets: 8pt minimum

## Best Practices

### ✅ Do

1. Use design tokens consistently
2. Never hardcode colors
3. Use spacing system
4. Support dark mode
5. Test accessibility

### ❌ Don't

1. Don't hardcode sizes
2. Don't skip semantic colors
3. Don't forget contrast ratios
4. Don't ignore touch targets

## Next Steps

- **Animations:** Learn in [12_ANIMATION_GUIDELINES.md](12_ANIMATION_GUIDELINES.md)
- **Responsive:** Adapt in [13_RESPONSIVE_DESIGN.md](13_RESPONSIVE_DESIGN.md)

---

**Your design system is now complete and consistent!**

