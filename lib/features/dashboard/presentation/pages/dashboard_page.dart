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
import '../widgets/dashboard_action_button.dart';
import '../widgets/dashboard_stat_card.dart';

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
          style: context.textStyles.titleLarge.copyWith(
            color: context.appColors.primary,
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
                style: context.textStyles.bodyLarge.copyWith(
                  color: context.appColors.textSecondary,
                ),
              ),
              spacing8,
              Text(
                currentUser?.displayNameOrEmail ?? context.l10n.authUser,
                style: context.textStyles.displayMedium.copyWith(
                  color: context.appColors.textPrimary,
                ),
              ),
              spacing32,

              // Quick Stats
              Row(
                children: [
                  Expanded(
                    child: DashboardStatCard(
                      icon: Icons.image_outlined,
                      title: context.l10n.dashboardProjects,
                      value: '0',
                      color: context.appColors.primary,
                    ),
                  ),
                  spacingH16,
                  Expanded(
                    child: DashboardStatCard(
                      icon: Icons.favorite_outline,
                      title: context.l10n.dashboardFavorites,
                      value: '0',
                      color: context.appColors.error,
                    ),
                  ),
                ],
              ),
              spacing16,
              Row(
                children: [
                  Expanded(
                    child: DashboardStatCard(
                      icon: Icons.auto_awesome_outlined,
                      title: context.l10n.dashboardAIEdits,
                      value: '0',
                      color: context.appColors.secondary,
                    ),
                  ),
                  spacingH16,
                  Expanded(
                    child: DashboardStatCard(
                      icon: Icons.cloud_upload_outlined,
                      title: context.l10n.dashboardUploads,
                      value: '0',
                      color: context.appColors.success,
                    ),
                  ),
                ],
              ),
              spacing32,

              // Quick Actions
              Text(
                context.l10n.dashboardQuickActions,
                style: context.textStyles.titleMedium.copyWith(
                  color: context.appColors.textPrimary,
                ),
              ),
              spacing16,
              DashboardActionButton(
                icon: Icons.add_photo_alternate,
                title: context.l10n.dashboardUploadPhoto,
                subtitle: context.l10n.dashboardUploadPhotoSubtitle,
                onTap: () {
                  // TODO: Navigate to upload
                },
              ),
              spacing12,
              DashboardActionButton(
                icon: Icons.folder_outlined,
                title: context.l10n.dashboardBrowseProjects,
                subtitle: context.l10n.dashboardBrowseProjectsSubtitle,
                onTap: () {
                  // TODO: Navigate to projects
                },
              ),
              spacing12,
              DashboardActionButton(
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
                DashboardActionButton(
                  icon: Icons.bug_report,
                  title: context.l10n.dashboardLoggerDemo,
                  subtitle: context.l10n.dashboardLoggerDemoSubtitle,
                  onTap: () {
                    context.push(LoggerDemoPage.routeName);
                  },
                ),
              ],

              spacing32,

              // Recent Activity
              Text(
                context.l10n.dashboardRecentActivity,
                style: context.textStyles.titleMedium.copyWith(
                  color: context.appColors.textPrimary,
                ),
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
                      style: context.textStyles.bodyLarge.copyWith(
                        color: context.appColors.textSecondary,
                      ),
                    ),
                    spacing8,
                    Text(
                      context.l10n.emptyActivityMessage,
                      style: context.textStyles.bodySmall.copyWith(
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
