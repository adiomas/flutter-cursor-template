---
description: Performance optimization with real-time Flutter docs
globs:
  - lib/**/*.dart
alwaysApply: false
---

# Performance Optimization Rules

## Context7 Auto-Load

```
@Docs Flutter performance optimization
@Docs Flutter rendering pipeline
@Docs Flutter memory management
```

## When to Auto-Apply

Trigger when user mentions:
- "sporo", "laguje", "performance", "optimization"
- "memory", "leak", "fps"
- Large lists without ListView.builder
- Missing const constructors
- Heavy computations in build()

## Patterns

### Use ListView.builder
Load: @Docs Flutter ListView.builder

Always use `ListView.builder` for dynamic lists:
```dart
// ❌ BAD
ListView(
  children: items.map((item) => ItemWidget(item)).toList(),
)

// ✅ GOOD
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) {
    return ItemWidget(items[index]);
  },
)
```

### Const Optimization
Load: @Docs Flutter const constructors

Use `const` constructors wherever possible:
```dart
// ❌ BAD
return Container(
  padding: EdgeInsets.all(16),
  child: Text('Hello'),
)

// ✅ GOOD
return Container(
  padding: const EdgeInsets.all(16),
  child: const Text('Hello'),
)
```

### Image Optimization
Load: @Docs Flutter cached_network_image

Always cache network images:
```dart
// ❌ BAD
Image.network(imageUrl)

// ✅ GOOD
CachedNetworkImage(
  imageUrl: imageUrl,
  placeholder: (context, url) => const CircularProgressIndicator(),
  errorWidget: (context, url, error) => const Icon(Icons.error),
)
```

### Avoid Heavy Computations in build()
```dart
// ❌ BAD
@override
Widget build(BuildContext context) {
  final processedData = heavyComputation(data); // Runs on every rebuild!
  return Text(processedData);
}

// ✅ GOOD
@override
Widget build(BuildContext context) {
  final processedData = useMemoized(() => heavyComputation(data), [data]);
  return Text(processedData);
}
```

### Use Keys for ListView Items
```dart
// ✅ GOOD
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) {
    return ItemWidget(
      key: ValueKey(items[index].id), // Add key for efficient updates
      item: items[index],
    );
  },
)
```

## References

@docs/15_PERFORMANCE_OPTIMIZATION.md

