# Animation Guidelines

Create smooth, purposeful animations that enhance user experience without distracting.

## Animation Principles

### Duration Standards

```dart
// Standard durations
const animationFast = Duration(milliseconds: 150);
const animationNormal = Duration(milliseconds: 250);
const animationSlow = Duration(milliseconds: 400);

// Component-specific
const buttonPress = Duration(milliseconds: 100);
const pageTransition = Duration(milliseconds: 300);
const modalAppear = Duration(milliseconds: 250);
const tooltipShow = Duration(milliseconds: 150);
```

### Curve Selection

```dart
// Easing curves
const easeIn = Curves.easeIn;           // Starting slow
const easeOut = Curves.easeOut;         // Ending slow
const easeInOut = Curves.easeInOut;     // Both ends slow
const fastOutSlowIn = Curves.fastOutSlowIn; // Material Design standard

// Special curves
const bounce = Curves.bounceOut;        // Bouncy landing
const elastic = Curves.elasticOut;      // Spring effect
```

## Common Animations

### Fade Animation

```dart
AnimatedOpacity(
  opacity: isVisible ? 1.0 : 0.0,
  duration: animationNormal,
  curve: Curves.easeInOut,
  child: child,
)
```

### Scale Animation

```dart
AnimatedScale(
  scale: isExpanded ? 1.0 : 0.0,
  duration: animationNormal,
  curve: Curves.easeInOut,
  child: child,
)
```

### Slide Animation

```dart
AnimatedSlide(
  offset: isShowing ? Offset.zero : const Offset(0, 1),
  duration: animationNormal,
  curve: Curves.easeInOut,
  child: child,
)
```

### Size Animation

```dart
AnimatedSize(
  duration: animationNormal,
  curve: Curves.easeInOut,
  child: child,
)
```

## Implicit Animations

```dart
AnimatedContainer(
  duration: animationNormal,
  curve: Curves.easeInOut,
  width: isExpanded ? 200 : 100,
  height: isExpanded ? 200 : 100,
  color: isActive ? Colors.blue : Colors.grey,
  child: child,
)
```

## Explicit Animations

```dart
class AnimatedWidget extends StatefulWidget {
  @override
  State<AnimatedWidget> createState() => _AnimatedWidgetState();
}

class _AnimatedWidgetState extends State<AnimatedWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: animationNormal,
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.forward();
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: child,
    );
  }
}
```

## Page Transitions

```dart
PageRouteBuilder(
  pageBuilder: (context, animation, secondaryAnimation) => NextPage(),
  transitionsBuilder: (context, animation, secondaryAnimation, child) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  },
  transitionDuration: animationNormal,
)
```

## flutter_animate Package

```dart
import 'package:flutter_animate/flutter_animate.dart';

// Simple fade in
Text('Hello').animate().fadeIn(duration: 300.ms);

// Chained animations
Container()
    .animate()
    .fadeIn(duration: 300.ms)
    .scale(delay: 300.ms, duration: 300.ms)
    .then()
    .shake();

// Effects
widget
    .animate()
    .fade(duration: 300.ms)
    .scale(duration: 300.ms)
    .slide(duration: 300.ms)
    .blur(duration: 300.ms);
```

## Best Practices

### ✅ Do

1. Use standard durations (150/250/400ms)
2. Choose appropriate curves
3. Animate only transform and opacity
4. Keep animations subtle
5. Test on real devices

### ❌ Don't

1. Don't animate expensive properties
2. Don't make animations too long (>400ms)
3. Don't animate everything
4. Don't use complex animations unnecessarily
5. Don't skip performance testing

## Performance Tips

1. Use `const` constructors
2. Avoid `setState` during animations
3. Use `RepaintBoundary` for complex animations
4. Profile with Flutter DevTools
5. Test on low-end devices

## Next Steps

- **Responsive:** Learn in [13_RESPONSIVE_DESIGN.md](13_RESPONSIVE_DESIGN.md)
- **Performance:** Optimize in [15_PERFORMANCE_OPTIMIZATION.md](15_PERFORMANCE_OPTIMIZATION.md)

---

**Your animations are now smooth and performant!**

