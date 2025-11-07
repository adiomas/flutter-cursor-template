import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../common/domain/notifiers/theme_notifier.dart';
import '../../../../common/presentation/extensions/localization_extension.dart';
import '../../../../common/presentation/spacing.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_text_styles.dart';
import '../../../auth/domain/notifiers/auth_notifier.dart';
import '../widgets/delete_account_card.dart';
import '../widgets/settings_section_header.dart';
import '../widgets/theme_selector_card.dart';

class SettingsPage extends HookConsumerWidget {
  static const routeName = '/settings';

  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeNotifierProvider);
    final authState = ref.watch(authNotifierProvider);

    return Scaffold(
      backgroundColor: context.appColors.background,
      appBar: AppBar(
        surfaceTintColor: context.appColors.background,
        backgroundColor: context.appColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(
          context.l10n.settingsTitle,
          style: context.textStyles.titleLarge.copyWith(
            color: context.appColors.textPrimary,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Appearance Section
                SettingsSectionHeader(
                  title: context.l10n.settingsAppearance,
                ),
                spacing16,
                ThemeSelectorCard(currentMode: themeMode),
                spacing32,

                // Account Section
                SettingsSectionHeader(
                  title: context.l10n.settingsAccount,
                ),
                spacing16,
                DeleteAccountCard(authState: authState),
                spacing32,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
