# Navigation System

Complete guide to implementing navigation with go_router - type-safe routes, deep linking, and smooth transitions.

## Setup

### Install Dependencies

```yaml
dependencies:
  go_router: ^14.2.3
```

### Basic Router Configuration

**File:** `lib/common/domain/router/app_router.dart`

```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    routes: [
      // Auth routes
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      
      // Main app routes
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/tasks',
        builder: (context, state) => const TasksPage(),
        routes: [
          GoRoute(
            path: 'new',
            builder: (context, state) => const TaskDetailsPage(),
          ),
          GoRoute(
            path: ':id',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return TaskDetailsPage(taskId: id);
            },
          ),
        ],
      ),
    ],
    
    // Redirect logic
    redirect: (context, state) {
      final isLoggedIn = ref.read(authStateProvider).isLoggedIn;
      final isGoingToLogin = state.matchedLocation == '/login';
      
      if (!isLoggedIn && !isGoingToLogin) {
        return '/login';
      }
      
      if (isLoggedIn && isGoingToLogin) {
        return '/home';
      }
      
      return null;
    },
    
    // Error handling
    errorBuilder: (context, state) => ErrorPage(error: state.error),
  );
});
```

## Route Patterns

### Simple Route

```dart
GoRoute(
  path: '/profile',
  builder: (context, state) => const ProfilePage(),
),
```

### Route with Parameters

```dart
GoRoute(
  path: '/users/:userId',
  builder: (context, state) {
    final userId = state.pathParameters['userId']!;
    return UserProfilePage(userId: userId);
  },
),
```

### Nested Routes

```dart
GoRoute(
  path: '/tasks',
  builder: (context, state) => const TasksPage(),
  routes: [
    GoRoute(
      path: ':taskId',
      builder: (context, state) {
        final taskId = state.pathParameters['taskId']!;
        return TaskDetailsPage(taskId: taskId);
      },
    ),
    GoRoute(
      path: 'new',
      builder: (context, state) => const TaskDetailsPage(),
    ),
  ],
),
```

### Routes with Query Parameters

```dart
GoRoute(
  path: '/search',
  builder: (context, state) {
    final query = state.uri.queryParameters['q'] ?? '';
    final category = state.uri.queryParameters['category'];
    return SearchPage(query: query, category: category);
  },
),

// Navigate: context.go('/search?q=flutter&category=mobile')
```

### Routes with Extra Data

```dart
GoRoute(
  path: '/checkout',
  builder: (context, state) {
    final cart = state.extra as Cart;
    return CheckoutPage(cart: cart);
  },
),

// Navigate: context.go('/checkout', extra: cart)
```

## Navigation Methods

### Declarative Navigation (Replace)

```dart
// Replace current route
context.go('/home');

// With parameters
context.go('/users/123');

// With query params
context.go('/search?q=flutter');

// With extra data
context.go('/checkout', extra: cart);
```

### Imperative Navigation (Push)

```dart
// Push new route
context.push('/tasks/new');

// Push and wait for result
final result = await context.push<bool>('/confirm');
if (result == true) {
  // User confirmed
}
```

### Pop Navigation

```dart
// Pop current route
context.pop();

// Pop with result
context.pop(true);
```

### Named Routes Helper

```dart
class AppRoutes {
  static const home = '/home';
  static const tasks = '/tasks';
  static const taskDetails = '/tasks/:id';
  
  static String taskDetailsPath(String id) => '/tasks/$id';
}

// Usage
context.go(AppRoutes.home);
context.go(AppRoutes.taskDetailsPath('123'));
```

## Deep Linking

### iOS Configuration

**ios/Runner/Info.plist:**

```xml
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleTypeRole</key>
    <string>Editor</string>
    <key>CFBundleURLName</key>
    <string>com.yourapp.deeplink</string>
    <key>CFBundleURLSchemes</key>
    <array>
      <string>yourapp</string>
    </array>
  </dict>
</array>
```

### Android Configuration

**android/app/src/main/AndroidManifest.xml:**

```xml
<intent-filter android:autoVerify="true">
    <action android:name="android.intent.action.VIEW" />
    <category android:name="android.intent.category.DEFAULT" />
    <category android:name="android.intent.category.BROWSABLE" />
    <data android:scheme="https" android:host="yourapp.com" />
    <data android:scheme="yourapp" />
</intent-filter>
```

### Handle Deep Links

```dart
// App automatically navigates to: yourapp://tasks/123
// URL: https://yourapp.com/tasks/123
```

## Auth Guard

```dart
final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);
  
  return GoRouter(
    refreshListenable: authState,  // Rebuild on auth change
    routes: routes,
    redirect: (context, state) {
      final isLoggedIn = authState.isLoggedIn;
      final isAuthRoute = state.matchedLocation.startsWith('/auth');
      
      // Not logged in, redirect to login
      if (!isLoggedIn && !isAuthRoute) {
        return '/auth/login';
      }
      
      // Logged in, trying to access auth, redirect to home
      if (isLoggedIn && isAuthRoute) {
        return '/home';
      }
      
      return null;  // No redirect
    },
  );
});
```

## Transitions

### Custom Transition

```dart
GoRoute(
  path: '/details',
  pageBuilder: (context, state) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: const DetailsPage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  },
),
```

### Slide Transition

```dart
GoRoute(
  path: '/settings',
  pageBuilder: (context, state) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: const SettingsPage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;
        
        final tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );
        
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  },
),
```

## Bottom Navigation

```dart
class MainScaffold extends StatelessWidget {
  final Widget child;
  
  const MainScaffold({super.key, required this.child});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _calculateSelectedIndex(context),
        onTap: (index) => _onItemTapped(index, context),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
  
  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/search')) return 1;
    if (location.startsWith('/profile')) return 2;
    return 0;
  }
  
  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/search');
        break;
      case 2:
        context.go('/profile');
        break;
    }
  }
}

// Router with bottom nav
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return MainScaffold(child: child);
        },
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const HomePage(),
          ),
          GoRoute(
            path: '/search',
            builder: (context, state) => const SearchPage(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfilePage(),
          ),
        ],
      ),
    ],
  );
});
```

## Best Practices

### ✅ Do

1. Use named routes constants
2. Handle deep links
3. Implement auth guards
4. Provide error pages
5. Use type-safe parameters

### ❌ Don't

1. Don't hardcode routes
2. Don't skip error handling
3. Don't forget to pop dialogs
4. Don't use context.go for temporary screens

## Quick Reference

```dart
// Navigation
context.go('/path');           // Replace
context.push('/path');         // Push
context.pop();                 // Pop
context.pop(result);           // Pop with result

// With parameters
context.go('/users/$userId');
context.go('/search?q=query');
context.go('/checkout', extra: data);

// Get parameters
final id = state.pathParameters['id']!;
final query = state.uri.queryParameters['q'];
final data = state.extra as MyData;

// Check current location
final location = GoRouterState.of(context).matchedLocation;
```

## Next Steps

- **Data Layer:** Learn in [09_DATA_LAYER.md](09_DATA_LAYER.md)
- **UI Components:** Build in [10_UI_COMPONENT_LIBRARY.md](10_UI_COMPONENT_LIBRARY.md)

---

**Your navigation is now declarative and type-safe!**

