import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../common/domain/base_state.dart';
import '../../../../common/presentation/extensions/localization_extension.dart';
import '../../../../common/presentation/spacing.dart';
import '../../../../common/presentation/utils/snackbar_helper.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_text_styles.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../auth/domain/notifiers/auth_notifier.dart';

class DeleteAccountCard extends ConsumerWidget {
  final BaseState<UserEntity?> authState;

  const DeleteAccountCard({
    super.key,
    required this.authState,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDeleting = authState is BaseLoading;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: context.appColors.error.withValues(alpha: 0.3),
        ),
      ),
      color: context.appColors.cardBackground,
      child: Padding(
        padding: paddingAll16,
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
                          SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
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
        backgroundColor: context.appColors.cardBackground,
        title: Text(
          context.l10n.settingsDeleteAccountConfirmTitle,
          style: context.textStyles.titleLarge.copyWith(
            color: context.appColors.textPrimary,
          ),
        ),
        content: Text(
          context.l10n.settingsDeleteAccountConfirmMessage,
          style: context.textStyles.bodyMedium.copyWith(
            color: context.appColors.textSecondary,
          ),
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

    if (firstConfirm != true || !context.mounted) return;

    // Second confirmation (double check)
    final secondConfirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: context.appColors.cardBackground,
        title: Text(
          context.l10n.settingsDeleteAccountConfirmSecondTitle,
          style: context.textStyles.titleLarge.copyWith(
            color: context.appColors.textPrimary,
          ),
        ),
        content: Text(
          context.l10n.settingsDeleteAccountConfirmSecondMessage,
          style: context.textStyles.bodyMedium.copyWith(
            color: context.appColors.textSecondary,
          ),
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
      SnackbarHelper.showSuccess(
        context,
        context.l10n.settingsDeleteAccountSuccess,
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
