import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../common/domain/notifiers/theme_notifier.dart';
import '../../../../common/presentation/extensions/localization_extension.dart';
import '../../../../common/presentation/spacing.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_text_styles.dart';

class ThemeSelectorCard extends ConsumerWidget {
  final ThemeMode currentMode;

  const ThemeSelectorCard({
    super.key,
    required this.currentMode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: context.appColors.border),
      ),
      color: context.appColors.cardBackground,
      child: Padding(
        padding: paddingAll16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.palette_outlined,
                  color: context.appColors.textSecondary,
                ),
                spacingH12,
                Text(
                  context.l10n.settingsTheme,
                  style: context.textStyles.bodyLarge.copyWith(
                    color: context.appColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            spacing16,
            _ThemeOption(
              mode: ThemeMode.light,
              label: context.l10n.settingsThemeLight,
              icon: Icons.light_mode_outlined,
              isSelected: currentMode == ThemeMode.light,
              onTap: () {
                ref.read(themeNotifierProvider.notifier).setThemeMode(
                      ThemeMode.light,
                    );
              },
            ),
            spacing8,
            _ThemeOption(
              mode: ThemeMode.dark,
              label: context.l10n.settingsThemeDark,
              icon: Icons.dark_mode_outlined,
              isSelected: currentMode == ThemeMode.dark,
              onTap: () {
                ref.read(themeNotifierProvider.notifier).setThemeMode(
                      ThemeMode.dark,
                    );
              },
            ),
            spacing8,
            _ThemeOption(
              mode: ThemeMode.system,
              label: context.l10n.settingsThemeSystem,
              icon: Icons.brightness_auto_outlined,
              isSelected: currentMode == ThemeMode.system,
              onTap: () {
                ref.read(themeNotifierProvider.notifier).setThemeMode(
                      ThemeMode.system,
                    );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ThemeOption extends StatelessWidget {
  final ThemeMode mode;
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemeOption({
    required this.mode,
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: isSelected
              ? context.appColors.primary.withValues(alpha: 0.1)
              : context.appColors.cardBackground,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? context.appColors.primary
                  : context.appColors.textSecondary,
              size: 20,
            ),
            spacingH12,
            Expanded(
              child: Text(
                label,
                style: context.textStyles.bodyMedium.copyWith(
                  color: isSelected
                      ? context.appColors.primary
                      : context.appColors.textPrimary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: context.appColors.primary,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}

