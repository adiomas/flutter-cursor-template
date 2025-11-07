import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../common/domain/base_state.dart';
import '../../../../common/presentation/extensions/localization_extension.dart';
import '../../../../common/presentation/spacing.dart';
import '../../../../common/presentation/widgets/animated_app_icon.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_text_styles.dart';
import '../../domain/notifiers/auth_notifier.dart';
import '../utils/oauth_handler.dart';
import '../widgets/auth_divider.dart';
import '../widgets/auth_navigation_link.dart';
import '../widgets/oauth_sign_in_button.dart';

class RegisterPage extends HookConsumerWidget {
  static const routeName = '/register';

  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final isGoogleLoading = useState(false);
    final isAppleLoading = useState(false);

    Future<void> handleGoogleSignIn(BuildContext context, WidgetRef ref) async {
      await OAuthHandler.handleGoogleSignIn(
        context,
        ref,
        isGoogleLoading,
      );
    }

    Future<void> handleAppleSignIn(BuildContext context, WidgetRef ref) async {
      await OAuthHandler.handleAppleSignIn(
        context,
        ref,
        isAppleLoading,
      );
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
                const AuthDivider(),
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

                // Login Link
                AuthNavigationLink(
                  questionText: context.l10n.authAlreadyHaveAccount,
                  linkText: context.l10n.authSignIn,
                  onTap: () => context.go('/login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
