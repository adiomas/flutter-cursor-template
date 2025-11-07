import 'package:flutter/widgets.dart';
import '../../../l10n/generated/app_localizations.dart';

/// Extension for easy access to localization
/// 
/// Usage:
/// ```dart
/// Text(context.l10n.save)
/// ```
/// 
/// Instead of:
/// ```dart
/// Text(AppLocalizations.of(context)!.save)
/// ```
extension LocalizationExtension on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

