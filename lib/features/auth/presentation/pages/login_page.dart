import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../common/data/credentials_storage.dart';
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

class LoginPage extends HookConsumerWidget {
  static const routeName = '/login';

  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final isPasswordVisible = useState(false);
    final logger = AppLogger.instance;
    final credentialsStorage = ref.watch(credentialsStorageProvider);
    final savedEmails = useState<List<SavedEmail>>([]);
    // Separate loading states for each auth method
    final isEmailLoading = useState(false);
    final isGoogleLoading = useState(false);
    final isAppleLoading = useState(false);

    // Load saved emails list on page init
    useEffect(() {
      Future.microtask(() async {
        final emails = await credentialsStorage.getSavedEmails();
        savedEmails.value = emails;

        // Load most recently used credentials
        final lastUsed = await credentialsStorage.getLastUsedCredentials();
        if (lastUsed.email != null) {
          emailController.text = lastUsed.email!;
        }
        if (lastUsed.password != null) {
          passwordController.text = lastUsed.password!;
        }
      });
      return null;
    }, const []);

    Future<void> handleLogin() async {
      logger.debug('🔐 LoginPage: handleLogin called');

      // Validation
      if (emailController.text.trim().isEmpty) {
        logger.debug('Validation failed: Email is empty');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.validationEmailRequired)),
        );
        return;
      }

      if (passwordController.text.isEmpty) {
        logger.debug('Validation failed: Password is empty');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.validationPasswordRequired)),
        );
        return;
      }

      isEmailLoading.value = true;
      try {
        logger.debug('Calling signInWithEmail from AuthNotifier...');
        final success =
            await ref.read(authNotifierProvider.notifier).signInWithEmail(
                  email: emailController.text.trim(),
                  password: passwordController.text,
                );

        logger.debug('Sign in result: $success');

        if (!context.mounted) {
          logger.debug('Context not mounted, returning');
          return;
        }

        if (success) {
          logger.info('✅ Login successful, navigating to dashboard...');
          // Save credentials for next time
          await credentialsStorage.saveCredentials(
            email: emailController.text.trim(),
            password: passwordController.text,
          );
          // Wait for auth state to propagate and router to update
          await Future.delayed(const Duration(milliseconds: 200));
          if (context.mounted) {
            logger.debug('Navigating to ${DashboardPage.routeName}');
            context.go(DashboardPage.routeName);
          }
        } else {
          logger.debug('Login failed, checking error state...');
          // Read state again after signIn operation to get updated state
          final updatedState = ref.read(authNotifierProvider);
          logger.debug('Updated auth state type: ${updatedState.runtimeType}');

          switch (updatedState) {
            case BaseError(:final failure):
              logger.error('BaseError detected: ${failure.error}');
              if (context.mounted) {
                // Check if it's email not confirmed error
                final errorString = failure.error?.toString() ?? '';
                final isEmailNotConfirmed =
                    errorString.contains('email_not_confirmed') ||
                        errorString.contains('Email not confirmed');

                if (isEmailNotConfirmed) {
                  // Show dialog with resend option
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(context.l10n.errorEmailNotConfirmed),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(context.l10n.errorEmailNotConfirmed),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () async {
                              Navigator.of(context).pop();
                              final success = await ref
                                  .read(authNotifierProvider.notifier)
                                  .resendEmailConfirmation(
                                    emailController.text.trim(),
                                  );
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(success
                                        ? context.l10n.authConfirmationEmailSent
                                        : context.l10n.errorGeneric),
                                    backgroundColor: success
                                        ? Colors.green
                                        : AppColors.error,
                                  ),
                                );
                              }
                            },
                            child: Text(context.l10n.authResendConfirmation),
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(context.l10n.close),
                        ),
                      ],
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(context.l10n.errorSignInFailed),
                      backgroundColor: AppColors.error,
                    ),
                  );
                }
              }
            default:
              logger.warning(
                  'Login failed but state is not BaseError: ${updatedState.runtimeType}');
          }
        }
      } finally {
        isEmailLoading.value = false;
      }
    }

    Future<void> handleGoogleSignIn(BuildContext context, WidgetRef ref) async {
      logger.debug('🔐 LoginPage: Google sign in initiated');

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

      isGoogleLoading.value = true;
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
      } finally {
        isGoogleLoading.value = false;
      }
    }

    Future<void> handleAppleSignIn(BuildContext context, WidgetRef ref) async {
      logger.debug('🔐 LoginPage: Apple sign in initiated');

      isAppleLoading.value = true;
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
      } finally {
        isAppleLoading.value = false;
      }
    }

    return Scaffold(
      backgroundColor: context.appColors.background,
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
                  context.l10n.authWelcomeToGlowAI,
                  style: context.textStyles.displayMedium,
                  textAlign: TextAlign.center,
                ),
                spacing8,
                Text(
                  context.l10n.authSignInToContinue,
                  style: context.textStyles.bodyLarge.copyWith(
                    color: context.appColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                spacing48,

                // Email Field with TypeAhead
                TypeAheadField<SavedEmail>(
                  controller: emailController,
                  builder: (context, controller, focusNode) {
                    return TextField(
                      controller: controller,
                      focusNode: focusNode,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: context.l10n.authEmail,
                        hintText: context.l10n.authEnterYourEmail,
                        prefixIcon: const Icon(Icons.email_outlined),
                        suffixIcon: savedEmails.value.isNotEmpty
                            ? const Icon(Icons.arrow_drop_down)
                            : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: context.appColors.contentBackground,
                      ),
                    );
                  },
                  suggestionsCallback: (search) async {
                    // Filter saved emails based on search
                    if (search.isEmpty) {
                      return savedEmails.value;
                    }
                    return savedEmails.value
                        .where((email) => email.email
                            .toLowerCase()
                            .contains(search.toLowerCase()))
                        .toList();
                  },
                  itemBuilder: (context, savedEmail) {
                    final isRecent = savedEmails.value.isNotEmpty &&
                        savedEmails.value.first == savedEmail;
                    return ListTile(
                      leading: Icon(
                        Icons.email_outlined,
                        size: 20,
                        color: context.appColors.textSecondary,
                      ),
                      title: Text(
                        savedEmail.email,
                        style: context.textStyles.bodyMedium,
                      ),
                      trailing: isRecent
                          ? Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                context.l10n.authRecent,
                                style: context.textStyles.bodySmall.copyWith(
                                  color: AppColors.primary,
                                ),
                              ),
                            )
                          : null,
                    );
                  },
                  onSelected: (selectedEmail) async {
                    emailController.text = selectedEmail.email;
                    // Load password for selected email
                    final password = await credentialsStorage
                        .getSavedPassword(selectedEmail.email);
                    if (password != null) {
                      passwordController.text = password;
                    }
                  },
                  decorationBuilder: (context, child) {
                    return Material(
                      elevation: 4.0,
                      borderRadius: BorderRadius.circular(12),
                      child: child,
                    );
                  },
                  offset: const Offset(0, 8),
                  constraints: const BoxConstraints(maxHeight: 300),
                  hideOnEmpty: true,
                  hideOnLoading: false,
                  hideOnError: false,
                  emptyBuilder: (context) => const SizedBox.shrink(),
                ),
                spacing16,

                // Password Field
                TextField(
                  controller: passwordController,
                  obscureText: !isPasswordVisible.value,
                  decoration: InputDecoration(
                    labelText: context.l10n.authPassword,
                    hintText: context.l10n.authEnterYourPassword,
                    prefixIcon: const Icon(Icons.lock_outlined),
                    suffixIcon: IconButton(
                      icon: Icon(
                        isPasswordVisible.value
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        isPasswordVisible.value = !isPasswordVisible.value;
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: context.appColors.contentBackground,
                  ),
                ),
                spacing24,

                // Login Button
                SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    onPressed: isEmailLoading.value ? null : handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: isEmailLoading.value
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text(
                            context.l10n.authSignIn,
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
                  isLoading: isGoogleLoading.value,
                  onPressed: () => handleGoogleSignIn(context, ref),
                ),
                spacing16,

                // Apple Sign In (iOS/macOS only)
                if (OAuthPlatformHelper.isAppleSignInAvailable)
                  OAuthSignInButton(
                    provider: OAuthProvider.apple,
                    isLoading: isAppleLoading.value,
                    onPressed: () => handleAppleSignIn(context, ref),
                  ),
                if (OAuthPlatformHelper.isAppleSignInAvailable) spacing24,

                // Sign Up Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      context.l10n.authDontHaveAccount,
                      style: context.textStyles.bodyMedium,
                    ),
                    TextButton(
                      onPressed: () => context.go('/register'),
                      child: Text(
                        context.l10n.authSignUp,
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
