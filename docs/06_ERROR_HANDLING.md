# Error Handling

Comprehensive guide to handling errors elegantly - type-safe, user-friendly, and maintainable.

## Philosophy

> **"Errors are not exceptional - they're expected. Handle them gracefully."**

### Key Principles

1. **Type Safety:** Use Either<Failure, Success> pattern
2. **User-Friendly:** Show actionable messages, not stack traces
3. **Graceful Degradation:** App continues working when possible
4. **Logging:** Log for debugging, but don't overwhelm
5. **Recovery:** Provide ways to retry or recover

## The Either Pattern

### Why Either?

**Problem with exceptions:**
```dart
// ❌ BAD: Exceptions are invisible in type system
Future<User> getUser() async {
  // Can throw, but type signature doesn't tell you
  throw Exception('User not found');
}
```

**Solution with Either:**
```dart
// ✅ GOOD: Errors are explicit in type
EitherFailureOr<User> getUser() async {
  // Type tells you it can fail
  return Left(Failure('User not found'));
}
```

### Basic Usage

```dart
import 'package:either_dart/either.dart';
import 'package:q_architecture/q_architecture.dart';

// Type alias for cleaner code
// already defined in q_architecture:
// typedef EitherFailureOr<T> = Future<Either<Failure, T>>;

// Repository method
EitherFailureOr<User> getUser(String id) async {
  try {
    final response = await _client.getUser(id);
    return Right(response);  // Success
  } catch (e) {
    return Left(Failure.generic(error: e));  // Failure
  }
}

// Using the result
final result = await repository.getUser('123');
result.fold(
  (failure) => print('Error: ${failure.message}'),
  (user) => print('Success: ${user.name}'),
);
```

## Failure Class

### Standard Failure

```dart
import 'package:q_architecture/q_architecture.dart';

class Failure {
  final String message;
  final String? code;
  final dynamic error;
  final StackTrace? stackTrace;
  
  const Failure({
    required this.message,
    this.code,
    this.error,
    this.stackTrace,
  });
  
  // Named constructors for common failures
  factory Failure.generic({
    String? message,
    dynamic error,
    StackTrace? stackTrace,
  }) {
    return Failure(
      message: message ?? 'An unexpected error occurred',
      code: 'generic_error',
      error: error,
      stackTrace: stackTrace,
    );
  }
  
  factory Failure.network({
    String? message,
    dynamic error,
  }) {
    return Failure(
      message: message ?? 'Network connection failed',
      code: 'network_error',
      error: error,
    );
  }
  
  factory Failure.notFound({
    String? message,
    String? resource,
  }) {
    return Failure(
      message: message ?? '$resource not found',
      code: 'not_found',
    );
  }
  
  factory Failure.unauthorized({
    String? message,
  }) {
    return Failure(
      message: message ?? 'Unauthorized access',
      code: 'unauthorized',
    );
  }
  
  factory Failure.validation({
    required String message,
    Map<String, String>? errors,
  }) {
    return Failure(
      message: message,
      code: 'validation_error',
      error: errors,
    );
  }
  
  // User-friendly message
  String get userMessage {
    return switch (code) {
      'network_error' => 'Please check your internet connection',
      'unauthorized' => 'Please login to continue',
      'not_found' => 'Requested item not found',
      'validation_error' => message,
      _ => 'Something went wrong. Please try again.',
    };
  }
  
  // Whether user can retry
  bool get canRetry {
    return code == 'network_error' || code == 'generic_error';
  }
}
```

### Custom Failures

```dart
// Domain-specific failures
class AuthFailure extends Failure {
  const AuthFailure({
    required super.message,
    super.code = 'auth_error',
  });
  
  factory AuthFailure.invalidCredentials() {
    return const AuthFailure(
      message: 'Invalid email or password',
      code: 'invalid_credentials',
    );
  }
  
  factory AuthFailure.emailAlreadyExists() {
    return const AuthFailure(
      message: 'This email is already registered',
      code: 'email_exists',
    );
  }
  
  factory AuthFailure.weakPassword() {
    return const AuthFailure(
      message: 'Password must be at least 8 characters',
      code: 'weak_password',
    );
  }
}

class PaymentFailure extends Failure {
  const PaymentFailure({
    required super.message,
    super.code = 'payment_error',
  });
  
  factory PaymentFailure.insufficientFunds() {
    return const PaymentFailure(
      message: 'Insufficient funds in account',
      code: 'insufficient_funds',
    );
  }
  
  factory PaymentFailure.cardDeclined() {
    return const PaymentFailure(
      message: 'Card was declined by your bank',
      code: 'card_declined',
    );
  }
}
```

## Error Handling in Repository

### Standard Pattern

```dart
class UserRepository {
  final SupabaseClient _client;
  
  UserRepository(this._client);
  
  EitherFailureOr<User> getUser(String id) async {
    try {
      final response = await _client
          .from('users')
          .select()
          .eq('id', id)
          .single();
      
      final user = UserModel.fromJson(response).toDomain();
      return Right(user);
      
    } on PostgrestException catch (e) {
      // Database errors
      if (e.code == 'PGRST116') {
        return Left(Failure.notFound(resource: 'User'));
      }
      return Left(Failure.generic(
        message: 'Database error occurred',
        error: e,
      ));
      
    } on SocketException catch (e) {
      // Network errors
      return Left(Failure.network(error: e));
      
    } on FormatException catch (e) {
      // JSON parsing errors
      return Left(Failure.generic(
        message: 'Invalid data format',
        error: e,
      ));
      
    } catch (e, stackTrace) {
      // Unknown errors
      return Left(Failure.generic(
        message: 'An unexpected error occurred',
        error: e,
        stackTrace: stackTrace,
      ));
    }
  }
  
  EitherFailureOr<void> deleteUser(String id) async {
    try {
      await _client
          .from('users')
          .delete()
          .eq('id', id);
      
      return const Right(null);  // Success with no data
      
    } catch (e) {
      return Left(Failure.generic(error: e));
    }
  }
}
```

### With Retry Logic

```dart
class UserRepository {
  final SupabaseClient _client;
  static const maxRetries = 3;
  
  EitherFailureOr<User> getUser(String id) async {
    return _withRetry(() => _getUserOnce(id));
  }
  
  Future<Either<Failure, User>> _getUserOnce(String id) async {
    try {
      final response = await _client
          .from('users')
          .select()
          .eq('id', id)
          .single();
      
      return Right(UserModel.fromJson(response).toDomain());
    } catch (e) {
      return Left(Failure.generic(error: e));
    }
  }
  
  Future<Either<Failure, T>> _withRetry<T>(
    Future<Either<Failure, T>> Function() operation,
  ) async {
    int attempts = 0;
    
    while (attempts < maxRetries) {
      final result = await operation();
      
      if (result.isRight) {
        return result;
      }
      
      final failure = result.left;
      
      // Only retry network errors
      if (!failure.canRetry) {
        return result;
      }
      
      attempts++;
      
      if (attempts < maxRetries) {
        // Exponential backoff
        await Future.delayed(Duration(seconds: attempts * 2));
      }
    }
    
    return Left(Failure.generic(
      message: 'Operation failed after $maxRetries attempts',
    ));
  }
}
```

## Error Handling in Notifier

### Basic Pattern

```dart
class UserNotifier extends BaseNotifier<User> {
  late UserRepository _repository;
  
  @override
  void prepareForBuild() {
    _repository = ref.watch(userRepositoryProvider);
  }
  
  Future<void> loadUser(String id) async {
    state = const BaseLoading();
    
    final result = await _repository.getUser(id);
    
    state = result.fold(
      (failure) {
        // Log error
        loggy.error('Failed to load user', failure.error);
        
        // Set error state
        return BaseError(failure);
      },
      (user) => BaseData(user),
    );
  }
}
```

### With User Notification

```dart
class UserNotifier extends BaseNotifier<User> {
  late UserRepository _repository;
  
  @override
  void prepareForBuild() {
    _repository = ref.watch(userRepositoryProvider);
  }
  
  Future<void> updateUser(User user) async {
    state = const BaseLoading();
    
    final result = await _repository.updateUser(user);
    
    result.fold(
      (failure) {
        state = BaseError(failure);
        
        // Show error to user
        ref.read(snackbarProvider).showError(failure.userMessage);
      },
      (updatedUser) {
        state = BaseData(updatedUser);
        
        // Show success message
        ref.read(snackbarProvider).showSuccess('Profile updated');
      },
    );
  }
}
```

### With Error Recovery

```dart
class ProductsNotifier extends BaseNotifier<List<Product>> {
  late ProductRepository _repository;
  List<Product>? _cachedProducts;
  
  @override
  void prepareForBuild() {
    _repository = ref.watch(productRepositoryProvider);
  }
  
  Future<void> loadProducts() async {
    state = const BaseLoading();
    
    final result = await _repository.getProducts();
    
    result.fold(
      (failure) {
        // Try to use cached data
        if (_cachedProducts != null && _cachedProducts!.isNotEmpty) {
          state = BaseData(_cachedProducts!);
          
          // Notify user about stale data
          ref.read(snackbarProvider).showWarning(
            'Showing cached data. ${failure.userMessage}',
          );
        } else {
          state = BaseError(failure);
        }
      },
      (products) {
        _cachedProducts = products;
        state = BaseData(products);
      },
    );
  }
  
  Future<void> retry() async {
    await loadProducts();
  }
}
```

## Error Handling in UI

### Basic Error Display

```dart
class UserProfilePage extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userNotifierProvider);
    
    return Scaffold(
      body: switch (userState) {
        BaseLoading() => const LoadingWidget(),
        BaseData(:final data) => ProfileContent(user: data),
        BaseError(:final failure) => ErrorView(
            failure: failure,
            onRetry: () {
              ref.read(userNotifierProvider.notifier).loadUser('123');
            },
          ),
        _ => const SizedBox.shrink(),
      },
    );
  }
}
```

### Reusable Error Widget

```dart
class ErrorView extends StatelessWidget {
  final Failure failure;
  final VoidCallback? onRetry;
  
  const ErrorView({
    super.key,
    required this.failure,
    this.onRetry,
  });
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _getIcon(),
              size: 64,
              color: context.appColors.error,
            ),
            const SizedBox(height: 16),
            Text(
              failure.userMessage,
              textAlign: TextAlign.center,
              style: context.textStyles.bodyText1,
            ),
            if (failure.canRetry && onRetry != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Try Again'),
              ),
            ],
          ],
        ),
      ),
    );
  }
  
  IconData _getIcon() {
    return switch (failure.code) {
      'network_error' => Icons.wifi_off,
      'not_found' => Icons.search_off,
      'unauthorized' => Icons.lock,
      _ => Icons.error_outline,
    };
  }
}
```

### Snackbar Notifications

```dart
// Provider for global snackbar
final snackbarProvider = Provider<SnackbarService>((ref) {
  return SnackbarService();
});

class SnackbarService {
  void showError(String message) {
    final context = navigatorKey.currentContext;
    if (context == null) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        action: SnackBarAction(
          label: 'Dismiss',
          onPressed: () {},
        ),
      ),
    );
  }
  
  void showSuccess(String message) {
    final context = navigatorKey.currentContext;
    if (context == null) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }
  
  void showWarning(String message) {
    final context = navigatorKey.currentContext;
    if (context == null) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.orange,
      ),
    );
  }
}
```

### Custom Flushbar

```dart
import 'package:another_flushbar/flushbar.dart';

void showErrorFlushbar(BuildContext context, Failure failure) {
  Flushbar(
    message: failure.userMessage,
    icon: Icon(
      Icons.error_outline,
      color: Colors.white,
    ),
    backgroundColor: Colors.red,
    duration: const Duration(seconds: 3),
    margin: const EdgeInsets.all(8),
    borderRadius: BorderRadius.circular(8),
    flushbarPosition: FlushbarPosition.TOP,
    mainButton: failure.canRetry
        ? TextButton(
            onPressed: () {
              // Retry logic
            },
            child: const Text(
              'RETRY',
              style: TextStyle(color: Colors.white),
            ),
          )
        : null,
  ).show(context);
}
```

## Form Validation Errors

### Validation Pattern

```dart
class ValidationError {
  final Map<String, String> errors;
  
  const ValidationError(this.errors);
  
  String? getError(String field) => errors[field];
  
  bool hasError(String field) => errors.containsKey(field);
  
  bool get hasErrors => errors.isNotEmpty;
}

class FormValidator {
  static ValidationError validateUserForm({
    required String name,
    required String email,
    required String password,
  }) {
    final errors = <String, String>{};
    
    if (name.isEmpty) {
      errors['name'] = 'Name is required';
    } else if (name.length < 2) {
      errors['name'] = 'Name must be at least 2 characters';
    }
    
    if (email.isEmpty) {
      errors['email'] = 'Email is required';
    } else if (!_isValidEmail(email)) {
      errors['email'] = 'Please enter a valid email';
    }
    
    if (password.isEmpty) {
      errors['password'] = 'Password is required';
    } else if (password.length < 8) {
      errors['password'] = 'Password must be at least 8 characters';
    }
    
    return ValidationError(errors);
  }
  
  static bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}
```

### Form with Validation

```dart
class RegisterForm extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameController = useTextEditingController();
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final validationErrors = useState<ValidationError?>(null);
    
    void handleSubmit() {
      // Validate
      final errors = FormValidator.validateUserForm(
        name: nameController.text,
        email: emailController.text,
        password: passwordController.text,
      );
      
      if (errors.hasErrors) {
        validationErrors.value = errors;
        return;
      }
      
      // Submit
      ref.read(authNotifierProvider.notifier).register(
            name: nameController.text,
            email: emailController.text,
            password: passwordController.text,
          );
    }
    
    return Column(
      children: [
        TextField(
          controller: nameController,
          decoration: InputDecoration(
            labelText: 'Name',
            errorText: validationErrors.value?.getError('name'),
          ),
        ),
        TextField(
          controller: emailController,
          decoration: InputDecoration(
            labelText: 'Email',
            errorText: validationErrors.value?.getError('email'),
          ),
        ),
        TextField(
          controller: passwordController,
          decoration: InputDecoration(
            labelText: 'Password',
            errorText: validationErrors.value?.getError('password'),
          ),
          obscureText: true,
        ),
        ElevatedButton(
          onPressed: handleSubmit,
          child: const Text('Register'),
        ),
      ],
    );
  }
}
```

## Global Error Handler

### Catching Unhandled Errors

```dart
void main() {
  // Catch Flutter framework errors
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    logError(details.exception, details.stack);
  };
  
  // Catch errors outside Flutter
  PlatformDispatcher.instance.onError = (error, stack) {
    logError(error, stack);
    return true;
  };
  
  runApp(MyApp());
}

void logError(dynamic error, StackTrace? stack) {
  // Log to console in development
  if (kDebugMode) {
    debugPrint('Error: $error');
    debugPrint('Stack: $stack');
  }
  
  // Send to crash reporting in production
  if (kReleaseMode) {
    // Sentry, Firebase Crashlytics, etc.
  }
}
```

## Best Practices

### ✅ Do

1. **Use Either for repository methods:**
```dart
EitherFailureOr<User> getUser(String id) async {
  // Always return Either
}
```

2. **Create specific failures:**
```dart
return Left(Failure.notFound(resource: 'User'));
return Left(Failure.network());
```

3. **Show user-friendly messages:**
```dart
Text(failure.userMessage)  // Not failure.error.toString()
```

4. **Provide retry options:**
```dart
if (failure.canRetry) {
  ElevatedButton(
    onPressed: onRetry,
    child: Text('Try Again'),
  )
}
```

5. **Log errors properly:**
```dart
loggy.error('Failed to load user', failure.error, failure.stackTrace);
```

### ❌ Don't

1. **Don't swallow errors:**
```dart
// ❌ BAD
try {
  await operation();
} catch (e) {
  // Silently ignore
}

// ✅ GOOD
try {
  await operation();
} catch (e) {
  return Left(Failure.generic(error: e));
}
```

2. **Don't show technical errors to users:**
```dart
// ❌ BAD
Text(error.toString())

// ✅ GOOD
Text(failure.userMessage)
```

3. **Don't use exceptions for control flow:**
```dart
// ❌ BAD
if (user == null) throw Exception('User not found');

// ✅ GOOD
if (user == null) return Left(Failure.notFound(resource: 'User'));
```

## Quick Reference

### Common Patterns

```dart
// Repository: Handle specific errors
try {
  final data = await _client.getData();
  return Right(data);
} on NetworkException {
  return Left(Failure.network());
} on NotFoundException {
  return Left(Failure.notFound());
} catch (e) {
  return Left(Failure.generic(error: e));
}

// Notifier: Transform errors to state
final result = await _repository.getData();
state = result.fold(BaseError.new, BaseData.new);

// UI: Display errors
switch (state) {
  BaseError(:final failure) => ErrorView(
      failure: failure,
      onRetry: () => notifier.retry(),
    ),
  // ...
}
```

## Next Steps

- **Feature Template:** Apply patterns in [07_FEATURE_TEMPLATE.md](07_FEATURE_TEMPLATE.md) ⭐
- **Testing:** Test errors in [14_TESTING_STRATEGY.md](14_TESTING_STRATEGY.md)
- **Monitoring:** Track errors in [19_MONITORING_ANALYTICS.md](19_MONITORING_ANALYTICS.md)

---

**Your errors are now handled elegantly and professionally!**

