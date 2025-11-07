import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../common/domain/base_state.dart';
import '../../../../common/domain/notifiers/theme_notifier.dart';
import '../../../../common/presentation/extensions/localization_extension.dart';
import '../../../../common/presentation/spacing.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_text_styles.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../auth/domain/notifiers/auth_notifier.dart';

class SettingsPage extends HookConsumerWidget {
  static const routeName = '/settings';

  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeNotifierProvider);
    final authState = ref.watch(authNotifierProvider);

    return Scaffold(
      backgroundColor: context.appColors.background,
      appBar: AppBar(
        surfaceTintColor: context.appColors.background,
        backgroundColor: context.appColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(
          context.l10n.settingsTitle,
          style: context.textStyles.titleLarge.copyWith(
            color: context.appColors.textPrimary,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Appearance Section
                _buildSectionHeader(
                  context,
                  context.l10n.settingsAppearance,
                ),
                spacing16,
                _buildThemeSelector(context, ref, themeMode),
                spacing32,

                // Account Section
                _buildSectionHeader(
                  context,
                  context.l10n.settingsAccount,
                ),
                spacing16,
                _buildDeleteAccountSection(context, ref, authState),
                spacing32,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Text(
      title,
      style: context.textStyles.titleMedium.copyWith(
        color: context.appColors.textPrimary,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildThemeSelector(
    BuildContext context,
    WidgetRef ref,
    ThemeMode currentMode,
  ) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: context.appColors.border),
      ),
      color: context.appColors.cardBackground,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.palette_outlined,
                  color: context.appColors.textSecondary,
                ),
                spacingH12,
                Text(
                  context.l10n.settingsTheme,
                  style: context.textStyles.bodyLarge.copyWith(
                    color: context.appColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            spacing16,
            _buildThemeOption(
              context,
              ref,
              ThemeMode.light,
              context.l10n.settingsThemeLight,
              Icons.light_mode_outlined,
              currentMode == ThemeMode.light,
            ),
            spacing8,
            _buildThemeOption(
              context,
              ref,
              ThemeMode.dark,
              context.l10n.settingsThemeDark,
              Icons.dark_mode_outlined,
              currentMode == ThemeMode.dark,
            ),
            spacing8,
            _buildThemeOption(
              context,
              ref,
              ThemeMode.system,
              context.l10n.settingsThemeSystem,
              Icons.brightness_auto_outlined,
              currentMode == ThemeMode.system,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeOption(
    BuildContext context,
    WidgetRef ref,
    ThemeMode mode,
    String label,
    IconData icon,
    bool isSelected,
  ) {
    return InkWell(
      onTap: () {
        ref.read(themeNotifierProvider.notifier).setThemeMode(mode);
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: isSelected
              ? context.appColors.primary.withOpacity(0.1)
              : Colors.transparent,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? context.appColors.primary
                  : context.appColors.textSecondary,
              size: 20,
            ),
            spacingH12,
            Expanded(
              child: Text(
                label,
                style: context.textStyles.bodyMedium.copyWith(
                  color: isSelected
                      ? context.appColors.primary
                      : context.appColors.textPrimary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: context.appColors.primary,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeleteAccountSection(
    BuildContext context,
    WidgetRef ref,
    BaseState<UserEntity?> authState,
  ) {
    final isDeleting = authState is BaseLoading;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: context.appColors.error.withOpacity(0.3)),
      ),
      color: context.appColors.cardBackground,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.delete_outline,
                  color: context.appColors.error,
                ),
                spacingH12,
                Expanded(
                  child: Text(
                    context.l10n.settingsDeleteAccount,
                    style: context.textStyles.bodyLarge.copyWith(
                      color: context.appColors.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            spacing12,
            Text(
              context.l10n.settingsDeleteAccountDescription,
              style: context.textStyles.bodySmall.copyWith(
                color: context.appColors.textSecondary,
              ),
            ),
            spacing16,
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isDeleting
                    ? null
                    : () => _showDeleteAccountConfirmation(context, ref),
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.appColors.error,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: isDeleting
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                          spacingH8,
                          Text(context.l10n.settingsDeleteAccountInProgress),
                        ],
                      )
                    : Text(context.l10n.settingsDeleteAccount),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showDeleteAccountConfirmation(
    BuildContext context,
    WidgetRef ref,
  ) async {
    // First confirmation
    final firstConfirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.settingsDeleteAccountConfirmTitle),
        content: Text(context.l10n.settingsDeleteAccountConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(context.l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: context.appColors.error,
              foregroundColor: Colors.white,
            ),
            child: Text(context.l10n.delete),
          ),
        ],
      ),
    );

    if (firstConfirm != true || !context.mounted) return;

    // Second confirmation (double check)
    final secondConfirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.settingsDeleteAccountConfirmSecondTitle),
        content: Text(
          context.l10n.settingsDeleteAccountConfirmSecondMessage,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(context.l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: context.appColors.error,
              foregroundColor: Colors.white,
            ),
            child: Text(context.l10n.delete),
          ),
        ],
      ),
    );

    if (secondConfirm != true || !context.mounted) return;

    // Delete account
    final success =
        await ref.read(authNotifierProvider.notifier).deleteAccount();

    if (!context.mounted) return;

    if (success) {
      // Show success message and navigate to login
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.settingsDeleteAccountSuccess),
          backgroundColor: context.appColors.success,
        ),
      );

      // Navigate to login after a short delay
      Future.delayed(const Duration(milliseconds: 500), () {
        if (context.mounted) {
          context.go('/login');
        }
      });
    } else {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.settingsDeleteAccountError),
          backgroundColor: context.appColors.error,
        ),
      );
    }
  }
}
