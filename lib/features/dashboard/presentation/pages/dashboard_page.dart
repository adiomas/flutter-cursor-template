import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../common/domain/app_environment.dart';
import '../../../../common/presentation/extensions/localization_extension.dart';
import '../../../../common/presentation/spacing.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_text_styles.dart';
import '../../../auth/domain/notifiers/auth_notifier.dart';
import '../../../debug/presentation/pages/logger_demo_page.dart';

class DashboardPage extends HookConsumerWidget {
  static const routeName = '/home';

  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);

    return Scaffold(
      backgroundColor: context.appColors.background,
      appBar: AppBar(
        surfaceTintColor: context.appColors.background,
        backgroundColor: context.appColors.background,
        elevation: 0,
        title: Text(
          context.l10n.appTitle,
          style: AppTextStyles.titleLarge.copyWith(
            color: AppColors.primary,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: Navigate to notifications
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: paddingAll24,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Section
              Text(
                context.l10n.authWelcomeBackUser,
                style: AppTextStyles.bodyLarge.copyWith(
                  color: context.appColors.textSecondary,
                ),
              ),
              spacing8,
              Text(
                currentUser?.displayNameOrEmail ?? context.l10n.authUser,
                style: AppTextStyles.displayMedium,
              ),
              spacing32,

              // Quick Stats
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      icon: Icons.image_outlined,
                      title: context.l10n.dashboardProjects,
                      value: '0',
                      color: AppColors.primary,
                    ),
                  ),
                  spacingH16,
                  Expanded(
                    child: _StatCard(
                      icon: Icons.favorite_outline,
                      title: context.l10n.dashboardFavorites,
                      value: '0',
                      color: AppColors.error,
                    ),
                  ),
                ],
              ),
              spacing16,
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      icon: Icons.auto_awesome_outlined,
                      title: context.l10n.dashboardAIEdits,
                      value: '0',
                      color: AppColors.secondary,
                    ),
                  ),
                  spacingH16,
                  Expanded(
                    child: _StatCard(
                      icon: Icons.cloud_upload_outlined,
                      title: context.l10n.dashboardUploads,
                      value: '0',
                      color: AppColors.success,
                    ),
                  ),
                ],
              ),
              spacing32,

              // Quick Actions
              Text(
                context.l10n.dashboardQuickActions,
                style: AppTextStyles.titleMedium,
              ),
              spacing16,
              _ActionButton(
                icon: Icons.add_photo_alternate,
                title: context.l10n.dashboardUploadPhoto,
                subtitle: context.l10n.dashboardUploadPhotoSubtitle,
                onTap: () {
                  // TODO: Navigate to upload
                },
              ),
              spacing12,
              _ActionButton(
                icon: Icons.folder_outlined,
                title: context.l10n.dashboardBrowseProjects,
                subtitle: context.l10n.dashboardBrowseProjectsSubtitle,
                onTap: () {
                  // TODO: Navigate to projects
                },
              ),
              spacing12,
              _ActionButton(
                icon: Icons.auto_fix_high,
                title: context.l10n.dashboardAITemplates,
                subtitle: context.l10n.dashboardAITemplatesSubtitle,
                onTap: () {
                  // TODO: Navigate to templates
                },
              ),

              // Debug Actions (only in dev/staging)
              if (EnvInfo.isDevelopment || EnvInfo.isStaging) ...[
                spacing12,
                _ActionButton(
                  icon: Icons.bug_report,
                  title: '🐛 Logger Demo',
                  subtitle: 'Test logging system & shake-to-open console',
                  onTap: () {
                    context.push(LoggerDemoPage.routeName);
                  },
                ),
              ],

              spacing32,

              // Recent Activity
              Text(
                context.l10n.dashboardRecentActivity,
                style: AppTextStyles.titleMedium,
              ),
              spacing16,
              Container(
                padding: paddingAll24,
                decoration: BoxDecoration(
                  color: context.appColors.cardBackground,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: context.appColors.border),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.inbox_outlined,
                      size: 48,
                      color: context.appColors.textSecondary,
                    ),
                    spacing12,
                    Text(
                      context.l10n.emptyActivityTitle,
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: context.appColors.textSecondary,
                      ),
                    ),
                    spacing8,
                    Text(
                      context.l10n.emptyActivityMessage,
                      style: AppTextStyles.bodySmall,
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

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: paddingAll16,
      decoration: BoxDecoration(
        color: context.appColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.appColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          spacing12,
          Text(
            value,
            style: AppTextStyles.displayMedium.copyWith(color: color),
          ),
          spacing4,
          Text(
            title,
            style: AppTextStyles.bodySmall.copyWith(
              color: context.appColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: paddingAll16,
        decoration: BoxDecoration(
          color: context.appColors.cardBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: context.appColors.border),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: context.appColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: context.appColors.primary, size: 24),
            ),
            spacingH16,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                      color: context.appColors.textPrimary,
                    ),
                  ),
                  spacing4,
                  Text(
                    subtitle,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: context.appColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: context.appColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
