import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:q_architecture/q_architecture.dart';

import '../../../../common/data/services/image_picker_service.dart';
import '../../../../common/presentation/extensions/localization_extension.dart';
import '../../../../common/presentation/spacing.dart';
import '../../../../common/presentation/utils/snackbar_helper.dart';
import '../../../../common/presentation/widgets/error_view.dart';
import '../../../../common/presentation/widgets/image_source_bottom_sheet.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_text_styles.dart';
import '../../../auth/domain/notifiers/auth_notifier.dart';
import '../../../settings/presentation/pages/settings_page.dart';
import '../../domain/notifiers/profile_notifier.dart';
import '../widgets/avatar_widget.dart';

class ProfilePage extends HookConsumerWidget {
  static const routeName = '/profile';

  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileNotifierProvider);
    final displayNameController = useTextEditingController();
    final isEditing = useState(false);

    useEffect(() {
      Future.microtask(() {
        ref.read(profileNotifierProvider.notifier).loadProfile();
      });
      return null;
    }, const []);

    // Update controller when profile loads
    useEffect(() {
      profileState.maybeWhen(
        data: (user) {
          if (!isEditing.value) {
            displayNameController.text = user.displayName ?? '';
          }
        },
        orElse: () {},
      );
      return null;
    }, [profileState]);

    return Scaffold(
      backgroundColor: context.appColors.background,
      appBar: AppBar(
        surfaceTintColor: context.appColors.background,
        backgroundColor: context.appColors.background,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          context.l10n.profile,
          style: context.textStyles.titleLarge.copyWith(
            color: context.appColors.textPrimary,
          ),
        ),
        actions: [
          if (isEditing.value)
            TextButton(
              onPressed: () {
                isEditing.value = false;
                profileState.maybeWhen(
                  data: (user) {
                    displayNameController.text = user.displayName ?? '';
                  },
                  orElse: () {},
                );
              },
              child: Text(
                context.l10n.cancel,
                style: TextStyle(color: context.appColors.textSecondary),
              ),
            ),
          if (!isEditing.value)
            IconButton(
              icon: Icon(
                Icons.edit,
                color: context.appColors.primary,
              ),
              onPressed: () {
                isEditing.value = true;
              },
            ),
        ],
      ),
      body: SafeArea(
        child: profileState.maybeWhen(
          data: (user) => _buildProfileContent(
            context: context,
            ref: ref,
            user: user,
            displayNameController: displayNameController,
            isEditing: isEditing.value,
            isLoading: false,
            onSave: () =>
                _handleSave(context, ref, displayNameController, isEditing),
            onAvatarTap: () => _handleAvatarTap(context, ref),
          ),
          loading: () {
            // Show profile content with loading state on avatar
            final currentUser = ref.watch(currentUserProvider);
            if (currentUser != null) {
              return _buildProfileContent(
                context: context,
                ref: ref,
                user: currentUser,
                displayNameController: displayNameController,
                isEditing: isEditing.value,
                isLoading: true,
                onSave: () =>
                    _handleSave(context, ref, displayNameController, isEditing),
                onAvatarTap: () => _handleAvatarTap(context, ref),
              );
            }
            // Fallback if no current user
            return const Center(child: CircularProgressIndicator());
          },
          error: (failure) => ErrorView(
            failure: failure,
            onRetry: () {
              ref.read(profileNotifierProvider.notifier).loadProfile();
            },
          ),
          orElse: () {
            // Initial state - try to show current user if available
            final currentUser = ref.watch(currentUserProvider);
            if (currentUser != null) {
              return _buildProfileContent(
                context: context,
                ref: ref,
                user: currentUser,
                displayNameController: displayNameController,
                isEditing: isEditing.value,
                isLoading: false,
                onSave: () =>
                    _handleSave(context, ref, displayNameController, isEditing),
                onAvatarTap: () => _handleAvatarTap(context, ref),
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  /// Handles saving display name
  Future<void> _handleSave(
    BuildContext context,
    WidgetRef ref,
    TextEditingController displayNameController,
    ValueNotifier<bool> isEditing,
  ) async {
    final success = await ref
        .read(profileNotifierProvider.notifier)
        .updateDisplayName(displayNameController.text);

    if (success && context.mounted) {
      isEditing.value = false;
      SnackbarHelper.showSuccess(context, context.l10n.successUpdated);
    }
  }

  /// Handles avatar tap - shows image source selection and uploads selected image
  Future<void> _handleAvatarTap(BuildContext context, WidgetRef ref) async {
    // Show image source selection bottom sheet
    final source = await ImageSourceBottomSheet.show(context);
    if (source == null) return;

    // Pick image using service
    final imagePickerService = ref.read(imagePickerServiceProvider);
    final result = await imagePickerService.pickImage(source: source);

    result.fold(
      (failure) {
        // Don't show error for user cancellation
        if (failure.error
                ?.toString()
                .toLowerCase()
                .contains('user_cancelled') !=
            true) {
          SnackbarHelper.showError(context, failure);
        }
      },
      (file) async {
        // Upload avatar
        final success =
            await ref.read(profileNotifierProvider.notifier).uploadAvatar(file);

        if (success && context.mounted) {
          SnackbarHelper.showSuccess(
            context,
            context.l10n.profileAvatarUpdated,
          );
        } else if (context.mounted) {
          SnackbarHelper.showError(
            context,
            Failure.generic(error: context.l10n.errorGeneric),
          );
        }
      },
    );
  }

  /// Builds profile content widget
  Widget _buildProfileContent({
    required BuildContext context,
    required WidgetRef ref,
    required dynamic user,
    required TextEditingController displayNameController,
    required bool isEditing,
    required bool isLoading,
    required VoidCallback onSave,
    required VoidCallback onAvatarTap,
  }) {
    return _ProfileContent(
      user: user,
      displayNameController: displayNameController,
      isEditing: isEditing,
      isLoading: isLoading,
      ref: ref,
      onSave: onSave,
      onAvatarTap: onAvatarTap,
    );
  }
}

class _ProfileContent extends ConsumerWidget {
  final dynamic user;
  final TextEditingController displayNameController;
  final bool isEditing;
  final bool isLoading;
  final WidgetRef ref;
  final VoidCallback onSave;
  final VoidCallback onAvatarTap;

  const _ProfileContent({
    required this.user,
    required this.displayNameController,
    required this.isEditing,
    required this.isLoading,
    required this.ref,
    required this.onSave,
    required this.onAvatarTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: paddingAll16,
        child: Column(
          children: [
            spacing16,
            // Main Profile Card
            Container(
              decoration: BoxDecoration(
                color: context.appColors.cardBackground,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: context.appColors.border,
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: paddingAll24,
                child: Column(
                  children: [
                    // Avatar Section
                    AvatarWidget(
                      photoUrl: isLoading ? null : user.photoUrl,
                      initials: user.initials,
                      onTap: isLoading ? () {} : onAvatarTap,
                      size: 100,
                      isLoading: isLoading,
                    ),
                    spacing20,
                    // Display Name Section
                    _buildInfoRow(
                      context,
                      icon: Icons.person_rounded,
                      label: context.l10n.profileDisplayName,
                      value: isEditing ? null : user.displayNameOrEmail,
                      child: isEditing
                          ? TextField(
                              controller: displayNameController,
                              style: context.textStyles.bodyLarge.copyWith(
                                color: context.appColors.textPrimary,
                              ),
                              decoration: InputDecoration(
                                hintText: context.l10n.profileDisplayNameHint,
                                isDense: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: context.appColors.border,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: context.appColors.primary,
                                    width: 2,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                              ),
                              onSubmitted: (_) => onSave(),
                            )
                          : null,
                    ),
                    if (isEditing) ...[
                      spacing12,
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: onSave,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: context.appColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            context.l10n.save,
                            style: context.textStyles.button.copyWith(
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                    spacing20,
                    Container(
                      height: 1,
                      color: context.appColors.border,
                    ),
                    spacing20,
                    // Email Section
                    _buildInfoRow(
                      context,
                      icon: Icons.email_rounded,
                      label: context.l10n.authEmail,
                      value: user.email,
                    ),
                    spacing20,
                    Container(
                      height: 1,
                      color: context.appColors.border,
                    ),
                    spacing20,
                    // Member Since Section
                    _buildInfoRow(
                      context,
                      icon: Icons.calendar_today_rounded,
                      label: context.l10n.profileMemberSince,
                      value: _formatDate(context, user.createdAt),
                    ),
                  ],
                ),
              ),
            ),
            spacing24,

            // Settings Section
            Container(
              decoration: BoxDecoration(
                color: context.appColors.cardBackground,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: context.appColors.border,
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildSettingsItem(
                    context,
                    icon: Icons.settings_rounded,
                    title: context.l10n.settingsTitle,
                    subtitle: context.l10n.settingsAppearance,
                    onTap: () {
                      context.push(SettingsPage.routeName);
                    },
                  ),
                  Divider(
                    height: 1,
                    thickness: 1,
                    indent: 60,
                    color: context.appColors.border,
                  ),
                  _buildSettingsItem(
                    context,
                    icon: Icons.logout_rounded,
                    title: context.l10n.authSignOut,
                    subtitle: context.l10n.confirmLogoutTitle,
                    isDestructive: true,
                    onTap: () => _showLogoutConfirmation(context, ref),
                  ),
                ],
              ),
            ),
            spacing16,
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDestructive
                        ? [
                            context.appColors.error.withValues(alpha: 0.15),
                            context.appColors.error.withValues(alpha: 0.08),
                          ]
                        : [
                            context.appColors.primary.withValues(alpha: 0.15),
                            context.appColors.primary.withValues(alpha: 0.08),
                          ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  icon,
                  color: isDestructive
                      ? context.appColors.error
                      : context.appColors.primary,
                  size: 24,
                ),
              ),
              spacingH16,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: context.textStyles.bodyLarge.copyWith(
                        color: isDestructive
                            ? context.appColors.error
                            : context.appColors.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    spacing4,
                    Text(
                      subtitle,
                      style: context.textStyles.bodySmall.copyWith(
                        color: context.appColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: context.appColors.textSecondary.withValues(alpha: 0.6),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showLogoutConfirmation(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.confirmLogoutTitle),
        content: Text(context.l10n.confirmLogout),
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
            child: Text(context.l10n.authSignOut),
          ),
        ],
      ),
    );

    if (confirm == true && context.mounted) {
      await ref.read(authNotifierProvider.notifier).signOut();
      if (context.mounted) {
        context.go('/login');
      }
    }
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    String? value,
    Widget? child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: context.appColors.textSecondary,
            ),
            spacingH8,
            Text(
              label,
              style: context.textStyles.labelMedium.copyWith(
                color: context.appColors.textSecondary,
              ),
            ),
          ],
        ),
        spacing8,
        child ??
            Text(
              value ?? '',
              style: context.textStyles.bodyLarge.copyWith(
                color: context.appColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
      ],
    );
  }

  String _formatDate(BuildContext context, DateTime date) {
    // Use localized date format: "MMMM yyyy"
    // Automatically uses locale from context (e.g., "January 2024" or "siječanj 2024")
    final locale = Localizations.localeOf(context);
    return DateFormat.yMMMM(locale.toString()).format(date);
  }
}
