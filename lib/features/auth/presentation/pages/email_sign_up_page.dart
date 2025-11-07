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

class EmailSignUpPage extends HookConsumerWidget {
  static const routeName = '/register/email';

  const EmailSignUpPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameController = useTextEditingController();
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final confirmPasswordController = useTextEditingController();
    final isPasswordVisible = useState(false);
    final isConfirmPasswordVisible = useState(false);
    final authState = ref.watch(authNotifierProvider);

    Future<void> handleRegister() async {
      // Validation
      if (nameController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.validationNameRequired)),
        );
        return;
      }

      if (emailController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.validationEmailRequired)),
        );
        return;
      }

      if (passwordController.text.length < 8) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.validationPassword)),
        );
        return;
      }

      if (passwordController.text != confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.validationPasswordMismatch)),
        );
        return;
      }

      final success =
          await ref.read(authNotifierProvider.notifier).signUpWithEmail(
                email: emailController.text.trim(),
                password: passwordController.text,
                displayName: nameController.text.trim(),
              );

      if (success && context.mounted) {
        // Sign out immediately after registration so user must confirm email first
        await ref.read(authNotifierProvider.notifier).signOut();

        if (!context.mounted) return;

        // Show success dialog with email confirmation message
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: Text(context.l10n.authRegistrationSuccessTitle),
            content: Text(
              context.l10n.authRegistrationSuccessMessage(
                emailController.text.trim(),
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  context.go('/login?needsConfirmation=true');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
                child: Text(context.l10n.authGoToLogin),
              ),
            ],
          ),
        );
      } else if (authState is BaseError && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.errorSignUpFailed),
            backgroundColor: AppColors.error,
          ),
        );
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
          onPressed: () => context.go('/register'),
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

                // Name Field
                TextField(
                  controller: nameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    labelText: context.l10n.authFullName,
                    hintText: context.l10n.authEnterYourName,
                    prefixIcon: const Icon(Icons.person_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: context.appColors.contentBackground,
                  ),
                ),
                spacing16,

                // Email Field
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: context.l10n.authEmail,
                    hintText: context.l10n.authEnterYourEmail,
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: context.appColors.contentBackground,
                  ),
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
                spacing16,

                // Confirm Password Field
                TextField(
                  controller: confirmPasswordController,
                  obscureText: !isConfirmPasswordVisible.value,
                  decoration: InputDecoration(
                    labelText: context.l10n.authConfirmPassword,
                    hintText: context.l10n.authReEnterYourPassword,
                    prefixIcon: const Icon(Icons.lock_outlined),
                    suffixIcon: IconButton(
                      icon: Icon(
                        isConfirmPasswordVisible.value
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        isConfirmPasswordVisible.value =
                            !isConfirmPasswordVisible.value;
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

                // Register Button
                SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    onPressed: authState is BaseLoading ? null : handleRegister,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: authState is BaseLoading
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
                            context.l10n.authSignUp,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
                spacing16,

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

