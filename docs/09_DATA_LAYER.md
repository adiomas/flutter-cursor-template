# Data Layer

Advanced patterns for data management - repositories, caching, offline support, and Supabase integration.

## Repository Pattern

### Standard Repository

```dart
abstract interface class UserRepository {
  EitherFailureOr<List<User>> getUsers();
  EitherFailureOr<User> getUser(String id);
  EitherFailureOr<User> createUser(User user);
  EitherFailureOr<User> updateUser(User user);
  EitherFailureOr<void> deleteUser(String id);
}

class UserRepositoryImpl implements UserRepository {
  final SupabaseClient _client;
  
  UserRepositoryImpl(this._client);
  
  @override
  EitherFailureOr<List<User>> getUsers() async {
    try {
      final response = await _client
          .from('users')
          .select()
          .order('created_at', ascending: false);
      
      return Right(
        (response as List)
            .map((json) => UserModel.fromJson(json).toDomain())
            .toList(),
      );
    } catch (e) {
      return Left(Failure.generic(error: e));
    }
  }
  
  // ... other methods
}
```

## Caching Strategies

### In-Memory Cache

```dart
class CachedUserRepository implements UserRepository {
  final UserRepository _repository;
  final Map<String, User> _cache = {};
  final Duration _cacheValidity = const Duration(minutes: 5);
  DateTime? _lastFetch;
  
  CachedUserRepository(this._repository);
  
  @override
  EitherFailureOr<User> getUser(String id) async {
    // Check cache
    if (_cache.containsKey(id) && _isCacheValid()) {
      return Right(_cache[id]!);
    }
    
    // Fetch from network
    final result = await _repository.getUser(id);
    
    result.fold(
      (failure) {}, // Don't cache failures
      (user) {
        _cache[id] = user;
        _lastFetch = DateTime.now();
      },
    );
    
    return result;
  }
  
  bool _isCacheValid() {
    if (_lastFetch == null) return false;
    return DateTime.now().difference(_lastFetch!) < _cacheValidity;
  }
  
  void invalidateCache() {
    _cache.clear();
    _lastFetch = null;
  }
}
```

### Persistent Cache with Hive

```yaml
dependencies:
  hive: ^2.2.3
  hive_flutter: ^1.1.0
```

```dart
class PersistentUserRepository implements UserRepository {
  final UserRepository _repository;
  final Box<String> _cache;
  
  PersistentUserRepository(this._repository, this._cache);
  
  @override
  EitherFailureOr<User> getUser(String id) async {
    // Try cache first
    final cachedJson = _cache.get(id);
    if (cachedJson != null) {
      try {
        final user = UserModel.fromJson(json.decode(cachedJson)).toDomain();
        return Right(user);
      } catch (_) {}
    }
    
    // Fetch from network
    final result = await _repository.getUser(id);
    
    result.fold(
      (failure) {},
      (user) {
        final model = UserModel.fromDomain(user);
        _cache.put(id, json.encode(model.toJson()));
      },
    );
    
    return result;
  }
}
```

## Supabase Patterns

### RPC Functions

```dart
class AnalyticsRepository {
  final SupabaseClient _client;
  
  EitherFailureOr<Analytics> getAnalytics(String userId) async {
    try {
      final response = await _client.rpc(
        'get_user_analytics',
        params: {'user_id': userId},
      );
      
      return Right(AnalyticsModel.fromJson(response).toDomain());
    } catch (e) {
      return Left(Failure.generic(error: e));
    }
  }
}
```

### Real-time Subscriptions

```dart
class MessageRepository {
  final SupabaseClient _client;
  
  Stream<List<Message>> watchMessages(String chatId) {
    return _client
        .from('messages')
        .stream(primaryKey: ['id'])
        .eq('chat_id', chatId)
        .order('created_at')
        .map((data) => data
            .map((json) => MessageModel.fromJson(json).toDomain())
            .toList());
  }
}

// Usage in notifier
class MessagesNotifier extends BaseNotifier<List<Message>> {
  StreamSubscription? _subscription;
  
  void startListening(String chatId) {
    _subscription = _repository.watchMessages(chatId).listen(
      (messages) {
        state = BaseData(messages);
      },
      onError: (error) {
        state = BaseError(Failure.generic(error: error));
      },
    );
  }
  
  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
```

### File Storage

```dart
class StorageRepository {
  final SupabaseClient _client;
  
  EitherFailureOr<String> uploadFile({
    required String bucket,
    required String path,
    required File file,
  }) async {
    try {
      final bytes = await file.readAsBytes();
      
      await _client.storage
          .from(bucket)
          .uploadBinary(
            path,
            bytes,
            fileOptions: FileOptions(
              cacheControl: '3600',
              upsert: false,
            ),
          );
      
      final url = _client.storage.from(bucket).getPublicUrl(path);
      return Right(url);
    } catch (e) {
      return Left(Failure.generic(error: e));
    }
  }
  
  EitherFailureOr<void> deleteFile({
    required String bucket,
    required String path,
  }) async {
    try {
      await _client.storage.from(bucket).remove([path]);
      return const Right(null);
    } catch (e) {
      return Left(Failure.generic(error: e));
    }
  }
}
```

## Pagination

```dart
class PaginatedRepository {
  final SupabaseClient _client;
  static const pageSize = 20;
  
  EitherFailureOr<PaginatedResponse<User>> getUsers({
    required int page,
  }) async {
    try {
      final from = (page - 1) * pageSize;
      final to = from + pageSize - 1;
      
      final response = await _client
          .from('users')
          .select()
          .range(from, to);
      
      final users = (response as List)
          .map((json) => UserModel.fromJson(json).toDomain())
          .toList();
      
      return Right(
        PaginatedResponse(
          data: users,
          page: page,
          hasMore: users.length == pageSize,
        ),
      );
    } catch (e) {
      return Left(Failure.generic(error: e));
    }
  }
}
```

## Offline Support

```dart
class OfflineFirstRepository implements UserRepository {
  final UserRepository _remoteRepository;
  final UserRepository _localRepository;
  final Connectivity _connectivity;
  
  @override
  EitherFailureOr<List<User>> getUsers() async {
    final isOnline = await _connectivity.checkConnectivity();
    
    if (isOnline == ConnectivityResult.none) {
      // Offline: Return cached data
      return _localRepository.getUsers();
    }
    
    // Online: Fetch and cache
    final result = await _remoteRepository.getUsers();
    
    result.fold(
      (failure) {},
      (users) async {
        // Save to local cache
        for (final user in users) {
          await _localRepository.createUser(user);
        }
      },
    );
    
    return result;
  }
}
```

## Best Practices

### ✅ Do

1. Use repository interfaces
2. Implement caching
3. Handle network errors
4. Use RPC for complex queries
5. Implement retry logic

### ❌ Don't

1. Don't access database directly from UI
2. Don't cache sensitive data
3. Don't forget to handle offline state
4. Don't skip error transformation

## Next Steps

- **UI Components:** Build in [10_UI_COMPONENT_LIBRARY.md](10_UI_COMPONENT_LIBRARY.md)
- **Testing:** Test repositories in [14_TESTING_STRATEGY.md](14_TESTING_STRATEGY.md)

---

**Your data layer is now robust and efficient!**

