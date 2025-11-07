import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../common/domain/app_environment.dart';
import '../../../../common/domain/base_state.dart';
import '../../../../common/presentation/extensions/localization_extension.dart';
import '../../../../common/utils/logger/app_logger.dart';
import '../../../../theme/app_colors.dart';
import '../../../dashboard/presentation/pages/dashboard_page.dart';
import '../../domain/notifiers/auth_notifier.dart';

/// Helper class for handling OAuth sign-in operations
/// Provides reusable methods for Google and Apple sign-in
class OAuthHandler {
  static final _logger = AppLogger.instance;

  /// Handles Google sign-in with proper error handling and navigation
  static Future<void> handleGoogleSignIn(
    BuildContext context,
    WidgetRef ref,
    ValueNotifier<bool>? isLoadingNotifier,
  ) async {
    _logger.debug('🔐 OAuthHandler: Google sign in initiated');

    // Get Google Client IDs from environment
    final webClientId = EnvInfo.googleWebClientId;
    if (webClientId == null || webClientId.isEmpty) {
      _logger.warning('Google Web Client ID not configured');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.authOAuthNotConfigured('Google')),
            backgroundColor: AppColors.error,
          ),
        );
      }
      return;
    }

    final iosClientId = EnvInfo.googleIosClientId;

    isLoadingNotifier?.value = true;
    try {
      final success =
          await ref.read(authNotifierProvider.notifier).signInWithGoogle(
                webClientId: webClientId,
                iosClientId: iosClientId,
              );

      if (!context.mounted) return;

      if (success) {
        _logger.info('✅ Google sign in successful, navigating to dashboard...');
        await _navigateToDashboard(context);
      } else {
        await _handleOAuthError(context, ref, 'Google');
      }
    } catch (e, stackTrace) {
      _logger.error('Unexpected error during Google sign in',
          error: e, stackTrace: stackTrace);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.authOAuthError('Google')),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      isLoadingNotifier?.value = false;
    }
  }

  /// Handles Apple sign-in with proper error handling and navigation
  static Future<void> handleAppleSignIn(
    BuildContext context,
    WidgetRef ref,
    ValueNotifier<bool>? isLoadingNotifier,
  ) async {
    _logger.debug('🔐 OAuthHandler: Apple sign in initiated');

    isLoadingNotifier?.value = true;
    try {
      final success =
          await ref.read(authNotifierProvider.notifier).signInWithApple();

      if (!context.mounted) return;

      if (success) {
        _logger.info('✅ Apple sign in successful, navigating to dashboard...');
        await _navigateToDashboard(context);
      } else {
        await _handleOAuthError(context, ref, 'Apple');
      }
    } catch (e, stackTrace) {
      _logger.error('Unexpected error during Apple sign in',
          error: e, stackTrace: stackTrace);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.authOAuthError('Apple')),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      isLoadingNotifier?.value = false;
    }
  }

  /// Navigates to dashboard after successful authentication
  static Future<void> _navigateToDashboard(BuildContext context) async {
    // Wait for auth state to propagate and router to update
    await Future.delayed(const Duration(milliseconds: 200));
    if (context.mounted) {
      context.go(DashboardPage.routeName);
    }
  }

  /// Handles OAuth errors with user-friendly messages
  static Future<void> _handleOAuthError(
    BuildContext context,
    WidgetRef ref,
    String provider,
  ) async {
    final updatedState = ref.read(authNotifierProvider);
    if (updatedState is BaseError && context.mounted) {
      final baseError = updatedState as BaseError;
      final errorString = baseError.failure.error?.toString() ?? '';
      final isCancelled =
          errorString.contains('cancelled') || errorString.contains('canceled');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isCancelled
                ? context.l10n.authOAuthCancelled
                : context.l10n.authOAuthError(provider),
          ),
          backgroundColor: isCancelled ? AppColors.warning : AppColors.error,
        ),
      );
    }
  }
}
