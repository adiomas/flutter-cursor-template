# Responsive Design

Build adaptive UIs that work beautifully on phones, tablets, and desktops.

## Breakpoints

```dart
enum ScreenSize {
  mobile,    // < 600px
  tablet,    // 600px - 1024px
  desktop,   // > 1024px
}

extension ScreenSizeExtension on BuildContext {
  ScreenSize get screenSize {
    final width = MediaQuery.of(this).size.width;
    if (width < 600) return ScreenSize.mobile;
    if (width < 1024) return ScreenSize.tablet;
    return ScreenSize.desktop;
  }
  
  bool get isMobile => screenSize == ScreenSize.mobile;
  bool get isTablet => screenSize == ScreenSize.tablet;
  bool get isDesktop => screenSize == ScreenSize.desktop;
}
```

## Responsive Layouts

### LayoutBuilder

```dart
LayoutBuilder(
  builder: (context, constraints) {
    if (constraints.maxWidth < 600) {
      return MobileLayout();
    } else if (constraints.maxWidth < 1024) {
      return TabletLayout();
    } else {
      return DesktopLayout();
    }
  },
)
```

### MediaQuery

```dart
final size = MediaQuery.of(context).size;
final width = size.width;
final height = size.height;
final padding = MediaQuery.of(context).padding;
final viewInsets = MediaQuery.of(context).viewInsets; // Keyboard
```

### OrientationBuilder

```dart
OrientationBuilder(
  builder: (context, orientation) {
    return orientation == Orientation.portrait
        ? PortraitLayout()
        : LandscapeLayout();
  },
)
```

## Grid System

```dart
class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  
  @override
  Widget build(BuildContext context) {
    final columns = context.isMobile ? 1 : (context.isTablet ? 2 : 3);
    
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: children.length,
      itemBuilder: (context, index) => children[index],
    );
  }
}
```

## Adaptive Widgets

### Responsive Padding

```dart
Padding(
  padding: EdgeInsets.all(
    context.isMobile ? 16 : (context.isTablet ? 24 : 32),
  ),
  child: child,
)
```

### Responsive Font Sizes

```dart
Text(
  'Title',
  style: TextStyle(
    fontSize: context.isMobile ? 20 : (context.isTablet ? 24 : 28),
  ),
)
```

### Adaptive Navigation

```dart
class AdaptiveScaffold extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          if (!context.isMobile)
            NavigationRail(
              destinations: destinations,
              selectedIndex: selectedIndex,
              onDestinationSelected: onDestinationSelected,
            ),
          Expanded(child: content),
        ],
      ),
      bottomNavigationBar: context.isMobile
          ? BottomNavigationBar(
              items: items,
              currentIndex: selectedIndex,
              onTap: onDestinationSelected,
            )
          : null,
    );
  }
}
```

## flutter_screenutil

```yaml
dependencies:
  flutter_screenutil: ^5.9.3
```

```dart
// Initialize
ScreenUtilInit(
  designSize: const Size(375, 812), // Design dimensions
  builder: (context, child) => MaterialApp(
    home: HomePage(),
  ),
)

// Usage
Container(
  width: 100.w,        // Responsive width
  height: 50.h,        // Responsive height
  padding: EdgeInsets.all(10.r), // Responsive radius
  child: Text(
    'Text',
    style: TextStyle(fontSize: 14.sp), // Responsive font
  ),
)
```

## Platform Adaptivity

```dart
import 'dart:io';

Widget platformWidget() {
  if (Platform.isIOS) {
    return CupertinoButton(child: Text('iOS'));
  } else {
    return ElevatedButton(child: Text('Android'));
  }
}

// Better approach
import 'package:flutter/foundation.dart' show TargetPlatform;

Widget adaptiveButton(BuildContext context) {
  final platform = Theme.of(context).platform;
  
  return switch (platform) {
    TargetPlatform.iOS => CupertinoButton(child: Text('iOS')),
    TargetPlatform.android => ElevatedButton(child: Text('Android')),
    _ => ElevatedButton(child: Text('Default')),
  };
}
```

## Safe Area

```dart
SafeArea(
  child: Scaffold(
    body: content,
  ),
)

// With custom padding
SafeArea(
  minimum: const EdgeInsets.all(16),
  child: content,
)
```

## Best Practices

### ✅ Do

1. Test on multiple screen sizes
2. Use breakpoints consistently
3. Support landscape orientation
4. Handle keyboard insets
5. Use SafeArea for notches

### ❌ Don't

1. Don't hardcode dimensions
2. Don't ignore tablet layouts
3. Don't forget landscape mode
4. Don't skip real device testing
5. Don't assume screen size

## Testing

```dart
testWidgets('renders correctly on mobile', (tester) async {
  tester.view.physicalSize = const Size(375, 812);
  tester.view.devicePixelRatio = 2.0;
  
  await tester.pumpWidget(MyApp());
  
  expect(find.byType(MobileLayout), findsOneWidget);
});
```

## Next Steps

- **Testing:** Test responsiveness in [14_TESTING_STRATEGY.md](14_TESTING_STRATEGY.md)
- **Performance:** Optimize in [15_PERFORMANCE_OPTIMIZATION.md](15_PERFORMANCE_OPTIMIZATION.md)

---

**Your app is now responsive across all devices!**

