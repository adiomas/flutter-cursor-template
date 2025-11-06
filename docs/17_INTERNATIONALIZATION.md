# Internationalization (i18n) - Complete Guide

**CRITICAL:** Never hardcode strings in UI! Always use localization from day one.

## Philosophy

> **"Build multilingual from the start, not as an afterthought."**

### Why i18n from Day 1?

**Problems with hardcoded strings:**
- ❌ Impossible to add languages later without refactoring
- ❌ Mixed languages in codebase
- ❌ No centralized string management
- ❌ Typos spread across files
- ❌ Can't test translations

**Benefits of i18n:**
- ✅ Easy to add new languages
- ✅ Centralized string management
- ✅ Type-safe string access
- ✅ Supports plurals, dates, numbers
- ✅ RTL language support
- ✅ Professional app experience

## Setup (One-time)

### Step 1: Add Dependencies

```yaml
# pubspec.yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter
  intl: any  # Use 'any' for flutter_localizations compatibility

flutter:
  generate: true  # Enable code generation
```

### Step 2: Configure l10n

Create `l10n.yaml` in project root:

```yaml
# l10n.yaml
arb-dir: lib/l10n/arb
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
output-class: AppLocalizations
output-dir: lib/l10n/generated
synthetic-package: false
nullable-getter: false
```

### Step 3: Create ARB Directory Structure

```bash
mkdir -p lib/l10n/arb
```

### Step 4: Create Base ARB File

Create `lib/l10n/arb/app_en.arb` (English - base language):

```json
{
  "@@locale": "en",
  
  "@@_COMMON": "═══════════════════════════════════════",
  "appTitle": "My App",
  "@appTitle": {
    "description": "Application title"
  },
  
  "ok": "OK",
  "cancel": "Cancel",
  "save": "Save",
  "delete": "Delete",
  "edit": "Edit",
  "close": "Close",
  "back": "Back",
  "next": "Next",
  "previous": "Previous",
  "yes": "Yes",
  "no": "No",
  "done": "Done",
  "loading": "Loading...",
  "retry": "Retry",
  "refresh": "Refresh",
  
  "@@_VALIDATION": "═══════════════════════════════════════",
  "validationRequired": "This field is required",
  "@validationRequired": {
    "description": "Generic required field validation message"
  },
  
  "validationEmail": "Please enter a valid email",
  "validationPassword": "Password must be at least 8 characters",
  "validationPasswordMismatch": "Passwords do not match",
  
  "@@_ERRORS": "═══════════════════════════════════════",
  "errorGeneric": "Something went wrong",
  "@errorGeneric": {
    "description": "Generic error message"
  },
  
  "errorNetwork": "No internet connection",
  "errorTimeout": "Request timed out",
  "errorNotFound": "Resource not found",
  "errorUnauthorized": "Unauthorized access",
  "errorServerError": "Server error occurred",
  
  "@@_SUCCESS_MESSAGES": "═══════════════════════════════════════",
  "successSaved": "Saved successfully",
  "successDeleted": "Deleted successfully",
  "successUpdated": "Updated successfully",
  "successCreated": "Created successfully",
  
  "@@_EMPTY_STATES": "═══════════════════════════════════════",
  "emptyListTitle": "Nothing here yet",
  "@emptyListTitle": {
    "description": "Generic empty list title"
  },
  
  "emptyListMessage": "Tap + to add your first item",
  "@emptyListMessage": {
    "description": "Generic empty list message"
  },
  
  "@@_AUTH": "═══════════════════════════════════════",
  "authLogin": "Login",
  "authLogout": "Logout",
  "authRegister": "Register",
  "authEmail": "Email",
  "authPassword": "Password",
  "authConfirmPassword": "Confirm Password",
  "authForgotPassword": "Forgot Password?",
  "authDontHaveAccount": "Don't have an account?",
  "authAlreadyHaveAccount": "Already have an account?",
  
  "@@_DATES": "═══════════════════════════════════════",
  "dateToday": "Today",
  "dateYesterday": "Yesterday",
  "dateTomorrow": "Tomorrow",
  
  "@@_PLACEHOLDERS": "═══════════════════════════════════════",
  "placeholderSearch": "Search...",
  "placeholderEnterText": "Enter text",
  
  "@@_PARAMETERS": "═══════════════════════════════════════",
  "greetingHello": "Hello, {name}!",
  "@greetingHello": {
    "description": "Greeting with user name",
    "placeholders": {
      "name": {
        "type": "String",
        "example": "John"
      }
    }
  },
  
  "itemsCount": "{count, plural, =0{No items} =1{1 item} other{{count} items}}",
  "@itemsCount": {
    "description": "Count of items with pluralization",
    "placeholders": {
      "count": {
        "type": "int",
        "format": "compact"
      }
    }
  },
  
  "daysAgo": "{days, plural, =0{today} =1{yesterday} other{{days} days ago}}",
  "@daysAgo": {
    "description": "Days ago with pluralization",
    "placeholders": {
      "days": {
        "type": "int"
      }
    }
  },
  
  "formattedDate": "Updated on {date}",
  "@formattedDate": {
    "description": "Formatted date",
    "placeholders": {
      "date": {
        "type": "DateTime",
        "format": "yMMMd"
      }
    }
  },
  
  "formattedPrice": "Price: {price}",
  "@formattedPrice": {
    "description": "Formatted price",
    "placeholders": {
      "price": {
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

### Step 5: Add Croatian Translation (Optional)

Create `lib/l10n/arb/app_hr.arb`:

```json
{
  "@@locale": "hr",
  
  "appTitle": "Moja Aplikacija",
  
  "ok": "U redu",
  "cancel": "Odustani",
  "save": "Spremi",
  "delete": "Obriši",
  "edit": "Uredi",
  "close": "Zatvori",
  "back": "Natrag",
  "next": "Sljedeće",
  "previous": "Prethodno",
  "yes": "Da",
  "no": "Ne",
  "done": "Gotovo",
  "loading": "Učitavanje...",
  "retry": "Pokušaj ponovno",
  "refresh": "Osvježi",
  
  "validationRequired": "Ovo polje je obavezno",
  "validationEmail": "Unesite valjanu email adresu",
  "validationPassword": "Lozinka mora imati najmanje 8 znakova",
  "validationPasswordMismatch": "Lozinke se ne podudaraju",
  
  "errorGeneric": "Nešto je pošlo po krivu",
  "errorNetwork": "Nema internetske veze",
  "errorTimeout": "Isteklo vrijeme zahtjeva",
  "errorNotFound": "Resurs nije pronađen",
  "errorUnauthorized": "Neautoriziran pristup",
  "errorServerError": "Dogodila se greška na serveru",
  
  "successSaved": "Uspješno spremljeno",
  "successDeleted": "Uspješno obrisano",
  "successUpdated": "Uspješno ažurirano",
  "successCreated": "Uspješno stvoreno",
  
  "emptyListTitle": "Ovdje još nema ničega",
  "emptyListMessage": "Dotakni + za dodavanje prvog stavke",
  
  "authLogin": "Prijava",
  "authLogout": "Odjava",
  "authRegister": "Registracija",
  "authEmail": "Email",
  "authPassword": "Lozinka",
  "authConfirmPassword": "Potvrdi lozinku",
  "authForgotPassword": "Zaboravljena lozinka?",
  "authDontHaveAccount": "Nemaš račun?",
  "authAlreadyHaveAccount": "Već imaš račun?",
  
  "dateToday": "Danas",
  "dateYesterday": "Jučer",
  "dateTomorrow": "Sutra",
  
  "placeholderSearch": "Pretraži...",
  "placeholderEnterText": "Unesi tekst",
  
  "greetingHello": "Bok, {name}!",
  "itemsCount": "{count, plural, =0{Nema stavki} =1{1 stavka} few{{count} stavke} other{{count} stavki}}",
  "daysAgo": "{days, plural, =0{danas} =1{jučer} other{prije {days} dana}}",
  "formattedDate": "Ažurirano {date}",
  "formattedPrice": "Cijena: {price}"
}
```

### Step 6: Generate Localization Code

```bash
flutter gen-l10n
```

This generates `lib/l10n/generated/app_localizations.dart` and language files.

### Step 7: Configure MaterialApp

```dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/generated/app_localizations.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Localization delegates
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      
      // Supported locales
      supportedLocales: const [
        Locale('en'), // English
        Locale('hr'), // Croatian
        // Add more languages here
      ],
      
      // Optional: Set specific locale (otherwise uses device locale)
      // locale: const Locale('en'),
      
      // App title from localization
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      
      home: const HomePage(),
    );
  }
}
```

## Usage in Code

### Basic Text

```dart
// ❌ NEVER DO THIS
Text('Save')

// ✅ ALWAYS DO THIS
Text(AppLocalizations.of(context)!.save)
```

### Extension for Convenience

Create `lib/common/presentation/localization_extension.dart`:

```dart
import 'package:flutter/widgets.dart';
import '../../l10n/generated/app_localizations.dart';

extension LocalizationExtension on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}
```

Usage:

```dart
// Instead of:
Text(AppLocalizations.of(context)!.save)

// Use:
Text(context.l10n.save)
```

### Parameters

```dart
// Single parameter
Text(context.l10n.greetingHello('John'))

// Plural
Text(context.l10n.itemsCount(5))  // "5 items"
Text(context.l10n.itemsCount(1))  // "1 item"
Text(context.l10n.itemsCount(0))  // "No items"

// Date formatting
Text(context.l10n.formattedDate(DateTime.now()))

// Price formatting
Text(context.l10n.formattedPrice(19.99))

// Days ago
Text(context.l10n.daysAgo(3))  // "3 days ago"
```

### Widget Properties

```dart
// AppBar
AppBar(
  title: Text(context.l10n.appTitle),
)

// Button
ElevatedButton(
  onPressed: () {},
  child: Text(context.l10n.save),
)

// TextField
TextField(
  decoration: InputDecoration(
    labelText: context.l10n.authEmail,
    hintText: context.l10n.placeholderEnterText,
  ),
)

// Dialog
showDialog(
  context: context,
  builder: (context) => AlertDialog(
    title: Text(context.l10n.delete),
    content: Text('Are you sure?'),  // ❌ Hardcoded - add to ARB!
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: Text(context.l10n.cancel),
      ),
      TextButton(
        onPressed: () {},
        child: Text(context.l10n.delete),
      ),
    ],
  ),
)
```

## Language Switching

### State Management with Riverpod

Create `lib/common/domain/providers/locale_provider.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Locale provider
final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier();
});

class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier() : super(const Locale('en')) {
    _loadLocale();
  }
  
  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('language_code') ?? 'en';
    state = Locale(languageCode);
  }
  
  Future<void> setLocale(Locale locale) async {
    state = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', locale.languageCode);
  }
  
  Future<void> setEnglish() => setLocale(const Locale('en'));
  Future<void> setCroatian() => setLocale(const Locale('hr'));
}
```

### Update MaterialApp

```dart
class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('hr'),
      ],
      locale: locale,  // Use from provider
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      home: const HomePage(),
    );
  }
}
```

### Language Selector Widget

```dart
class LanguageSelector extends ConsumerWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);
    
    return PopupMenuButton<Locale>(
      initialValue: currentLocale,
      icon: const Icon(Icons.language),
      onSelected: (locale) {
        ref.read(localeProvider.notifier).setLocale(locale);
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: const Locale('en'),
          child: Row(
            children: [
              const Text('🇬🇧'),
              const SizedBox(width: 8),
              const Text('English'),
              if (currentLocale.languageCode == 'en')
                const Icon(Icons.check, size: 20),
            ],
          ),
        ),
        PopupMenuItem(
          value: const Locale('hr'),
          child: Row(
            children: [
              const Text('🇭🇷'),
              const SizedBox(width: 8),
              const Text('Hrvatski'),
              if (currentLocale.languageCode == 'hr')
                const Icon(Icons.check, size: 20),
            ],
          ),
        ),
      ],
    );
  }
}
```

## Best Practices

### ✅ DO

1. **Always use localization keys:**
   ```dart
   Text(context.l10n.save)  // ✅
   ```

2. **Group related strings in ARB:**
   ```json
   {
     "@@_AUTH": "═══════════════════",
     "authLogin": "Login",
     "authLogout": "Logout"
   }
   ```

3. **Add descriptions for translators:**
   ```json
   {
     "save": "Save",
     "@save": {
       "description": "Button label for saving changes"
     }
   }
   ```

4. **Use parameters for dynamic content:**
   ```dart
   Text(context.l10n.greetingHello(userName))
   ```

5. **Support pluralization:**
   ```json
   {
     "itemsCount": "{count, plural, =0{No items} =1{1 item} other{{count} items}}"
   }
   ```

6. **Format dates and numbers:**
   ```json
   {
     "formattedDate": "Updated on {date}",
     "@formattedDate": {
       "placeholders": {
         "date": {
           "type": "DateTime",
           "format": "yMMMd"
         }
       }
     }
   }
   ```

### ❌ DON'T

1. **Never hardcode strings:**
   ```dart
   Text('Save')  // ❌
   ```

2. **Don't concatenate strings:**
   ```dart
   Text('Hello, ' + userName + '!')  // ❌
   // Use parameters instead
   ```

3. **Don't use string interpolation for UI text:**
   ```dart
   Text('$count items')  // ❌
   // Use plural forms instead
   ```

4. **Don't skip descriptions:**
   ```json
   {
     "save": "Save"
     // ❌ Missing @save description
   }
   ```

## Testing Translations

### Check for Missing Keys

```dart
// test/l10n_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:your_app/l10n/generated/app_localizations.dart';

void main() {
  test('All locales have same keys', () {
    final enKeys = AppLocalizations(const Locale('en'));
    final hrKeys = AppLocalizations(const Locale('hr'));
    
    // Compare keys (manual or automated)
    // This ensures all translations are complete
  });
}
```

### Visual Testing

Use Flutter's localization testing:

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
  
  expect(find.text('Spremi'), findsOneWidget);  // Croatian for "Save"
});
```

## Advanced Features

### RTL Support

For Arabic, Hebrew, etc.:

```dart
MaterialApp(
  locale: const Locale('ar'),
  supportedLocales: const [
    Locale('en'),
    Locale('ar'),  // Right-to-left
  ],
  // RTL is handled automatically by Flutter
)
```

### Gender-based Translations

```json
{
  "welcomeMessage": "{gender, select, male{Welcome, Mr. {name}} female{Welcome, Ms. {name}} other{Welcome, {name}}}",
  "@welcomeMessage": {
    "placeholders": {
      "gender": {"type": "String"},
      "name": {"type": "String"}
    }
  }
}
```

Usage:

```dart
Text(context.l10n.welcomeMessage('male', 'John'))
```

### Context-specific Translations

```json
{
  "deleteButton": "Delete",
  "deleteConfirmation": "Are you sure you want to delete this item?",
  "deleteSuccess": "Item deleted successfully"
}
```

## Workflow for Adding New Strings

1. **Add key to `app_en.arb`:**
   ```json
   {
     "newFeatureTitle": "New Feature",
     "@newFeatureTitle": {
       "description": "Title for new feature"
     }
   }
   ```

2. **Run code generation:**
   ```bash
   flutter gen-l10n
   ```

3. **Use in code:**
   ```dart
   Text(context.l10n.newFeatureTitle)
   ```

4. **Add translations to other ARB files** (`app_hr.arb`, etc.)

5. **Test in all languages**

## Tools & Utilities

### VS Code Extension

Install "Flutter Intl" extension for easier ARB management.

### Automated Translation

Use services like Google Cloud Translation API:

```bash
# Example script
python scripts/translate_arb.py app_en.arb app_hr.arb --target hr
```

### ARB File Validation

```bash
# Check for missing keys
dart run scripts/check_arb.dart
```

## Checklist for i18n Compliance

- [ ] No hardcoded strings in any widget
- [ ] All strings in ARB files
- [ ] Descriptions added for translators
- [ ] Parameters used for dynamic content
- [ ] Pluralization implemented where needed
- [ ] Date/number formatting configured
- [ ] Language switching tested
- [ ] All supported languages have complete translations
- [ ] RTL support tested (if applicable)
- [ ] Screenshots taken for each language

## Quick Reference

```dart
// Common patterns

// Simple text
Text(context.l10n.save)

// With parameter
Text(context.l10n.greetingHello(userName))

// Plural
Text(context.l10n.itemsCount(count))

// Date
Text(context.l10n.formattedDate(DateTime.now()))

// Price
Text(context.l10n.formattedPrice(price))

// Button
ElevatedButton(
  onPressed: () {},
  child: Text(context.l10n.save),
)

// TextField
TextField(
  decoration: InputDecoration(
    labelText: context.l10n.authEmail,
  ),
)

// AppBar
AppBar(
  title: Text(context.l10n.appTitle),
)

// SnackBar
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(content: Text(context.l10n.successSaved)),
)
```

## Next Steps

- **Templates:** Update all templates in [templates/](templates/)
- **Checklist:** Review [i18n_checklist.md](../checklists/i18n_checklist.md)
- **Examples:** See [07_FEATURE_TEMPLATE.md](07_FEATURE_TEMPLATE.md) with i18n

---

**Remember:** Multilingual support is not optional. Build it from day one! 🌍
