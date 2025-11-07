import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../common/domain/app_environment.dart';
import '../../../../common/domain/base_state.dart';
import '../../../../common/presentation/extensions/localization_extension.dart';
import '../../../../common/presentation/spacing.dart';
import '../../../../common/presentation/widgets/animated_app_icon.dart';
import '../../../../common/utils/logger/app_logger.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_text_styles.dart';
import '../../../dashboard/presentation/pages/dashboard_page.dart';
import '../../domain/notifiers/auth_notifier.dart';
import '../widgets/oauth_sign_in_button.dart';

class RegisterPage extends HookConsumerWidget {
  static const routeName = '/register';

  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);

    Future<void> handleGoogleSignIn(BuildContext context, WidgetRef ref) async {
      final logger = AppLogger.instance;
      logger.debug('🔐 RegisterPage: Google sign in initiated');

      // Get Google Client IDs from environment
      final webClientId = EnvInfo.googleWebClientId;
      if (webClientId == null || webClientId.isEmpty) {
        logger.warning('Google Web Client ID not configured');
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Google Sign In is not configured. Please configure Google Client IDs in Supabase dashboard.',
              ),
              backgroundColor: AppColors.error,
            ),
          );
        }
        return;
      }

      final iosClientId = EnvInfo.googleIosClientId;

      try {
        final success =
            await ref.read(authNotifierProvider.notifier).signInWithGoogle(
                  webClientId: webClientId,
                  iosClientId: iosClientId,
                );

        if (!context.mounted) return;

        if (success) {
          logger
              .info('✅ Google sign in successful, navigating to dashboard...');
          // Wait for auth state to propagate and router to update
          await Future.delayed(const Duration(milliseconds: 200));
          if (context.mounted) {
            context.go(DashboardPage.routeName);
          }
        } else {
          final updatedState = ref.read(authNotifierProvider);
          if (updatedState is BaseError && context.mounted) {
            final baseError = updatedState as BaseError;
            final errorString = baseError.failure.error?.toString() ?? '';
            final isCancelled = errorString.contains('cancelled') ||
                errorString.contains('canceled');

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  isCancelled
                      ? context.l10n.authOAuthCancelled
                      : context.l10n.authOAuthError('Google'),
                ),
                backgroundColor:
                    isCancelled ? AppColors.warning : AppColors.error,
              ),
            );
          }
        }
      } catch (e, stackTrace) {
        logger.error('Unexpected error during Google sign in',
            error: e, stackTrace: stackTrace);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.l10n.authOAuthError('Google')),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    }

    Future<void> handleAppleSignIn(BuildContext context, WidgetRef ref) async {
      final logger = AppLogger.instance;
      logger.debug('🔐 RegisterPage: Apple sign in initiated');

      try {
        final success =
            await ref.read(authNotifierProvider.notifier).signInWithApple();

        if (!context.mounted) return;

        if (success) {
          logger.info('✅ Apple sign in successful, navigating to dashboard...');
          // Wait for auth state to propagate and router to update
          await Future.delayed(const Duration(milliseconds: 200));
          if (context.mounted) {
            context.go(DashboardPage.routeName);
          }
        } else {
          final updatedState = ref.read(authNotifierProvider);
          if (updatedState is BaseError && context.mounted) {
            final baseError = updatedState as BaseError;
            final errorString = baseError.failure.error?.toString() ?? '';
            final isCancelled = errorString.contains('cancelled') ||
                errorString.contains('canceled');

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  isCancelled
                      ? context.l10n.authOAuthCancelled
                      : context.l10n.authOAuthError('Apple'),
                ),
                backgroundColor:
                    isCancelled ? AppColors.warning : AppColors.error,
              ),
            );
          }
        }
      } catch (e, stackTrace) {
        logger.error('Unexpected error during Apple sign in',
            error: e, stackTrace: stackTrace);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.l10n.authOAuthError('Apple')),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    }

    return Scaffold(
      backgroundColor: context.appColors.background,
      appBar: AppBar(
        surfaceTintColor: context.appColors.background,
        backgroundColor: context.appColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/login'),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: paddingAll24,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Animated Logo/Title
                const AnimatedAppIcon(
                  size: 64,
                  color: AppColors.primary,
                ),
                spacing16,
                Text(
                  context.l10n.authCreateAccount,
                  style: context.textStyles.displayMedium,
                  textAlign: TextAlign.center,
                ),
                spacing8,
                Text(
                  context.l10n.authSignUpToGetStarted,
                  style: context.textStyles.bodyLarge.copyWith(
                    color: context.appColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                spacing48,

                // Sign up with Email Button
                SizedBox(
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: authState is BaseLoading
                        ? null
                        : () => context.go('/register/email'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.email_outlined, size: 20),
                    label: Text(
                      context.l10n.authSignUpWithEmail,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                spacing24,

                // Divider with "Or continue with"
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: context.appColors.border,
                        thickness: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        context.l10n.authOrContinueWith,
                        style: context.textStyles.bodyMedium.copyWith(
                          color: context.appColors.textSecondary,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: context.appColors.border,
                        thickness: 1,
                      ),
                    ),
                  ],
                ),
                spacing24,

                // OAuth Sign In Buttons
                // Google Sign In
                OAuthSignInButton(
                  provider: OAuthProvider.google,
                  isLoading: authState is BaseLoading,
                  onPressed: () => handleGoogleSignIn(context, ref),
                ),
                spacing16,

                // Apple Sign In (iOS/macOS only)
                if (OAuthPlatformHelper.isAppleSignInAvailable)
                  OAuthSignInButton(
                    provider: OAuthProvider.apple,
                    isLoading: authState is BaseLoading,
                    onPressed: () => handleAppleSignIn(context, ref),
                  ),
                if (OAuthPlatformHelper.isAppleSignInAvailable) spacing24,

                // Login Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      context.l10n.authAlreadyHaveAccount,
                      style: context.textStyles.bodyMedium,
                    ),
                    TextButton(
                      onPressed: () => context.go('/login'),
                      child: Text(
                        context.l10n.authSignIn,
                        style: context.textStyles.bodyMedium.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
