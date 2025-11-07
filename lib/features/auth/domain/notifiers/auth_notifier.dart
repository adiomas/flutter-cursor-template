import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../common/domain/base_state.dart';
import '../../../../common/utils/logger/app_logger.dart';
import '../../data/repositories/auth_repository.dart';
import '../entities/user_entity.dart';

// Current user provider
final currentUserProvider = Provider<UserEntity?>((ref) {
  final authState = ref.watch(authNotifierProvider);
  return authState.maybeWhen(
    data: (user) => user,
    orElse: () => null,
  );
});

// Auth state provider
final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, BaseState<UserEntity?>>(
  (ref) => AuthNotifier(ref),
);

class AuthNotifier extends StateNotifier<BaseState<UserEntity?>> {
  final Ref ref;
  late AuthRepository _repository;
  StreamSubscription? _authSubscription;
  final _logger = AppLogger.instance;

  AuthNotifier(this.ref) : super(const BaseInitial()) {
    _repository = ref.read(authRepositoryProvider);
    _initializeAuth();
  }

  void _initializeAuth() {
    _logger.debug('🔐 Initializing auth state...');
    // Check current user
    final user = _repository.getCurrentUser();
    if (user != null) {
      _logger.info('✅ Found existing user: ${user.id}');
    } else {
      _logger.debug('No existing user found');
    }
    state = BaseData(user);

    // Listen to auth state changes
    _authSubscription = _repository.watchAuthState().listen(
      (user) {
        _logger.debug(
            'Auth state changed: ${user != null ? "User logged in (${user.id})" : "User logged out"}');
        state = BaseData(user);
      },
      onError: (error) {
        _logger.error('Error in auth state stream', error: error);
        state = const BaseData(null);
      },
    );
  }

  Future<bool> signInWithEmail({
    required String email,
    required String password,
  }) async {
    _logger.debug('🔐 AuthNotifier: Starting sign in process');
    state = const BaseLoading();

    final result = await _repository.signInWithEmail(
      email: email,
      password: password,
    );

    return result.fold(
      (failure) {
        _logger.error('❌ Sign in failed in AuthNotifier', error: failure.error);
        state = BaseError(failure);
        return false;
      },
      (user) {
        _logger.info('✅ Sign in successful in AuthNotifier, user: ${user.id}');
        state = BaseData(user);
        _logger.debug('Auth state updated to BaseData with user');
        return true;
      },
    );
  }

  Future<bool> signUpWithEmail({
    required String email,
    required String password,
    String? displayName,
  }) async {
    state = const BaseLoading();

    final result = await _repository.signUpWithEmail(
      email: email,
      password: password,
      displayName: displayName,
    );

    return result.fold(
      (failure) {
        state = BaseError(failure);
        return false;
      },
      (user) {
        state = BaseData(user);
        return true;
      },
    );
  }

  Future<bool> signInWithGoogle({
    required String webClientId,
    String? iosClientId,
  }) async {
    _logger.debug('🔐 AuthNotifier: Starting Google sign in process');
    state = const BaseLoading();

    final result = await _repository.signInWithGoogle(
      webClientId: webClientId,
      iosClientId: iosClientId,
    );

    return result.fold(
      (failure) {
        _logger.error('❌ Google sign in failed in AuthNotifier',
            error: failure.error);
        state = BaseError(failure);
        return false;
      },
      (user) {
        _logger.info(
            '✅ Google sign in successful in AuthNotifier, user: ${user.id}');
        state = BaseData(user);
        _logger.debug('Auth state updated to BaseData with user');
        return true;
      },
    );
  }

  Future<bool> signInWithApple() async {
    _logger.debug('🔐 AuthNotifier: Starting Apple sign in process');
    state = const BaseLoading();

    final result = await _repository.signInWithApple();

    return result.fold(
      (failure) {
        _logger.error('❌ Apple sign in failed in AuthNotifier',
            error: failure.error);
        state = BaseError(failure);
        return false;
      },
      (user) {
        _logger.info(
            '✅ Apple sign in successful in AuthNotifier, user: ${user.id}');
        state = BaseData(user);
        _logger.debug('Auth state updated to BaseData with user');
        return true;
      },
    );
  }

  Future<void> signOut() async {
    await _repository.signOut();
    state = const BaseData(null);
  }

  Future<bool> resetPassword(String email) async {
    final result = await _repository.resetPassword(email);
    return result.isRight;
  }

  Future<bool> resendEmailConfirmation(String email) async {
    _logger.debug('Resending email confirmation for: $email');
    final result = await _repository.resendEmailConfirmation(email);
    return result.fold(
      (failure) {
        _logger.error('Failed to resend email confirmation',
            error: failure.error);
        return false;
      },
      (_) {
        _logger.info('✅ Email confirmation resent successfully');
        return true;
      },
    );
  }

  Future<bool> deleteAccount() async {
    _logger.debug('🗑️ AuthNotifier: Starting account deletion');
    state = const BaseLoading();

    final result = await _repository.deleteAccount();

    return result.fold(
      (failure) {
        _logger.error('❌ Account deletion failed', error: failure.error);
        state = BaseError(failure);
        return false;
      },
      (_) {
        _logger.info('✅ Account deleted successfully');
        state = const BaseData(null);
        return true;
      },
    );
  }

  bool get isAuthenticated => state.maybeWhen(
        data: (user) => user != null,
        orElse: () => false,
      );

  UserEntity? get currentUser => state.maybeWhen(
        data: (user) => user,
        orElse: () => null,
      );

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}
