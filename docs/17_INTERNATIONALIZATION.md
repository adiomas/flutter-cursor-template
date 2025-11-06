# Internationalization (i18n)

Support multiple languages with Flutter's built-in localization.

## Setup

```yaml
dependencies:
  flutter_localizations:
    sdk: flutter
  intl: ^0.19.0

dev_dependencies:
  intl_utils: ^2.8.7

flutter:
  generate: true

flutter_intl:
  enabled: true
  class_name: S
  main_locale: en
  arb_dir: lib/l10n
  output_dir: lib/generated
```

## ARB Files

**lib/l10n/intl_en.arb:**
```json
{
  "@@locale": "en",
  "appTitle": "My App",
  "welcome": "Welcome",
  "loginButton": "Sign In",
  "emailLabel": "Email",
  "passwordLabel": "Password",
  "helloUser": "Hello, {name}!",
  "@helloUser": {
    "placeholders": {
      "name": {
        "type": "String"
      }
    }
  }
}
```

**lib/l10n/intl_hr.arb:**
```json
{
  "@@locale": "hr",
  "appTitle": "Moja Aplikacija",
  "welcome": "Dobrodošli",
  "loginButton": "Prijava",
  "emailLabel": "Email",
  "passwordLabel": "Lozinka",
  "helloUser": "Bok, {name}!"
}
```

## Usage

```dart
import 'package:flutter_localizations/flutter_localizations.dart';
import 'generated/l10n.dart';

MaterialApp(
  localizationsDelegates: const [
    S.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  supportedLocales: S.delegate.supportedLocales,
  locale: const Locale('hr'),
  home: MyHomePage(),
)

// In widgets
Text(S.of(context).welcome)
Text(S.of(context).helloUser('John'))
```

## Language Switching

```dart
final languageProvider = StateProvider<Locale>((ref) => const Locale('en'));

// Switch language
ref.read(languageProvider.notifier).state = const Locale('hr');

// Use in app
locale: ref.watch(languageProvider),
```

## Generate Translations

```bash
flutter pub run intl_utils:generate
```

---

**Your app is now multilingual!**

