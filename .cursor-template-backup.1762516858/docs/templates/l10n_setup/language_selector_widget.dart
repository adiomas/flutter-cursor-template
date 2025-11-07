import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../locale_provider.dart';

/// Language selector widget - dropdown for selecting app language
/// 
/// Usage:
/// ```dart
/// // In AppBar actions
/// AppBar(
///   actions: [
///     const LanguageSelector(),
///   ],
/// )
/// ```
class LanguageSelector extends ConsumerWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);
    
    return PopupMenuButton<Locale>(
      initialValue: currentLocale,
      icon: const Icon(Icons.language),
      tooltip: 'Select Language',
      onSelected: (locale) {
        ref.read(localeProvider.notifier).setLocale(locale);
      },
      itemBuilder: (context) => [
        _buildLanguageMenuItem(
          locale: const Locale('en'),
          flag: '🇬🇧',
          name: 'English',
          isSelected: currentLocale.languageCode == 'en',
        ),
        _buildLanguageMenuItem(
          locale: const Locale('hr'),
          flag: '🇭🇷',
          name: 'Hrvatski',
          isSelected: currentLocale.languageCode == 'hr',
        ),
        // Add more languages as needed:
        // _buildLanguageMenuItem(
        //   locale: const Locale('de'),
        //   flag: '🇩🇪',
        //   name: 'Deutsch',
        //   isSelected: currentLocale.languageCode == 'de',
        // ),
      ],
    );
  }
  
  PopupMenuItem<Locale> _buildLanguageMenuItem({
    required Locale locale,
    required String flag,
    required String name,
    required bool isSelected,
  }) {
    return PopupMenuItem<Locale>(
      value: locale,
      child: Row(
        children: [
          Text(
            flag,
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(name),
          ),
          if (isSelected)
            const Icon(
              Icons.check,
              size: 20,
              color: Colors.green,
            ),
        ],
      ),
    );
  }
}

/// Language selector as a settings tile
/// 
/// Usage:
/// ```dart
/// // In settings page
/// ListView(
///   children: [
///     const LanguageSettingsTile(),
///   ],
/// )
/// ```
class LanguageSettingsTile extends ConsumerWidget {
  const LanguageSettingsTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);
    
    return ListTile(
      leading: const Icon(Icons.language),
      title: const Text('Language'),
      subtitle: Text(_getLanguageName(currentLocale.languageCode)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        _showLanguageDialog(context, ref, currentLocale);
      },
    );
  }
  
  String _getLanguageName(String code) {
    return switch (code) {
      'en' => 'English',
      'hr' => 'Hrvatski',
      'de' => 'Deutsch',
      'es' => 'Español',
      'fr' => 'Français',
      _ => 'Unknown',
    };
  }
  
  void _showLanguageDialog(
    BuildContext context,
    WidgetRef ref,
    Locale currentLocale,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLanguageRadio(
              context,
              ref,
              locale: const Locale('en'),
              flag: '🇬🇧',
              name: 'English',
              currentLocale: currentLocale,
            ),
            _buildLanguageRadio(
              context,
              ref,
              locale: const Locale('hr'),
              flag: '🇭🇷',
              name: 'Hrvatski',
              currentLocale: currentLocale,
            ),
            // Add more languages
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
  
  Widget _buildLanguageRadio(
    BuildContext context,
    WidgetRef ref, {
    required Locale locale,
    required String flag,
    required String name,
    required Locale currentLocale,
  }) {
    final isSelected = currentLocale.languageCode == locale.languageCode;
    
    return RadioListTile<Locale>(
      value: locale,
      groupValue: currentLocale,
      title: Row(
        children: [
          Text(flag, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 12),
          Text(name),
        ],
      ),
      onChanged: (value) {
        if (value != null) {
          ref.read(localeProvider.notifier).setLocale(value);
          Navigator.pop(context);
        }
      },
      selected: isSelected,
    );
  }
}

