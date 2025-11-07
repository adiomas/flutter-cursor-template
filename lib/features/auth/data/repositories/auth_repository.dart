import 'package:either_dart/either.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:q_architecture/q_architecture.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../common/data/supabase_service.dart';
import '../../../../common/utils/logger/app_logger.dart';
import '../../domain/entities/user_entity.dart';
import '../models/user_model.dart';

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepositoryImpl(ref.watch(supabaseServiceProvider)),
);

abstract interface class AuthRepository {
  EitherFailureOr<UserEntity> signInWithEmail({
    required String email,
    required String password,
  });

  EitherFailureOr<UserEntity> signUpWithEmail({
    required String email,
    required String password,
    String? displayName,
  });

  EitherFailureOr<UserEntity> signInWithGoogle({
    required String webClientId,
    String? iosClientId,
  });

  EitherFailureOr<UserEntity> signInWithApple();

  EitherFailureOr<void> signOut();

  EitherFailureOr<void> resetPassword(String email);

  EitherFailureOr<void> resendEmailConfirmation(String email);

  EitherFailureOr<void> deleteAccount();

  UserEntity? getCurrentUser();

  Stream<UserEntity?> watchAuthState();
}

class AuthRepositoryImpl implements AuthRepository {
  final SupabaseService _supabase;
  final _logger = AppLogger.instance;

  AuthRepositoryImpl(this._supabase);

  @override
  EitherFailureOr<UserEntity> signInWithEmail({
    required String email,
    required String password,
  }) async {
    _logger.debug('🔐 Starting sign in with email: $email');

    try {
      _logger.trace('Calling Supabase signInWithEmailPassword...');
      final response = await _supabase.signInWithEmailPassword(
        email: email,
        password: password,
      );

      _logger.debug('Supabase response received');
      _logger.trace(
          'Response session: ${response.session != null ? "exists" : "null"}');
      _logger.trace(
          'Response user: ${response.user != null ? "exists (${response.user!.id})" : "null"}');

      // Check for errors in response
      if (response.session == null || response.user == null) {
        _logger.error(
          'Sign in failed: No session or user returned',
          error:
              'Session: ${response.session != null}, User: ${response.user != null}',
        );
        return Left(Failure.generic(
          error: 'Sign in failed: No session or user returned',
        ));
      }

      _logger.debug('Converting Supabase user to domain entity...');
      final user = UserModel.fromSupabaseUser(response.user!).toDomain();
      _logger.info('✅ Sign in successful for user: ${user.id}');
      return Right(user);
    } on AuthException catch (e, stackTrace) {
      // Handle Supabase auth-specific errors
      _logger.error(
        'AuthException during sign in',
        error: e,
        stackTrace: stackTrace,
      );
      _logger.debug('AuthException message: ${e.message}');

      // Check for specific error codes
      if (e.message.contains('Email not confirmed') ||
          e.message.contains('email_not_confirmed')) {
        _logger.warning('Email not confirmed error detected');
        return Left(Failure.generic(
          error: 'email_not_confirmed',
        ));
      }

      return Left(Failure.generic(
        error: e,
      ));
    } catch (e, stackTrace) {
      _logger.error(
        'Unexpected error during sign in',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(Failure.generic(
        error: e,
        stackTrace: stackTrace,
      ));
    }
  }

  @override
  EitherFailureOr<UserEntity> signUpWithEmail({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      final metadata =
          displayName != null ? {'display_name': displayName} : null;

      final response = await _supabase.signUpWithEmailPassword(
        email: email,
        password: password,
        metadata: metadata,
      );

      if (response.user == null) {
        return Left(Failure.generic());
      }

      final user = UserModel.fromSupabaseUser(response.user!).toDomain();
      return Right(user);
    } catch (e) {
      return Left(Failure.generic());
    }
  }

  @override
  EitherFailureOr<void> signOut() async {
    try {
      await _supabase.signOut();
      return const Right(null);
    } catch (e) {
      return Left(Failure.generic(error: e));
    }
  }

  @override
  EitherFailureOr<void> resetPassword(String email) async {
    try {
      await _supabase.resetPassword(email);
      return const Right(null);
    } catch (e) {
      return Left(Failure.generic());
    }
  }

  @override
  EitherFailureOr<void> resendEmailConfirmation(String email) async {
    _logger.debug('Resending email confirmation to: $email');
    try {
      await _supabase.resendEmailConfirmation(email);
      _logger.info('✅ Email confirmation resent successfully');
      return const Right(null);
    } catch (e, stackTrace) {
      _logger.error(
        'Failed to resend email confirmation',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(Failure.generic(error: e));
    }
  }

  @override
  UserEntity? getCurrentUser() {
    final user = _supabase.currentUser;
    if (user == null) return null;

    return UserModel.fromSupabaseUser(user).toDomain();
  }

  @override
  EitherFailureOr<void> deleteAccount() async {
    _logger.debug('🗑️ Starting account deletion...');
    try {
      await _supabase.deleteAccount();
      _logger.info('✅ Account deleted successfully');
      return const Right(null);
    } catch (e, stackTrace) {
      _logger.error(
        'Failed to delete account',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(Failure.generic(error: e));
    }
  }

  @override
  EitherFailureOr<UserEntity> signInWithGoogle({
    required String webClientId,
    String? iosClientId,
  }) async {
    _logger.debug('🔐 Starting sign in with Google');

    try {
      _logger.trace('Calling Supabase signInWithGoogle...');
      final response = await _supabase.signInWithGoogle(
        webClientId: webClientId,
        iosClientId: iosClientId,
      );

      _logger.debug('Google sign in response received');
      _logger.trace(
          'Response session: ${response.session != null ? "exists" : "null"}');
      _logger.trace(
          'Response user: ${response.user != null ? "exists (${response.user!.id})" : "null"}');

      // Check for errors in response
      if (response.session == null || response.user == null) {
        _logger.error(
          'Google sign in failed: No session or user returned',
          error:
              'Session: ${response.session != null}, User: ${response.user != null}',
        );
        return Left(Failure.generic(
          error: 'Google sign in failed: No session or user returned',
        ));
      }

      _logger.debug('Converting Supabase user to domain entity...');
      final user = UserModel.fromSupabaseUser(response.user!).toDomain();
      _logger.info('✅ Google sign in successful for user: ${user.id}');
      return Right(user);
    } on AuthException catch (e, stackTrace) {
      _logger.error(
        'AuthException during Google sign in',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(Failure.generic(
        error: e,
      ));
    } catch (e, stackTrace) {
      _logger.error(
        'Unexpected error during Google sign in',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(Failure.generic(
        error: e,
        stackTrace: stackTrace,
      ));
    }
  }

  @override
  EitherFailureOr<UserEntity> signInWithApple() async {
    _logger.debug('🔐 Starting sign in with Apple');

    try {
      _logger.trace('Calling Supabase signInWithApple...');
      final response = await _supabase.signInWithApple();

      _logger.debug('Apple sign in response received');
      _logger.trace(
          'Response session: ${response.session != null ? "exists" : "null"}');
      _logger.trace(
          'Response user: ${response.user != null ? "exists (${response.user!.id})" : "null"}');

      // Check for errors in response
      if (response.session == null || response.user == null) {
        _logger.error(
          'Apple sign in failed: No session or user returned',
          error:
              'Session: ${response.session != null}, User: ${response.user != null}',
        );
        return Left(Failure.generic(
          error: 'Apple sign in failed: No session or user returned',
        ));
      }

      _logger.debug('Converting Supabase user to domain entity...');
      final user = UserModel.fromSupabaseUser(response.user!).toDomain();
      _logger.info('✅ Apple sign in successful for user: ${user.id}');
      return Right(user);
    } on AuthException catch (e, stackTrace) {
      _logger.error(
        'AuthException during Apple sign in',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(Failure.generic(
        error: e,
      ));
    } catch (e, stackTrace) {
      _logger.error(
        'Unexpected error during Apple sign in',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(Failure.generic(
        error: e,
        stackTrace: stackTrace,
      ));
    }
  }

  @override
  Stream<UserEntity?> watchAuthState() {
    return _supabase.authStateChanges.map((state) {
      final user = state.session?.user;
      if (user == null) return null;

      return UserModel.fromSupabaseUser(user).toDomain();
    });
  }
}
