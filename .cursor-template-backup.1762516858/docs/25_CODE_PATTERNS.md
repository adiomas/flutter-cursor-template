# Code Patterns

Common patterns and anti-patterns in Flutter development.

## Design Patterns

### Repository Pattern
```dart
// ✅ GOOD: Single source of truth
abstract interface class DataRepository {
  Future<List<Data>> getData();
}

class DataRepositoryImpl implements DataRepository {
  final ApiClient _client;
  
  @override
  Future<List<Data>> getData() async {
    return await _client.fetchData();
  }
}
```

### Factory Pattern
```dart
// ✅ GOOD: Create objects based on type
abstract class Shape {
  factory Shape(String type) {
    return switch (type) {
      'circle' => Circle(),
      'square' => Square(),
      _ => throw ArgumentError('Unknown type'),
    };
  }
}
```

### Singleton Pattern
```dart
// ✅ GOOD: Single instance
class AppConfig {
  static final AppConfig _instance = AppConfig._internal();
  factory AppConfig() => _instance;
  AppConfig._internal();
  
  String apiKey = '';
}
```

## Anti-Patterns

### God Object
```dart
// ❌ BAD: One class does everything
class UserManager {
  void login() {}
  void logout() {}
  void updateProfile() {}
  void deleteAccount() {}
  void sendEmail() {}
  void uploadPhoto() {}
  // 50 more methods...
}

// ✅ GOOD: Separate concerns
class AuthService {
  void login() {}
  void logout() {}
}

class ProfileService {
  void updateProfile() {}
  void deleteAccount() {}
}
```

### Magic Numbers
```dart
// ❌ BAD
if (status == 200) {}

// ✅ GOOD
const statusOk = 200;
if (status == statusOk) {}
```

### Callback Hell
```dart
// ❌ BAD
getData((data) {
  processData(data, (processed) {
    saveData(processed, (saved) {
      // ...
    });
  });
});

// ✅ GOOD
final data = await getData();
final processed = await processData(data);
await saveData(processed);
```

## Best Practices

### Use const
```dart
// ✅ GOOD
const Text('Hello')
const Padding(padding: EdgeInsets.all(8))
```

### Null Safety
```dart
// ✅ GOOD
String? nullableString;
final nonNull = nullableString ?? 'default';

// Use null-aware operators
user?.name
list?.first
```

### Extension Methods
```dart
// ✅ GOOD: Extend functionality
extension StringExtension on String {
  String capitalize() {
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}

// Usage
'hello'.capitalize() // 'Hello'
```

---

**Follow these patterns for clean code!**

