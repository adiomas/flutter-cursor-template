import 'package:flutter/material.dart';

import '../../../../common/presentation/extensions/localization_extension.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_text_styles.dart';

/// Reusable divider widget for auth pages
/// Shows "Or continue with" text between sections
class AuthDivider extends StatelessWidget {
  const AuthDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
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
    );
  }
}
