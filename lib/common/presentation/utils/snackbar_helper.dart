import 'package:flutter/material.dart';
import 'package:q_architecture/q_architecture.dart';

import '../../../theme/app_colors.dart';
import '../extensions/localization_extension.dart';

/// Helper class for showing snackbar messages consistently across the app
class SnackbarHelper {
  /// Shows an error snackbar with localized message
  static void showError(
    BuildContext context,
    Failure failure, {
    Duration duration = const Duration(seconds: 4),
  }) {
    if (!context.mounted) return;

    final message = _getErrorMessage(context, failure);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: context.appColors.error,
        duration: duration,
      ),
    );
  }

  /// Shows a success snackbar with localized message
  static void showSuccess(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: context.appColors.success,
        duration: duration,
      ),
    );
  }

  /// Shows a warning snackbar with localized message
  static void showWarning(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: context.appColors.warning,
        duration: duration,
      ),
    );
  }

  /// Gets user-friendly error message from failure
  static String _getErrorMessage(BuildContext context, Failure failure) {
    // Check for specific error codes
    final errorString = failure.error?.toString().toLowerCase() ?? '';

    if (errorString.contains('permission') || errorString.contains('denied')) {
      return context.l10n.errorImagePickerPermission;
    }

    if (errorString.contains('user_cancelled') ||
        errorString.contains('cancelled')) {
      // Don't show error for user cancellation
      return '';
    }

    if (errorString.contains('file_not_found')) {
      return context.l10n.errorImagePickerFileNotFound;
    }

    // Fallback to generic error
    return context.l10n.errorGeneric;
  }
}
