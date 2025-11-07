import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../../common/presentation/extensions/localization_extension.dart';
import '../../../../common/presentation/spacing.dart';
import '../../../../common/presentation/utils/bottom_sheet_helper.dart';
import '../../../../common/presentation/widgets/error_view.dart';
import '../../../../common/utils/logger/app_logger.dart';
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
          data: (user) => _ProfileContent(
            user: user,
            displayNameController: displayNameController,
            isEditing: isEditing.value,
            isLoading: false,
            ref: ref,
            onSave: () async {
              final success = await ref
                  .read(profileNotifierProvider.notifier)
                  .updateDisplayName(displayNameController.text);
              if (success && context.mounted) {
                isEditing.value = false;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(context.l10n.successUpdated),
                    backgroundColor: context.appColors.success,
                  ),
                );
              }
            },
            onAvatarTap: () => _showImagePicker(context, ref),
          ),
          loading: () {
            // Show profile content with loading state on avatar
            final currentUser = ref.watch(currentUserProvider);
            if (currentUser != null) {
              return _ProfileContent(
                user: currentUser,
                displayNameController: displayNameController,
                isEditing: isEditing.value,
                isLoading: true,
                ref: ref,
                onSave: () async {
                  final success = await ref
                      .read(profileNotifierProvider.notifier)
                      .updateDisplayName(displayNameController.text);
                  if (success && context.mounted) {
                    isEditing.value = false;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(context.l10n.successUpdated),
                        backgroundColor: context.appColors.success,
                      ),
                    );
                  }
                },
                onAvatarTap: () => _showImagePicker(context, ref),
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
              return _ProfileContent(
                user: currentUser,
                displayNameController: displayNameController,
                isEditing: isEditing.value,
                isLoading: false,
                ref: ref,
                onSave: () async {
                  final success = await ref
                      .read(profileNotifierProvider.notifier)
                      .updateDisplayName(displayNameController.text);
                  if (success && context.mounted) {
                    isEditing.value = false;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(context.l10n.successUpdated),
                        backgroundColor: context.appColors.success,
                      ),
                    );
                  }
                },
                onAvatarTap: () => _showImagePicker(context, ref),
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  Future<void> _showImagePicker(BuildContext context, WidgetRef ref) async {
    final logger = AppLogger.instance;
    logger.debug('📷 Opening image picker bottom sheet...');

    final picker = ImagePicker();

    ImageSource? source;
    try {
      logger.debug('📷 Showing modal bottom sheet...');
      source = await BottomSheetHelper.show<ImageSource>(
        context: context,
        backgroundColor: context.appColors.contentBackground,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (context) => SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: paddingAll16,
                child: Text(
                  context.l10n.profileSelectAvatarSource,
                  style: context.textStyles.titleMedium,
                ),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: Text(context.l10n.profileSelectFromGallery),
                onTap: () {
                  logger.debug('📷 User selected: Gallery');
                  Navigator.pop(context, ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: Text(context.l10n.profileTakePhoto),
                onTap: () {
                  logger.debug('📷 User selected: Camera');
                  Navigator.pop(context, ImageSource.camera);
                },
              ),
              spacing16,
            ],
          ),
        ),
      );
      logger.debug(
          '📷 Bottom sheet closed, result: ${source != null ? source.toString() : "null"}');
    } catch (e, stackTrace) {
      logger.error(
        '❌ Error showing bottom sheet',
        error: e,
        stackTrace: stackTrace,
      );
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error opening picker: ${e.toString()}'),
            backgroundColor: context.appColors.error,
          ),
        );
      }
      return;
    }

    if (source == null) {
      logger.debug('📷 User cancelled image source selection');
      return;
    }

    logger.info(
        '📷 Image source selected: ${source == ImageSource.gallery ? "Gallery" : "Camera"}');

    try {
      logger.debug('📷 About to call picker.pickImage()...');
      logger.debug(
          '📷 Image picker settings: maxWidth=1024, maxHeight=1024, quality=85');
      logger.debug(
          '📷 Source type: $source (${source == ImageSource.gallery ? "Gallery" : "Camera"})');

      // Wrap pickImage in additional try-catch to catch platform errors
      XFile? image;
      try {
        logger.debug('📷 Calling picker.pickImage() now...');
        image = await picker.pickImage(
          source: source,
          maxWidth: 1024,
          maxHeight: 1024,
          imageQuality: 85,
        );
        logger.debug(
            '📷 pickImage() call completed, result: ${image != null ? "success" : "null"}');
      } catch (pickError, pickStack) {
        logger.error(
          '❌ Error in picker.pickImage() call',
          error: pickError,
          stackTrace: pickStack,
        );
        logger.debug('📷 Pick error type: ${pickError.runtimeType}');
        logger.debug('📷 Pick error toString: ${pickError.toString()}');

        // Re-throw to be caught by outer catch
        rethrow;
      }

      if (image == null) {
        logger
            .warning('📷 Image picker returned null - user may have cancelled');
        return;
      }

      logger.info('✅ Image picked successfully: ${image.path}');
      logger.debug(
          '📷 Image details: name=${image.name}, size=${image.length} bytes');

      if (!context.mounted) {
        logger.warning('📷 Context not mounted, skipping upload');
        return;
      }

      final file = File(image.path);

      // Check if file exists
      if (!await file.exists()) {
        logger.error(
          '📷 Selected image file does not exist',
          error: 'File path: ${image.path}',
        );
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Image file not found'),
              backgroundColor: context.appColors.error,
            ),
          );
        }
        return;
      }

      final fileSize = await file.length();
      logger.debug(
          '📷 File size: $fileSize bytes (${(fileSize / 1024).toStringAsFixed(2)} KB)');

      logger.info('📤 Starting avatar upload...');
      final success =
          await ref.read(profileNotifierProvider.notifier).uploadAvatar(file);

      if (success) {
        logger.info('✅ Avatar upload completed successfully');
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.l10n.profileAvatarUpdated),
              backgroundColor: context.appColors.success,
            ),
          );
        }
      } else {
        logger.error('❌ Avatar upload failed - notifier returned false');
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.l10n.errorGeneric),
              backgroundColor: context.appColors.error,
            ),
          );
        }
      }
    } on PlatformException catch (e, stackTrace) {
      logger.error(
        '❌ PlatformException during image picker/upload process',
        error: e,
        stackTrace: stackTrace,
      );
      logger.debug('📷 PlatformException code: ${e.code}');
      logger.debug('📷 PlatformException message: ${e.message}');
      logger.debug('📷 PlatformException details: ${e.details}');

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Platform Error: ${e.message ?? e.code}'),
            backgroundColor: context.appColors.error,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } catch (e, stackTrace) {
      logger.error(
        '❌ Error during image picker/upload process',
        error: e,
        stackTrace: stackTrace,
      );
      logger.debug('📷 Error type: ${e.runtimeType}');
      logger.debug('📷 Error message: ${e.toString()}');
      logger.debug('📷 Error runtimeType: ${e.runtimeType}');

      // Check for specific error types
      if (e.toString().contains('Permission') ||
          e.toString().contains('permission') ||
          e.toString().contains('denied')) {
        logger.error(
          '📷 Permission error detected - check Info.plist (iOS) or AndroidManifest.xml (Android)',
        );
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: context.appColors.error,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
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
