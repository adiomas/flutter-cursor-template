# Internationalization (i18n) Checklist

Use this checklist to ensure complete localization compliance in your Flutter project.

## 📋 Initial Setup

### Configuration

- [ ] Created `l10n.yaml` in project root
- [ ] Added `flutter_localizations` to dependencies
- [ ] Added `intl: any` to dependencies  
- [ ] Added `flutter: generate: true` to pubspec.yaml
- [ ] Created `lib/l10n/arb/` directory
- [ ] Created base ARB file (`app_en.arb`)
- [ ] Ran `flutter gen-l10n` successfully

### MaterialApp Configuration

- [ ] Added `AppLocalizations.delegate` to `localizationsDelegates`
- [ ] Added `GlobalMaterialLocalizations.delegate`
- [ ] Added `GlobalWidgetsLocalizations.delegate`
- [ ] Added `GlobalCupertinoLocalizations.delegate`
- [ ] Defined `supportedLocales`
- [ ] Configured `onGenerateTitle` with localized app title
- [ ] Optional: Configured `locale` provider for language switching

### Helper Files

- [ ] Created `LocalizationExtension` (context.l10n shortcut)
- [ ] Created `LocaleProvider` (if using language switching)
- [ ] Created language selector widget (if needed)
- [ ] All helpers imported and configured

## 🌍 Translation Files

### Base Language (English)

- [ ] All UI strings added to `app_en.arb`
- [ ] Every key has `@keyName` description
- [ ] Complex strings have placeholder definitions
- [ ] Plural forms defined where needed
- [ ] Date/time/number formatting configured
- [ ] Strings grouped logically with comments
- [ ] No hardcoded strings remain in code

### Additional Languages

For each supported language:

- [ ] Created ARB file (e.g., `app_hr.arb`)
- [ ] All keys from English translated
- [ ] No missing keys
- [ ] Plural forms adjusted for language
- [ ] Date/time formats appropriate for locale
- [ ] Run `flutter gen-l10n` after changes

## 💻 Code Compliance

### No Hardcoded Strings

Check ALL files for hardcoded strings:

- [ ] Pages - no hardcoded text
- [ ] Widgets - no hardcoded text
- [ ] Dialogs - no hardcoded text
- [ ] Snackbars - no hardcoded text
- [ ] Error messages - no hardcoded text
- [ ] Success messages - no hardcoded text
- [ ] Form labels - no hardcoded text
- [ ] Button text - no hardcoded text
- [ ] AppBar titles - no hardcoded text
- [ ] Navigation labels - no hardcoded text

### Proper Usage

- [ ] All strings use `context.l10n.keyName`
- [ ] Parameters passed correctly (`context.l10n.greeting(name)`)
- [ ] Plural forms used for counts (`context.l10n.itemsCount(count)`)
- [ ] Date formatting uses l10n (`context.l10n.formattedDate(date)`)
- [ ] No string concatenation for UI text
- [ ] No string interpolation (`"$variable text"`)

### Import Statements

- [ ] `localization_extension.dart` imported where needed
- [ ] No direct `AppLocalizations.of(context)!` calls (use extension)

## 🎨 UI Components

### Common Widgets

- [ ] Buttons use localized text
- [ ] TextFields use localized labels/hints
- [ ] AppBars use localized titles
- [ ] TabBars use localized tab names
- [ ] BottomNavigationBar uses localized labels
- [ ] Drawers use localized menu items

### Dialogs & Bottom Sheets

- [ ] Dialog titles localized
- [ ] Dialog content localized
- [ ] Action buttons localized
- [ ] Confirmation messages localized
- [ ] BottomSheet content localized

### Messages

- [ ] Error messages localized
- [ ] Success messages localized
- [ ] Info messages localized
- [ ] Loading messages localized
- [ ] Empty state messages localized

## 🔧 Features

### Feature-Specific Strings

For each feature:

- [ ] Feature name in ARB
- [ ] All page titles in ARB
- [ ] All button labels in ARB
- [ ] All form fields in ARB
- [ ] All validation messages in ARB
- [ ] All error messages in ARB
- [ ] All empty states in ARB
- [ ] All success messages in ARB

### Authentication

- [ ] Login/Register screens localized
- [ ] Email/password labels localized
- [ ] Auth error messages localized
- [ ] "Forgot password" localized
- [ ] Social login buttons localized

### CRUD Operations

- [ ] List titles localized
- [ ] Create/edit page titles localized
- [ ] Delete confirmations localized
- [ ] Success/error messages localized
- [ ] Empty list messages localized

## 🧪 Testing

### Manual Testing

For each supported language:

- [ ] Switch to language in app
- [ ] Navigate through all screens
- [ ] Trigger all dialogs
- [ ] Test error scenarios
- [ ] Test empty states
- [ ] Test success messages
- [ ] Check date/time formatting
- [ ] Check number/currency formatting
- [ ] Verify plural forms work correctly

### Automated Testing

- [ ] Widget tests use localization
- [ ] Tests for each language written
- [ ] Tests verify correct translations display
- [ ] Tests check for missing keys

### Visual Review

- [ ] Text doesn't overflow in any language
- [ ] UI accommodates longer translations
- [ ] RTL languages tested (if applicable)
- [ ] Text alignment correct for all languages
- [ ] Font sizes appropriate

## 📱 Platform-Specific

### iOS

- [ ] `CFBundleLocalizations` in `Info.plist` (if needed)
- [ ] App name localized in Xcode
- [ ] Launch screen text localized (if any)

### Android

- [ ] App name in `strings.xml` per language
- [ ] `localeConfig` in `AndroidManifest.xml` (if needed)

## 📚 Documentation

### Code Comments

- [ ] Added comments explaining complex translations
- [ ] Documented why certain strings use parameters
- [ ] Notes for translators added to descriptions

### Team Documentation

- [ ] README mentions i18n setup
- [ ] Process for adding new strings documented
- [ ] Process for adding new languages documented
- [ ] Translation workflow documented

### ARB File Organization

- [ ] Strings grouped by feature/category
- [ ] Section headers used (e.g., `@@_AUTH`)
- [ ] Common strings at top
- [ ] Feature-specific strings grouped

## 🚀 Pre-Release

### Before Merging/Deploying

- [ ] All ARB files have same keys
- [ ] No hardcoded strings in entire codebase
- [ ] All supported languages tested
- [ ] Screenshots taken for each language
- [ ] Store listings translated (App Store/Play Store)
- [ ] Privacy policy translated
- [ ] Terms of service translated

### CI/CD

- [ ] Build succeeds with all locales
- [ ] No missing translation warnings
- [ ] Localization tests pass
- [ ] Generated files committed (if needed)

## 🔍 Code Review Checklist

For reviewers:

- [ ] No new hardcoded strings introduced
- [ ] New strings added to all ARB files
- [ ] Descriptions provided for new strings
- [ ] Parameters used correctly
- [ ] Plural forms implemented where needed
- [ ] Date/time formatting follows l10n pattern
- [ ] No string concatenation for UI
- [ ] No commented-out hardcoded strings

## 📊 Quality Metrics

### Coverage

- [ ] 100% of UI strings localized
- [ ] All supported languages have complete translations
- [ ] No "TODO" or placeholder translations

### Maintainability

- [ ] ARB files well-organized
- [ ] Naming convention consistent
- [ ] Related strings grouped together
- [ ] Descriptions helpful for translators

## 🛠️ Common Issues Checklist

### Troubleshooting

- [ ] If build fails: Run `flutter gen-l10n`
- [ ] If translations not showing: Restart app
- [ ] If new keys not available: Run `flutter pub get`
- [ ] If wrong language: Check `supportedLocales`
- [ ] If text overflows: Adjust UI or shorten translation

### Edge Cases

- [ ] Empty strings handled
- [ ] Null values handled
- [ ] Very long translations tested
- [ ] Very short translations tested
- [ ] Special characters tested
- [ ] Emojis in translations tested (if used)

## 📋 Feature Addition Workflow

When adding a new feature:

1. [ ] Add all feature strings to `app_en.arb`
2. [ ] Add descriptions for each string
3. [ ] Run `flutter gen-l10n`
4. [ ] Implement feature using `context.l10n`
5. [ ] Add translations to all other ARB files
6. [ ] Run `flutter gen-l10n` again
7. [ ] Test in all languages
8. [ ] Create PR with i18n compliance note

## ✅ Final Verification

Before marking i18n complete:

- [ ] Search codebase for `Text('` - should find NO hardcoded strings
- [ ] Search for `"` in UI files - verify all are ARB keys
- [ ] Build app in each language and manually test
- [ ] Run all automated tests
- [ ] Get translation review (if available)
- [ ] Update language selector with new languages
- [ ] Document any language-specific considerations

---

**Total Checklist Items:** ~150

**Perfect i18n Compliance:** All items checked ✅

**Good Enough:** >90% checked

**Needs Work:** <90% checked

---

## Quick Commands

```bash
# Generate localization code
flutter gen-l10n

# Check for hardcoded strings (rough check)
grep -r "Text('" lib/ | grep -v ".l10n"

# Count translations
cat lib/l10n/arb/app_en.arb | grep '":' | wc -l

# Find missing translations
diff <(grep '"[^@]' app_en.arb) <(grep '"[^@]' app_hr.arb)
```

---

**Remember:** i18n is not optional. Build it from day one! 🌍

