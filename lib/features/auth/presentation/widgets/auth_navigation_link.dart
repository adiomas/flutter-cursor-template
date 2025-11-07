i[mport 'package:flutter/material.dart';

import '../../../../theme/app_colors.dart';
import '../../../../theme/app_text_styles.dart';

/// Reusable navigation link widget for auth pages
/// Shows text with a clickable link to navigate between auth pages
class AuthNavigationLink extends StatelessWidget {
  final String questionText;
  final String linkText;
  final VoidCallback onTap;

  const AuthNavigationLink({
    super.key,
    required this.questionText,
    required this.linkText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          questionText,
          style: context.textStyles.bodyMedium,
        ),
        TextButton(
          onPressed: onTap,
          child: Text(
            linkText,
            style: context.textStyles.bodyMedium.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

