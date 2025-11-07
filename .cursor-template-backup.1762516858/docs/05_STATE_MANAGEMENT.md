# State Management

Complete guide to state management using Riverpod and BaseNotifier pattern - type-safe, scalable, and testable.

## Philosophy

> **"State management should be invisible when working correctly, obvious when debugging."**

### Key Principles

1. **Single Source of Truth:** One state, multiple consumers
2. **Immutability:** States never mutate, always replace
3. **Type Safety:** Compile-time errors over runtime surprises
4. **Predictability:** Same input → Same output
5. **Testability:** Easy to test in isolation

## Architecture Overview

```
┌─────────────────────────────────────────┐
│           UI (Presentation)             │
│  ┌──────────────────────────────────┐   │
│  │   Widgets watch Providers        │   │
│  └──────────────────────────────────┘   │
│               ↓ reads                   │
├─────────────────────────────────────────┤
│         Providers (Domain)              │
│  ┌──────────────────────────────────┐   │
│  │  NotifierProvider<BaseState<T>>   │   │
│  └──────────────────────────────────┘   │
│               ↓ uses                    │
├─────────────────────────────────────────┤
│        Repository (Data)                │
│  ┌──────────────────────────────────┐   │
│  │   EitherFailureOr<T>             │   │
│  └──────────────────────────────────┘   │
└─────────────────────────────────────────┘
```

## BaseState Pattern

### State Types

```dart
import 'package:q_architecture/q_architecture.dart';

// Base sealed class (one of four states)
sealed class BaseState<T> {
  const BaseState();
}

// Initial state (before any operation)
class BaseInitial<T> extends BaseState<T> {
  const BaseInitial();
}

// Loading state (operation in progress)
class BaseLoading<T> extends BaseState<T> {
  const BaseLoading();
}

// Success state (has data)
class BaseData<T> extends BaseState<T> {
  final T data;
  const BaseData(this.data);
}

// Error state (has failure)
class BaseError<T> extends BaseState<T> {
  final Failure failure;
  const BaseError(this.failure);
}
```

### Why BaseState?

**Type Safe:**
```dart
// ✅ GOOD: Exhaustive pattern matching
Widget build(BuildContext context) {
  return switch (state) {
    BaseLoading() => LoadingWidget(),
    BaseData(:final data) => DataWidget(data),
    BaseError(:final failure) => ErrorWidget(failure),
    BaseInitial() => InitialWidget(),
  };
}

// Compiler error if you miss a case!
```

**Simple:**
```dart
// ✅ GOOD: One line to transition states
state = const BaseLoading();
state = BaseData(users);
state = BaseError(failure);
```

## BaseNotifier Pattern

### Basic Notifier

```dart
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:q_architecture/q_architecture.dart';

// 1. Define provider
final userNotifierProvider =
    NotifierProvider<UserNotifier, BaseState<User>>(
  () => UserNotifier(),
);

// 2. Implement notifier
class UserNotifier extends BaseNotifier<User> {
  late UserRepository _repository;
  
  // 3. Initialize dependencies
  @override
  void prepareForBuild() {
    _repository = ref.watch(userRepositoryProvider);
  }
  
  // 4. Implement business logic
  Future<void> loadUser(String id) async {
    state = const BaseLoading();
    final result = await _repository.getUser(id);
    state = result.fold(BaseError.new, BaseData.new);
  }
  
  Future<void> updateUser(User user) async {
    state = const BaseLoading();
    final result = await _repository.updateUser(user);
    state = result.fold(BaseError.new, BaseData.new);
  }
  
  void clearUser() {
    state = const BaseInitial();
  }
}
```

### List Notifier

```dart
final usersListNotifierProvider =
    NotifierProvider<UsersListNotifier, BaseState<List<User>>>(
  () => UsersListNotifier(),
);

class UsersListNotifier extends BaseNotifier<List<User>> {
  late UserRepository _repository;
  
  @override
  void prepareForBuild() {
    _repository = ref.watch(userRepositoryProvider);
  }
  
  Future<void> loadUsers() async {
    state = const BaseLoading();
    final result = await _repository.getUsers();
    state = result.fold(
      BaseError.new,
      (users) {
        // Apply sorting logic
        users.sort((a, b) => a.name.compareTo(b.name));
        return BaseData(users);
      },
    );
  }
  
  Future<void> addUser(User user) async {
    final currentUsers = state.dataOrNull;
    if (currentUsers == null) return;
    
    state = const BaseLoading();
    final result = await _repository.createUser(user);
    
    state = result.fold(
      BaseError.new,
      (newUser) {
        final updated = [...currentUsers, newUser];
        updated.sort((a, b) => a.name.compareTo(b.name));
        return BaseData(updated);
      },
    );
  }
  
  Future<void> removeUser(String userId) async {
    final currentUsers = state.dataOrNull;
    if (currentUsers == null) return;
    
    state = const BaseLoading();
    final result = await _repository.deleteUser(userId);
    
    state = result.fold(
      BaseError.new,
      (_) {
        final updated = currentUsers
            .where((user) => user.id != userId)
            .toList();
        return BaseData(updated);
      },
    );
  }
  
  void filterUsers(String query) {
    final currentUsers = state.dataOrNull;
    if (currentUsers == null) return;
    
    if (query.isEmpty) {
      loadUsers();
      return;
    }
    
    final filtered = currentUsers
        .where((user) =>
            user.name.toLowerCase().contains(query.toLowerCase()) ||
            user.email.toLowerCase().contains(query.toLowerCase()))
        .toList();
    
    state = BaseData(filtered);
  }
}
```

### Complex Notifier with Multiple Dependencies

```dart
final dashboardNotifierProvider =
    NotifierProvider<DashboardNotifier, BaseState<DashboardData>>(
  () => DashboardNotifier(),
);

class DashboardNotifier extends BaseNotifier<DashboardData> {
  late UserRepository _userRepository;
  late AnalyticsRepository _analyticsRepository;
  late StatsRepository _statsRepository;
  
  @override
  void prepareForBuild() {
    _userRepository = ref.watch(userRepositoryProvider);
    _analyticsRepository = ref.watch(analyticsRepositoryProvider);
    _statsRepository = ref.watch(statsRepositoryProvider);
  }
  
  Future<void> loadDashboard() async {
    state = const BaseLoading();
    
    // Load multiple data sources in parallel
    final results = await Future.wait([
      _userRepository.getCurrentUser(),
      _analyticsRepository.getAnalytics(),
      _statsRepository.getStats(),
    ]);
    
    // Check if all succeeded
    final userResult = results[0] as Either<Failure, User>;
    final analyticsResult = results[1] as Either<Failure, Analytics>;
    final statsResult = results[2] as Either<Failure, Stats>;
    
    // Handle errors
    if (userResult.isLeft) {
      state = BaseError(userResult.left);
      return;
    }
    if (analyticsResult.isLeft) {
      state = BaseError(analyticsResult.left);
      return;
    }
    if (statsResult.isLeft) {
      state = BaseError(statsResult.left);
      return;
    }
    
    // All succeeded - combine data
    final dashboardData = DashboardData(
      user: userResult.right,
      analytics: analyticsResult.right,
      stats: statsResult.right,
    );
    
    state = BaseData(dashboardData);
  }
}
```

## Using State in UI

### Basic Usage with HookConsumerWidget

```dart
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class UserProfilePage extends HookConsumerWidget {
  static const routeName = '/profile';
  final String userId;
  
  const UserProfilePage({
    super.key,
    required this.userId,
  });
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userNotifierProvider);
    
    // Load user on mount
    useEffect(
      () {
        Future.microtask(() {
          ref.read(userNotifierProvider.notifier).loadUser(userId);
        });
        return null;
      },
      [userId],
    );
    
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: switch (userState) {
        BaseLoading() => const Center(
            child: CircularProgressIndicator(),
          ),
        BaseData(:final data) => UserProfileContent(user: data),
        BaseError(:final failure) => Center(
            child: Text('Error: ${failure.message}'),
          ),
        BaseInitial() => const SizedBox.shrink(),
      },
    );
  }
}
```

### With Refresh Capability

```dart
class UsersListPage extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersState = ref.watch(usersListNotifierProvider);
    
    useEffect(() {
      Future.microtask(() {
        ref.read(usersListNotifierProvider.notifier).loadUsers();
      });
      return null;
    }, const []);
    
    Future<void> onRefresh() async {
      await ref.read(usersListNotifierProvider.notifier).loadUsers();
    }
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: onRefresh,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: onRefresh,
        child: switch (usersState) {
          BaseLoading() => const LoadingShimmer(),
          BaseData(:final data) => ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) =>
                  UserListItem(user: data[index]),
            ),
          BaseError(:final failure) => ErrorView(
              failure: failure,
              onRetry: onRefresh,
            ),
          BaseInitial() => const SizedBox.shrink(),
        },
      ),
    );
  }
}
```

### Optimistic Updates

```dart
class TodoNotifier extends BaseNotifier<List<Todo>> {
  late TodoRepository _repository;
  
  @override
  void prepareForBuild() {
    _repository = ref.watch(todoRepositoryProvider);
  }
  
  Future<void> toggleTodo(String todoId) async {
    final currentTodos = state.dataOrNull;
    if (currentTodos == null) return;
    
    // Optimistic update: Update UI immediately
    final optimisticTodos = currentTodos.map((todo) {
      if (todo.id == todoId) {
        return todo.copyWith(completed: !todo.completed);
      }
      return todo;
    }).toList();
    
    state = BaseData(optimisticTodos);
    
    // Make API call
    final result = await _repository.toggleTodo(todoId);
    
    // If failed, revert to original state
    result.fold(
      (failure) {
        state = BaseData(currentTodos);
        // Show error message
      },
      (updatedTodo) {
        // Success - already updated optimistically
      },
    );
  }
}
```

## Advanced Patterns

### Pagination

```dart
final paginatedUsersProvider =
    NotifierProvider<PaginatedUsersNotifier, BaseState<PaginatedUsers>>(
  () => PaginatedUsersNotifier(),
);

class PaginatedUsers {
  final List<User> users;
  final int page;
  final int totalPages;
  final bool hasMore;
  
  const PaginatedUsers({
    required this.users,
    required this.page,
    required this.totalPages,
    required this.hasMore,
  });
}

class PaginatedUsersNotifier extends BaseNotifier<PaginatedUsers> {
  late UserRepository _repository;
  
  @override
  void prepareForBuild() {
    _repository = ref.watch(userRepositoryProvider);
  }
  
  Future<void> loadFirstPage() async {
    state = const BaseLoading();
    await _loadPage(1);
  }
  
  Future<void> loadNextPage() async {
    final currentData = state.dataOrNull;
    if (currentData == null || !currentData.hasMore) return;
    
    await _loadPage(currentData.page + 1);
  }
  
  Future<void> _loadPage(int page) async {
    final result = await _repository.getUsers(page: page, limit: 20);
    
    state = result.fold(
      BaseError.new,
      (response) {
        final currentUsers = state.dataOrNull?.users ?? [];
        
        final users = page == 1
            ? response.users
            : [...currentUsers, ...response.users];
        
        return BaseData(
          PaginatedUsers(
            users: users,
            page: page,
            totalPages: response.totalPages,
            hasMore: page < response.totalPages,
          ),
        );
      },
    );
  }
}
```

### Debounced Search

```dart
class SearchNotifier extends BaseNotifier<List<SearchResult>> {
  late SearchRepository _repository;
  Timer? _debounceTimer;
  
  @override
  void prepareForBuild() {
    _repository = ref.watch(searchRepositoryProvider);
  }
  
  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
  
  void search(String query) {
    // Cancel previous timer
    _debounceTimer?.cancel();
    
    // Show loading after 300ms
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      if (query.isEmpty) {
        state = const BaseData([]);
        return;
      }
      
      _performSearch(query);
    });
  }
  
  Future<void> _performSearch(String query) async {
    state = const BaseLoading();
    final result = await _repository.search(query);
    state = result.fold(BaseError.new, BaseData.new);
  }
}
```

### Form State

```dart
class UserFormNotifier extends BaseNotifier<User> {
  late UserRepository _repository;
  
  @override
  void prepareForBuild() {
    _repository = ref.watch(userRepositoryProvider);
    
    // Initialize with empty user
    state = const BaseData(User.empty());
  }
  
  void updateName(String name) {
    final currentUser = state.dataOrNull;
    if (currentUser == null) return;
    
    state = BaseData(currentUser.copyWith(name: name));
  }
  
  void updateEmail(String email) {
    final currentUser = state.dataOrNull;
    if (currentUser == null) return;
    
    state = BaseData(currentUser.copyWith(email: email));
  }
  
  Future<bool> saveUser() async {
    final user = state.dataOrNull;
    if (user == null) return false;
    
    state = const BaseLoading();
    final result = await _repository.createUser(user);
    
    return result.fold(
      (failure) {
        state = BaseError(failure);
        return false;
      },
      (savedUser) {
        state = BaseData(savedUser);
        return true;
      },
    );
  }
}
```

## Global State

### Simple Global State

```dart
// Use StateProvider for simple values
final themeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);

// Use in UI
class App extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    
    return MaterialApp(
      themeMode: themeMode,
      // ...
    );
  }
}

// Update
ref.read(themeProvider.notifier).state = ThemeMode.dark;
```

### Current User State

```dart
final currentUserProvider = StateProvider<User?>((ref) => null);

// Set after login
ref.read(currentUserProvider.notifier).state = user;

// Clear on logout
ref.read(currentUserProvider.notifier).state = null;

// Watch in UI
final currentUser = ref.watch(currentUserProvider);
if (currentUser == null) {
  // Show login
} else {
  // Show app
}
```

## Provider Communication

### Listening to Other Providers

```dart
class CartNotifier extends BaseNotifier<Cart> {
  @override
  void prepareForBuild() {
    // Watch current user
    final user = ref.watch(currentUserProvider);
    
    // Load cart for current user
    if (user != null) {
      _loadCart(user.id);
    }
  }
}
```

### Invalidating Providers

```dart
// After logout, invalidate all user-specific data
ref.invalidate(userNotifierProvider);
ref.invalidate(cartNotifierProvider);
ref.invalidate(ordersNotifierProvider);
```

## Testing

### Unit Testing Notifiers

```dart
void main() {
  late ProviderContainer container;
  late MockUserRepository mockRepository;
  
  setUp(() {
    mockRepository = MockUserRepository();
    container = ProviderContainer(
      overrides: [
        userRepositoryProvider.overrideWithValue(mockRepository),
      ],
    );
  });
  
  tearDown(() {
    container.dispose();
  });
  
  test('loads user successfully', () async {
    // Arrange
    final testUser = User(id: '1', name: 'Test');
    when(() => mockRepository.getUser('1'))
        .thenAnswer((_) async => Right(testUser));
    
    // Act
    final notifier = container.read(userNotifierProvider.notifier);
    await notifier.loadUser('1');
    
    // Assert
    final state = container.read(userNotifierProvider);
    expect(state, isA<BaseData<User>>());
    expect((state as BaseData).data.name, 'Test');
  });
  
  test('handles error correctly', () async {
    // Arrange
    when(() => mockRepository.getUser('1'))
        .thenAnswer((_) async => Left(Failure.generic()));
    
    // Act
    final notifier = container.read(userNotifierProvider.notifier);
    await notifier.loadUser('1');
    
    // Assert
    final state = container.read(userNotifierProvider);
    expect(state, isA<BaseError<User>>());
  });
}
```

### Widget Testing

```dart
void main() {
  testWidgets('displays user data', (tester) async {
    final container = ProviderContainer(
      overrides: [
        userNotifierProvider.overrideWith(() => MockUserNotifier()),
      ],
    );
    
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          home: UserProfilePage(userId: '1'),
        ),
      ),
    );
    
    // Initial loading
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    
    // After load
    await tester.pumpAndSettle();
    expect(find.text('Test User'), findsOneWidget);
  });
}
```

## Best Practices

### ✅ Do

1. **Use BaseNotifier for all state:**
```dart
class MyNotifier extends BaseNotifier<MyData> {
  // ✅ Type-safe, predictable
}
```

2. **Initialize in prepareForBuild:**
```dart
@override
void prepareForBuild() {
  _repository = ref.watch(repositoryProvider);
}
```

3. **Handle all state transitions:**
```dart
state = const BaseLoading();  // Show loading
final result = await _repository.getData();
state = result.fold(BaseError.new, BaseData.new);  // Handle both cases
```

### ❌ Don't

1. **Don't use mutable state:**
```dart
// ❌ BAD
class MyNotifier extends StateNotifier<List<Item>> {
  void addItem(Item item) {
    state.add(item);  // Mutation!
  }
}

// ✅ GOOD
class MyNotifier extends BaseNotifier<List<Item>> {
  void addItem(Item item) {
    final current = state.dataOrNull ?? [];
    state = BaseData([...current, item]);  // New list
  }
}
```

2. **Don't skip error handling:**
```dart
// ❌ BAD
Future<void> loadData() async {
  final data = await _repository.getData();
  state = BaseData(data);  // What if it fails?
}

// ✅ GOOD
Future<void> loadData() async {
  state = const BaseLoading();
  final result = await _repository.getData();
  state = result.fold(BaseError.new, BaseData.new);
}
```

## Quick Reference

### Provider Types

```dart
// State (simple value)
final counterProvider = StateProvider<int>((ref) => 0);

// Notifier (complex state with logic)
final userProvider = NotifierProvider<UserNotifier, BaseState<User>>(
  () => UserNotifier(),
);

// Future (async data)
final configProvider = FutureProvider<Config>((ref) async {
  return await loadConfig();
});

// Stream (real-time data)
final messagesProvider = StreamProvider<Message>((ref) {
  return ref.watch(socketServiceProvider).messages();
});
```

### Reading Providers

```dart
// Watch (rebuilds on change)
final value = ref.watch(provider);

// Read (one-time read, no rebuild)
final value = ref.read(provider);

// Listen (callback on change)
ref.listen(provider, (previous, next) {
  // Handle change
});
```

## Next Steps

- **Error Handling:** Learn in [06_ERROR_HANDLING.md](06_ERROR_HANDLING.md)
- **Feature Template:** Apply in [07_FEATURE_TEMPLATE.md](07_FEATURE_TEMPLATE.md) ⭐
- **Testing:** Details in [14_TESTING_STRATEGY.md](14_TESTING_STRATEGY.md)

---

**Your state is now managed like a pro!**

