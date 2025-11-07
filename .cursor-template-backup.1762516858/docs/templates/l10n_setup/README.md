# L10n (Localization) Setup Template

Complete setup files for Flutter localization. Copy these to your project to enable multilingual support from day one.

## Quick Setup (5 minutes)

### 1. Copy Files to Your Project

```bash
# From your project root
cp docs/templates/l10n_setup/l10n.yaml ./
mkdir -p lib/l10n/arb
cp docs/templates/l10n_setup/arb/*.arb lib/l10n/arb/
mkdir -p lib/common/presentation/extensions
cp docs/templates/l10n_setup/extensions/localization_extension.dart lib/common/presentation/extensions/
mkdir -p lib/common/domain/providers
cp docs/templates/l10n_setup/locale_provider.dart lib/common/domain/providers/
mkdir -p lib/common/presentation/widgets
cp docs/templates/l10n_setup/language_selector_widget.dart lib/common/presentation/widgets/
```

### 2. Add Dependencies

Add to `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter
  intl: any
  shared_preferences: ^2.2.2  # For persisting language selection

flutter:
  generate: true
```

### 3. Run Code Generation

```bash
flutter pub get
flutter gen-l10n
```

This generates `lib/l10n/generated/app_localizations.dart`.

### 4. Configure MaterialApp

Update `lib/main.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'l10n/generated/app_localizations.dart';
import 'common/domain/providers/locale_provider.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    
    return MaterialApp(
      // Localization setup
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // English
        Locale('hr'), // Croatian
      ],
      locale: locale, // From provider
      
      // App title from localization
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      
      home: const HomePage(),
    );
  }
}
```

### 5. Use in Your Widgets

```dart
import 'package:flutter/material.dart';
import '../common/presentation/extensions/localization_extension.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.appTitle),
      ),
      body: Center(
        child: Column(
          children: [
            Text(context.l10n.greetingHello('John')),
            ElevatedButton(
              onPressed: () {},
              child: Text(context.l10n.save),
            ),
          ],
        ),
      ),
    );
  }
}
```

## File Structure

```
lib/
├── l10n/
│   ├── arb/
│   │   ├── app_en.arb          # English (base)
│   │   └── app_hr.arb          # Croatian
│   └── generated/              # Auto-generated (don't edit)
│       └── app_localizations.dart
├── common/
│   ├── domain/
│   │   └── providers/
│   │       └── locale_provider.dart
│   └── presentation/
│       ├── extensions/
│       │   └── localization_extension.dart
│       └── widgets/
│           └── language_selector_widget.dart
└── main.dart

# Project root
l10n.yaml                       # Configuration
```

## Included Files

### ARB Files

- **`app_en.arb`** - English translations (base language)
- **`app_hr.arb`** - Croatian translations

Both files include:
- ✅ Common actions (save, delete, edit, etc.)
- ✅ Validation messages
- ✅ Error messages
- ✅ Success messages
- ✅ Empty states
- ✅ Auth screens
- ✅ Date/time strings
- ✅ Placeholders
- ✅ Parameterized strings
- ✅ Plural forms

### Providers

- **`locale_provider.dart`** - State management for language
  - Persists selection to SharedPreferences
  - Convenience methods (setEnglish, setCroatian, etc.)

### Extensions

- **`localization_extension.dart`** - Shortcut for accessing translations
  - Use `context.l10n.save` instead of `AppLocalizations.of(context)!.save`

### Widgets

- **`language_selector_widget.dart`** - Ready-to-use UI components
  - `LanguageSelector` - Popup menu for AppBar
  - `LanguageSettingsTile` - List tile for settings page

## Usage Examples

### Basic Text

```dart
// ❌ Never do this
Text('Save')

// ✅ Always do this
Text(context.l10n.save)
```

### With Parameters

```dart
Text(context.l10n.greetingHello('John'))  // "Hello, John!"
```

### Pluralization

```dart
Text(context.l10n.itemsCount(0))  // "No items"
Text(context.l10n.itemsCount(1))  // "1 item"
Text(context.l10n.itemsCount(5))  // "5 items"
```

### Date/Time Formatting

```dart
Text(context.l10n.formattedDate(DateTime.now()))
Text(context.l10n.daysAgo(3))  // "3 days ago"
```

### Language Selector

In AppBar:

```dart
AppBar(
  title: Text(context.l10n.appTitle),
  actions: [
    const LanguageSelector(),
  ],
)
```

In Settings Page:

```dart
ListView(
  children: [
    const LanguageSettingsTile(),
  ],
)
```

### Manual Language Switch

```dart
// Switch to Croatian
ref.read(localeProvider.notifier).setCroatian();

// Switch to English
ref.read(localeProvider.notifier).setEnglish();

// Custom locale
ref.read(localeProvider.notifier).setLocale(const Locale('de'));
```

## Adding New Translations

### 1. Add to Base ARB (English)

Edit `lib/l10n/arb/app_en.arb`:

```json
{
  "myNewKey": "My New Text",
  "@myNewKey": {
    "description": "Description for translators"
  }
}
```

### 2. Generate Code

```bash
flutter gen-l10n
```

### 3. Use in Code

```dart
Text(context.l10n.myNewKey)
```

### 4. Add to Other Languages

Edit `lib/l10n/arb/app_hr.arb` and add the same key with Croatian translation:

```json
{
  "myNewKey": "Moj Novi Tekst"
}
```

## Adding New Languages

### 1. Create New ARB File

Create `lib/l10n/arb/app_de.arb` (for German):

```json
{
  "@@locale": "de",
  "appTitle": "Meine App",
  "save": "Speichern",
  // ... all other keys
}
```

### 2. Add to Supported Locales

Update `main.dart`:

```dart
supportedLocales: const [
  Locale('en'),
  Locale('hr'),
  Locale('de'), // Add German
],
```

### 3. Add to Locale Provider

Update `locale_provider.dart`:

```dart
Future<void> setGerman() => setLocale(const Locale('de'));
```

### 4. Add to Language Selector

Update `language_selector_widget.dart`:

```dart
_buildLanguageMenuItem(
  locale: const Locale('de'),
  flag: '🇩🇪',
  name: 'Deutsch',
  isSelected: currentLocale.languageCode == 'de',
),
```

## Parameters & Formatting

### Simple Parameter

```json
{
  "greeting": "Hello, {name}!",
  "@greeting": {
    "placeholders": {
      "name": {
        "type": "String"
      }
    }
  }
}
```

Usage: `context.l10n.greeting('John')`

### Plural Forms

```json
{
  "items": "{count, plural, =0{No items} =1{One item} other{{count} items}}",
  "@items": {
    "placeholders": {
      "count": {
        "type": "int"
      }
    }
  }
}
```

Usage: `context.l10n.items(count)`

### Date Formatting

```json
{
  "updated": "Updated {date}",
  "@updated": {
    "placeholders": {
      "date": {
        "type": "DateTime",
        "format": "yMMMd"
      }
    }
  }
}
```

Usage: `context.l10n.updated(DateTime.now())`

### Price Formatting

```json
{
  "price": "{amount}",
  "@price": {
    "placeholders": {
      "amount": {
        "type": "double",
        "format": "currency",
        "optionalParameters": {
          "symbol": "$"
        }
      }
    }
  }
}
```

Usage: `context.l10n.price(19.99)`

## Best Practices

### ✅ DO

1. Use localization for ALL user-facing text
2. Add descriptions to help translators
3. Use parameters for dynamic content
4. Use plural forms for counts
5. Group related strings in ARB with comments
6. Test in all supported languages

### ❌ DON'T

1. Hardcode any UI strings
2. Concatenate strings for dynamic content
3. Skip descriptions for complex strings
4. Forget to add new keys to all language files
5. Use string interpolation for localized text

## Testing

### Test All Languages

```dart
testWidgets('Widget displays in Croatian', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('hr'),
      home: const MyWidget(),
    ),
  );
  
  expect(find.text('Spremi'), findsOneWidget); // Croatian for "Save"
});
```

### Check for Missing Keys

Create a test to ensure all languages have the same keys:

```dart
test('All locales have same keys', () {
  // Compare keys across all locales
  // Fail if any are missing
});
```

## Troubleshooting

**Problem:** Generated code not found

```bash
# Solution
flutter clean
flutter pub get
flutter gen-l10n
```

**Problem:** Locale not changing

```dart
// Solution: Make sure MaterialApp is wrapped with ConsumerWidget
class MyApp extends ConsumerWidget {
  // ... use ref.watch(localeProvider)
}
```

**Problem:** Missing translations

```
// Solution: Run code generation after adding keys
flutter gen-l10n
```

## Related Documentation

- [17_INTERNATIONALIZATION.md](../../17_INTERNATIONALIZATION.md) - Complete i18n guide
- [Flutter i18n](https://docs.flutter.dev/accessibility-and-localization/internationalization) - Official docs
- [ARB format](https://github.com/google/app-resource-bundle/wiki/ApplicationResourceBundleSpecification) - ARB specification

---

**Ready to use! Copy files and run `flutter gen-l10n` to start!** 🌍

