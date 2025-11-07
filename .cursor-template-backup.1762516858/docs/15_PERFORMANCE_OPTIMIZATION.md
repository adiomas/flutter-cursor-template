# Performance Optimization

Optimize Flutter apps for smooth 60 FPS performance and minimal memory usage.

## Profiling

```bash
# Run with performance overlay
flutter run --profile

# Performance overlay in code
MaterialApp(
  showPerformanceOverlay: true,
)
```

## Common Optimizations

### Use const Constructors

```dart
// ❌ BAD
Text('Hello')

// ✅ GOOD
const Text('Hello')
```

### Avoid Rebuilds

```dart
// ❌ BAD
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ExpensiveWidget(), // Rebuilds on every build
        Consumer(
          builder: (context, ref, _) {
            final count = ref.watch(counterProvider);
            return Text('$count');
          },
        ),
      ],
    );
  }
}

// ✅ GOOD
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const ExpensiveWidget(), // Never rebuilds
        Consumer(
          builder: (context, ref, _) {
            final count = ref.watch(counterProvider);
            return Text('$count');
          },
        ),
      ],
    );
  }
}
```

### Use RepaintBoundary

```dart
RepaintBoundary(
  child: ComplexAnimation(),
)
```

### List Optimization

```dart
// Use ListView.builder for long lists
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) => ItemWidget(items[index]),
)

// Add keys for reordering
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) {
    return ItemWidget(
      key: ValueKey(items[index].id),
      item: items[index],
    );
  },
)
```

### Image Optimization

```dart
// Use cacheWidth/cacheHeight
Image.network(
  url,
  cacheWidth: 300,
  cacheHeight: 300,
)

// Precache images
precacheImage(NetworkImage(url), context);
```

## Memory Management

### Dispose Controllers

```dart
class MyWidget extends StatefulWidget {
  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  late ScrollController _controller;
  
  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
  }
  
  @override
  void dispose() {
    _controller.dispose(); // Important!
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return ListView(controller: _controller);
  }
}
```

### Cancel Streams

```dart
class MyWidget extends StatefulWidget {
  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  StreamSubscription? _subscription;
  
  @override
  void initState() {
    super.initState();
    _subscription = stream.listen((data) {});
  }
  
  @override
  void dispose() {
    _subscription?.cancel(); // Important!
    super.dispose();
  }
}
```

## Build Optimization

### Enable Obfuscation

```bash
flutter build apk --obfuscate --split-debug-info=build/debug-info
flutter build ios --obfuscate --split-debug-info=build/debug-info
```

### Split APKs by ABI

```bash
flutter build apk --split-per-abi
```

## Best Practices

### ✅ Do
- Profile before optimizing
- Use const everywhere possible
- Dispose resources
- Use RepaintBoundary for complex widgets
- Optimize images

### ❌ Don't
- Don't premature optimize
- Don't ignore memory leaks
- Don't skip profiling
- Don't load full-size images

---

**Your app is now fast and efficient!**

