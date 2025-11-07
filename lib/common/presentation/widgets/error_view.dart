import 'package:flutter/material.dart';
import 'package:q_architecture/q_architecture.dart';
import '../../../theme/app_colors.dart';
import '../extensions/localization_extension.dart';
import '../spacing.dart';

class ErrorView extends StatelessWidget {
  final Failure failure;
  final VoidCallback? onRetry;
  
  const ErrorView({
    super.key,
    required this.failure,
    this.onRetry,
  });
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: paddingAll24,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: AppColors.error,
            ),
            spacing16,
            Text(
              context.l10n.errorOops,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            spacing8,
            Text(
              context.l10n.errorGeneric,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
            if (onRetry != null) ...[
              spacing24,
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: Text(context.l10n.tryAgain),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

