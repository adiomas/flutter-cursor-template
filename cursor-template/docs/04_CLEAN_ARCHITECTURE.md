# Clean Architecture

Feature-first clean architecture pattern for Flutter applications - scalable, testable, and maintainable.

## Core Principles

### The Dependency Rule

> **"Source code dependencies must point only inward, toward higher-level policies."**

```
┌─────────────────────────────────────┐
│     Presentation Layer (UI)         │
│  ┌───────────────────────────────┐  │
│  │   Domain Layer (Business)     │  │
│  │  ┌─────────────────────────┐  │  │
│  │  │   Data Layer (External) │  │  │
│  │  └─────────────────────────┘  │  │
│  └───────────────────────────────┘  │
└─────────────────────────────────────┘

Data → Domain → Presentation
(Inward dependency flow)
```

**Key Rules:**
1. **Domain** never depends on Data or Presentation
2. **Data** implements interfaces defined in Domain
3. **Presentation** uses Domain, never Data directly
4. **Dependencies** always point inward

## Project Structure

### Feature-First Organization

```
lib/
├── common/                      # Shared across all features
│   ├── constants/
│   │   └── app_constants.dart   # App-wide constants
│   ├── data/                    # Shared data infrastructure
│   │   ├── models/             # API response models
│   │   ├── repositories/       # Common repositories
│   │   ├── services/           # External services
│   │   └── providers.dart      # Data providers
│   ├── domain/                 # Shared business logic
│   │   ├── entities/           # Core entities
│   │   ├── notifiers/          # Global state
│   │   ├── providers/          # DI providers
│   │   └── router/             # Navigation
│   ├── presentation/           # Reusable UI
│   │   ├── widgets/           # Common widgets
│   │   └── mixins/            # Widget mixins
│   └── utils/                 # Helper functions
│
├── features/                   # Feature modules
│   ├── auth/                  # Authentication feature
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   └── user_model.dart
│   │   │   └── repositories/
│   │   │       └── auth_repository.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── user_entity.dart
│   │   │   └── notifiers/
│   │   │       └── auth_notifier.dart
│   │   └── presentation/
│   │       ├── pages/
│   │       │   ├── login_page.dart
│   │       │   └── register_page.dart
│   │       └── widgets/
│   │           └── auth_form.dart
│   │
│   ├── dashboard/             # Dashboard feature
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   └── profile/               # Profile feature
│       ├── data/
│       ├── domain/
│       └── presentation/
│
├── theme/                     # App theming
│   ├── app_colors.dart
│   ├── app_text_styles.dart
│   └── theme.dart
│
└── main.dart                  # App entry point
```

## Layer Responsibilities

### 1. Data Layer

**Purpose:** Handle all external data sources (API, database, storage)

**Responsibilities:**
- API communication
- Data persistence
- Model to Entity conversion
- Error handling
- Caching

**Components:**

#### Models (Data Transfer Objects)

```dart
// data/models/user_model.dart
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/user_entity.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final String id;
  final String email;
  @JsonKey(name: 'full_name')
  final String fullName;
  @JsonKey(name: 'avatar_url')
  final String? avatarUrl;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  
  const UserModel({
    required this.id,
    required this.email,
    required this.fullName,
    this.avatarUrl,
    required this.createdAt,
  });
  
  // JSON serialization
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
  
  Map<String, dynamic> toJson() => _$UserModelToJson(this);
  
  // Convert to domain entity
  UserEntity toDomain() {
    return UserEntity(
      id: id,
      email: email,
      name: fullName,
      avatarUrl: avatarUrl,
      createdAt: createdAt,
    );
  }
}
```

#### Repositories

```dart
// data/repositories/user_repository.dart
import 'package:either_dart/either.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:q_architecture/q_architecture.dart';
import '../models/user_model.dart';
import '../../domain/entities/user_entity.dart';

// Provider for dependency injection
final userRepositoryProvider = Provider<UserRepository>(
  (ref) => UserRepositoryImpl(
    ref.watch(supabaseServiceProvider),
  ),
);

// Repository interface (defined in domain layer conceptually)
abstract interface class UserRepository {
  EitherFailureOr<UserEntity> getUser(String id);
  EitherFailureOr<List<UserEntity>> getUsers();
  EitherFailureOr<UserEntity> updateUser(UserEntity user);
  EitherFailureOr<void> deleteUser(String id);
}

// Repository implementation
class UserRepositoryImpl implements UserRepository {
  final SupabaseService _supabase;
  
  UserRepositoryImpl(this._supabase);
  
  @override
  EitherFailureOr<UserEntity> getUser(String id) async {
    try {
      final response = await _supabase.client
          .from('users')
          .select()
          .eq('id', id)
          .single();
      
      final model = UserModel.fromJson(response);
      return Right(model.toDomain());
    } catch (e) {
      return Left(Failure.generic(error: e));
    }
  }
  
  @override
  EitherFailureOr<List<UserEntity>> getUsers() async {
    try {
      final response = await _supabase.client
          .from('users')
          .select();
      
      final users = (response as List)
          .map((json) => UserModel.fromJson(json).toDomain())
          .toList();
      
      return Right(users);
    } catch (e) {
      return Left(Failure.generic(error: e));
    }
  }
  
  @override
  EitherFailureOr<UserEntity> updateUser(UserEntity user) async {
    try {
      final response = await _supabase.client
          .from('users')
          .update({
            'full_name': user.name,
            'avatar_url': user.avatarUrl,
          })
          .eq('id', user.id)
          .select()
          .single();
      
      final model = UserModel.fromJson(response);
      return Right(model.toDomain());
    } catch (e) {
      return Left(Failure.generic(error: e));
    }
  }
  
  @override
  EitherFailureOr<void> deleteUser(String id) async {
    try {
      await _supabase.client
          .from('users')
          .delete()
          .eq('id', id);
      
      return const Right(null);
    } catch (e) {
      return Left(Failure.generic(error: e));
    }
  }
}
```

### 2. Domain Layer

**Purpose:** Business logic and rules, independent of external concerns

**Responsibilities:**
- Business entities
- State management
- Business rules
- Use cases

**Components:**

#### Entities

```dart
// domain/entities/user_entity.dart
import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String email;
  final String name;
  final String? avatarUrl;
  final DateTime createdAt;
  
  const UserEntity({
    required this.id,
    required this.email,
    required this.name,
    this.avatarUrl,
    required this.createdAt,
  });
  
  // Business logic methods
  String get displayName => name.isEmpty ? email : name;
  
  bool get hasAvatar => avatarUrl != null && avatarUrl!.isNotEmpty;
  
  bool get isNewUser {
    final now = DateTime.now();
    final diff = now.difference(createdAt);
    return diff.inDays < 7;
  }
  
  // Copy with for immutability
  UserEntity copyWith({
    String? id,
    String? email,
    String? name,
    String? avatarUrl,
    DateTime? createdAt,
  }) {
    return UserEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }
  
  @override
  List<Object?> get props => [id, email, name, avatarUrl, createdAt];
}
```

#### Notifiers (State Management)

```dart
// domain/notifiers/user_notifier.dart
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:q_architecture/q_architecture.dart';
import '../../data/repositories/user_repository.dart';
import '../entities/user_entity.dart';

final userNotifierProvider =
    NotifierProvider<UserNotifier, BaseState<UserEntity>>(
  () => UserNotifier(),
);

class UserNotifier extends BaseNotifier<UserEntity> {
  late UserRepository _repository;
  
  @override
  void prepareForBuild() {
    _repository = ref.watch(userRepositoryProvider);
  }
  
  Future<void> loadUser(String id) async {
    state = const BaseLoading();
    final result = await _repository.getUser(id);
    state = result.fold(BaseError.new, BaseData.new);
  }
  
  Future<void> updateUserName(String name) async {
    final currentUser = state.dataOrNull;
    if (currentUser == null) return;
    
    state = const BaseLoading();
    final updatedUser = currentUser.copyWith(name: name);
    final result = await _repository.updateUser(updatedUser);
    state = result.fold(BaseError.new, BaseData.new);
  }
  
  Future<void> deleteUser() async {
    final currentUser = state.dataOrNull;
    if (currentUser == null) return;
    
    state = const BaseLoading();
    final result = await _repository.deleteUser(currentUser.id);
    state = result.fold(BaseError.new, (_) => const BaseInitial());
  }
}
```

#### List Notifiers

```dart
// domain/notifiers/users_list_notifier.dart
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:q_architecture/q_architecture.dart';
import '../../data/repositories/user_repository.dart';
import '../entities/user_entity.dart';

final usersListNotifierProvider =
    NotifierProvider<UsersListNotifier, BaseState<List<UserEntity>>>(
  () => UsersListNotifier(),
);

class UsersListNotifier extends BaseNotifier<List<UserEntity>> {
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
        // Apply business logic: sort by name
        users.sort((a, b) => a.name.compareTo(b.name));
        return BaseData(users);
      },
    );
  }
  
  Future<void> searchUsers(String query) async {
    final currentUsers = state.dataOrNull;
    if (currentUsers == null) return;
    
    if (query.isEmpty) {
      await loadUsers();
      return;
    }
    
    // Filter in memory
    final filtered = currentUsers
        .where((user) =>
            user.name.toLowerCase().contains(query.toLowerCase()) ||
            user.email.toLowerCase().contains(query.toLowerCase()))
        .toList();
    
    state = BaseData(filtered);
  }
  
  void sortByName() {
    final users = state.dataOrNull;
    if (users == null) return;
    
    final sorted = List<UserEntity>.from(users)
      ..sort((a, b) => a.name.compareTo(b.name));
    
    state = BaseData(sorted);
  }
  
  void sortByDate() {
    final users = state.dataOrNull;
    if (users == null) return;
    
    final sorted = List<UserEntity>.from(users)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    
    state = BaseData(sorted);
  }
}
```

### 3. Presentation Layer

**Purpose:** UI components and user interaction

**Responsibilities:**
- Pages/Screens
- Widgets
- User input handling
- UI state
- Navigation

**Components:**

#### Pages

```dart
// presentation/pages/users_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../domain/notifiers/users_list_notifier.dart';
import '../widgets/user_list_item.dart';
import '../widgets/loading_shimmer.dart';

class UsersPage extends HookConsumerWidget {
  static const routeName = '/users';
  
  const UsersPage({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersState = ref.watch(usersListNotifierProvider);
    final searchQuery = useState('');
    
    // Load users on mount
    useEffect(
      () {
        Future.microtask(() {
          ref.read(usersListNotifierProvider.notifier).loadUsers();
        });
        return null;
      },
      const [],
    );
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(usersListNotifierProvider.notifier).loadUsers();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search users...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                searchQuery.value = value;
                ref
                    .read(usersListNotifierProvider.notifier)
                    .searchUsers(value);
              },
            ),
          ),
          
          // User list
          Expanded(
            child: switch (usersState) {
              BaseLoading() => const LoadingShimmer(),
              BaseError(:final failure) => Center(
                  child: Text('Error: ${failure.message}'),
                ),
              BaseData(:final data) => ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return UserListItem(user: data[index]);
                  },
                ),
              _ => const SizedBox.shrink(),
            },
          ),
        ],
      ),
    );
  }
}
```

#### Widgets

```dart
// presentation/widgets/user_list_item.dart
import 'package:flutter/material.dart';
import '../../domain/entities/user_entity.dart';

class UserListItem extends StatelessWidget {
  final UserEntity user;
  
  const UserListItem({
    super.key,
    required this.user,
  });
  
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: user.hasAvatar
            ? NetworkImage(user.avatarUrl!)
            : null,
        child: !user.hasAvatar
            ? Text(user.name[0].toUpperCase())
            : null,
      ),
      title: Text(user.displayName),
      subtitle: Text(user.email),
      trailing: user.isNewUser
          ? const Chip(
              label: Text('New'),
              backgroundColor: Colors.green,
            )
          : null,
      onTap: () {
        // Navigate to user details
      },
    );
  }
}
```

## Dependency Injection with Riverpod

### Provider Hierarchy

```dart
// common/data/providers.dart

// Services (lowest level)
final supabaseServiceProvider = Provider<SupabaseService>(
  (ref) => SupabaseService(Supabase.instance.client),
);

// Repositories (depend on services)
final userRepositoryProvider = Provider<UserRepository>(
  (ref) => UserRepositoryImpl(
    ref.watch(supabaseServiceProvider),
  ),
);

// Notifiers (depend on repositories)
final userNotifierProvider =
    NotifierProvider<UserNotifier, BaseState<UserEntity>>(
  () => UserNotifier(),
);
```

### Testing with Overrides

```dart
// test/user_notifier_test.dart
void main() {
  test('loads user successfully', () async {
    final container = ProviderContainer(
      overrides: [
        userRepositoryProvider.overrideWithValue(
          MockUserRepository(),
        ),
      ],
    );
    
    final notifier = container.read(userNotifierProvider.notifier);
    await notifier.loadUser('123');
    
    final state = container.read(userNotifierProvider);
    expect(state, isA<BaseData<UserEntity>>());
  });
}
```

## Cross-Feature Communication

### Shared Providers

```dart
// common/domain/providers/current_user_provider.dart
final currentUserProvider = StateProvider<UserEntity?>((ref) => null);

// Feature A: Auth sets current user
ref.read(currentUserProvider.notifier).state = user;

// Feature B: Profile reads current user
final currentUser = ref.watch(currentUserProvider);
```

### Event Bus (Use Sparingly)

```dart
// common/domain/providers/event_bus_provider.dart
final eventBusProvider = Provider<EventBus>((ref) => EventBus());

// Emit event
ref.read(eventBusProvider).fire(UserLoggedOut());

// Listen to event
ref.listen(eventBusProvider, (previous, next) {
  next.on<UserLoggedOut>().listen((event) {
    // Handle logout
  });
});
```

## Best Practices

### ✅ Do

**1. Keep Layers Separated:**
```dart
// ✅ GOOD: Data depends on Domain
class UserModel {
  UserEntity toDomain() => UserEntity(...);
}

// ❌ BAD: Domain depends on Data
class UserEntity {
  static fromModel(UserModel model) => UserEntity(...);
}
```

**2. Use Interfaces:**
```dart
// ✅ GOOD: Define interface
abstract interface class UserRepository {
  Future<User> getUser();
}

// ❌ BAD: Concrete implementation only
class UserRepository {
  Future<User> getUser() {}
}
```

**3. Immutable Entities:**
```dart
// ✅ GOOD: Immutable with copyWith
class UserEntity {
  final String name;
  const UserEntity({required this.name});
  UserEntity copyWith({String? name}) => UserEntity(name: name ?? this.name);
}

// ❌ BAD: Mutable
class UserEntity {
  String name;
  UserEntity({required this.name});
}
```

### ❌ Don't

**1. Skip Layers:**
```dart
// ❌ BAD: Presentation accesses Data directly
class UserPage extends ConsumerWidget {
  @override
  Widget build(context, ref) {
    final repo = ref.watch(userRepositoryProvider);
    // Use notifier instead!
  }
}
```

**2. Mix Responsibilities:**
```dart
// ❌ BAD: Entity knows about JSON
class UserEntity {
  factory UserEntity.fromJson(Map<String, dynamic> json) {}
}
```

**3. Circular Dependencies:**
```dart
// ❌ BAD: A depends on B, B depends on A
class FeatureANotifier {
  void method() {
    ref.watch(featureBNotifierProvider);
  }
}

class FeatureBNotifier {
  void method() {
    ref.watch(featureANotifierProvider);  // Circular!
  }
}
```

## Feature Module Template

Standard structure for every feature:

```
features/
└── feature_name/
    ├── data/
    │   ├── models/
    │   │   └── feature_model.dart
    │   └── repositories/
    │       └── feature_repository.dart
    ├── domain/
    │   ├── entities/
    │   │   └── feature_entity.dart
    │   └── notifiers/
    │       ├── feature_notifier.dart
    │       └── feature_list_notifier.dart
    └── presentation/
        ├── pages/
        │   ├── feature_page.dart
        │   └── feature_details_page.dart
        └── widgets/
            ├── feature_list_item.dart
            └── feature_form.dart
```

## Next Steps

- **State Management:** Deep dive in [05_STATE_MANAGEMENT.md](05_STATE_MANAGEMENT.md)
- **Error Handling:** Learn patterns in [06_ERROR_HANDLING.md](06_ERROR_HANDLING.md)
- **Feature Template:** Use [07_FEATURE_TEMPLATE.md](07_FEATURE_TEMPLATE.md) ⭐

---

**Your architecture is now clean, scalable, and testable!**

