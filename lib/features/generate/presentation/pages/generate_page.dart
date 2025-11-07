import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../common/presentation/extensions/localization_extension.dart';
import '../../../../common/presentation/spacing.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_text_styles.dart';

class GeneratePage extends HookConsumerWidget {
  static const routeName = '/generate';

  const GeneratePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: context.appColors.background,
      appBar: AppBar(
        surfaceTintColor: context.appColors.background,
        backgroundColor: context.appColors.background,
        elevation: 0,
        title: Text(
          context.l10n.generateTitle,
          style: AppTextStyles.titleLarge.copyWith(
            color: AppColors.primary,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: paddingAll24,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Placeholder content
              Container(
                padding: paddingAll24,
                decoration: BoxDecoration(
                  color: context.appColors.cardBackground,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: context.appColors.border),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.auto_awesome,
                      size: 64,
                      color: context.appColors.primary,
                    ),
                    spacing16,
                    Text(
                      context.l10n.generateTitle,
                      style: AppTextStyles.titleLarge,
                    ),
                    spacing8,
                    Text(
                      'Generate feature coming soon',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: context.appColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

