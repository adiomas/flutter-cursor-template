# Dependencies Strategy

Elite approach to managing Flutter dependencies - choosing the right packages, maintaining versions, and minimizing technical debt.

## Core Philosophy

> **"Every dependency is a liability. Choose wisely, update regularly, minimize ruthlessly."**

### Key Principles

1. **Minimal Dependencies:** Every package adds maintenance burden
2. **Well-Maintained Only:** Active development and community support
3. **Performance First:** No bloated packages
4. **Tree-Shakeable:** Support for dead code elimination
5. **License Compatible:** Check license compatibility (MIT, BSD, Apache 2.0)
6. **Always Latest Stable:** Use automated tools to get latest versions

## 🤖 Automated Version Checking

**IMPORTANT:** Always use the latest stable versions when adding dependencies!

### Quick Start

```bash
# Check all recommended packages
python .cursor/tools/check_latest_versions.py

# Check specific package
python .cursor/tools/check_latest_versions.py package_name
```

### For AI Agents (Cursor)

When user requests a feature that needs a new dependency:

1. **Detect dependency need** from context
2. **Check latest version automatically:**
   ```bash
   python .cursor/tools/check_latest_versions.py [package_name]
   ```
3. **Verify package quality:**
   - Score ≥ 130: ✅ Excellent - use immediately
   - Score ≥ 100: ⚠️ Acceptable - mention in comment
   - Score < 100: ❌ Poor - suggest alternative or ask user
4. **Add to pubspec.yaml** with caret syntax:
   ```yaml
   dependencies:
     package_name: ^X.Y.Z  # Latest from automated check
   ```
5. **Run:** `flutter pub get`

### Why Automated Checking?

**Manual version checking problems:**
- ❌ Outdated versions in examples/tutorials
- ❌ Copy-paste from old projects
- ❌ Forgetting to check pub.dev
- ❌ Missing security updates

**Automated checking benefits:**
- ✅ Always get latest stable version
- ✅ See package quality scores
- ✅ Consistent across team
- ✅ Catches unmaintained packages
- ✅ Generated `pubspec.yaml` ready to copy

### Tool Features

The version checker provides:

```
🔍 Flutter Dependency Version Checker

Checking hooks_riverpod...
✓ hooks_riverpod: ^2.5.2
  Score: 140/140 | Popularity: 98%

━━━ PUBSPEC.YAML ━━━
dependencies:
  flutter:
    sdk: flutter

  hooks_riverpod: ^2.5.2
  ...

✓ Saved to .cursor/tools/latest_versions.yaml
✓ Saved report to .cursor/tools/dependency_report.md
```

**Output files:**
- `.cursor/tools/latest_versions.yaml` - Ready to copy versions
- `.cursor/tools/dependency_report.md` - Detailed markdown report

### Integration in Workflow

**Before adding any package:**

```bash
# 1. Check version
python .cursor/tools/check_latest_versions.py dio

# 2. Review output (score, popularity)
✓ dio: ^5.6.0
  Score: 140/140 | Popularity: 95%

# 3. Add to pubspec.yaml
dependencies:
  dio: ^5.6.0

# 4. Get package
flutter pub get
```

**Monthly maintenance:**

```bash
# Check all packages for updates
python .cursor/tools/check_latest_versions.py

# Compare with current pubspec.yaml
flutter pub outdated

# Update if needed
flutter pub upgrade
```

For full documentation, see [`.cursor/tools/README.md`](../.cursor/tools/README.md).

## Package Evaluation Checklist

Before adding any dependency, evaluate:

### Critical Factors

- [ ] **Pub.dev Score:** Minimum 130/140 (>90%)
- [ ] **Popularity:** >1000 pub points or >100k downloads/month
- [ ] **Maintenance:** Updated in last 3 months
- [ ] **Issues:** Active issue resolution (< 50 open issues)
- [ ] **Tests:** Comprehensive test coverage
- [ ] **Documentation:** Clear, complete documentation
- [ ] **Flutter Version:** Supports latest stable Flutter
- [ ] **Null Safety:** Full null safety support
- [ ] **License:** Compatible with your app (check LICENSE file)
- [ ] **Size Impact:** Check bundle size increase

### Decision Matrix

```
│ Factor          │ Weight │ Min Score │
├─────────────────┼────────┼───────────┤
│ Pub Score       │  25%   │   130     │
│ Maintenance     │  20%   │  Recent   │
│ Documentation   │  15%   │   Good    │
│ Community       │  15%   │  Active   │
│ Performance     │  15%   │  No lag   │
│ Size Impact     │  10%   │  < 1MB    │
```

**Minimum acceptable:** 80% combined score

## Recommended Dependencies

### Essential Core (Always Include)

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # State Management (Choose ONE)
  hooks_riverpod: ^2.5.2      # RECOMMENDED
  flutter_hooks: ^0.20.5      # Complements Riverpod
  
  # Navigation
  go_router: ^14.2.3          # RECOMMENDED for declarative routing
  
  # Functional Programming
  either_dart: ^1.0.0         # Error handling with Either
  equatable: ^2.0.5           # Value equality
  
  # Utilities
  intl: ^0.19.0              # Internationalization
  flutter_localizations:
    sdk: flutter
```

**Why these?**
- **Riverpod:** Most robust state management, great DevTools
- **go_router:** Official routing solution, excellent deep linking
- **either_dart:** Elegant error handling
- **equatable:** Simplifies value comparisons

### Backend & Data

```yaml
dependencies:
  # Backend-as-a-Service
  supabase_flutter: ^2.6.0    # PostgreSQL, Auth, Storage
  
  # HTTP Client
  dio: ^5.6.0                 # Feature-rich HTTP client
  
  # JSON Serialization
  json_annotation: ^4.9.0
  
  # Code Generation
  build_runner: ^2.4.12       # dev_dependencies
  json_serializable: ^6.8.0   # dev_dependencies
```

**Alternatives:**
- **Firebase:** `firebase_core`, `cloud_firestore`
- **REST API:** `retrofit` (with `dio`)
- **GraphQL:** `graphql_flutter`

### UI & Theming

```yaml
dependencies:
  # SVG Support
  flutter_svg: ^2.0.10
  
  # Custom Fonts
  google_fonts: ^6.2.1
  
  # Animations
  flutter_animate: ^3.0.0     # Declarative animations
  
  # Responsive Design
  flutter_screenutil: ^5.9.3  # Screen adaptation
  
  # Icons
  cupertino_icons: ^1.0.8
```

### Forms & Validation

```yaml
dependencies:
  flutter_form_builder: ^9.4.1
  form_builder_validators: ^11.0.0
```

**Alternative:** Manual form management with `TextEditingController`

### Storage

```yaml
dependencies:
  shared_preferences: ^2.2.2  # Simple key-value storage
  
  # For complex data
  # hive: ^2.2.3              # NoSQL database
  # drift: ^2.16.0            # SQLite wrapper
```

### Logging & Debugging

```yaml
dependencies:
  loggy: ^2.0.3
  flutter_loggy: ^2.0.3
  flutter_loggy_dio: ^3.1.0   # Dio integration

dev_dependencies:
  flutter_lints: ^4.0.0        # Official lints
  custom_lint: ^0.6.4
  riverpod_lint: ^2.3.10       # Riverpod-specific lints
```

### Testing

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  mocktail: ^1.0.4            # Mocking library
  integration_test:
    sdk: flutter
```

### Platform-Specific

```yaml
dependencies:
  # Permissions
  permission_handler: ^11.3.1
  
  # File Picker
  file_picker: ^8.1.3
  
  # Image Picker
  image_picker: ^1.1.2
  
  # URL Launcher
  url_launcher: ^6.3.1
  
  # Share
  share_plus: ^10.1.2
  
  # Path
  path: ^1.9.0
```

## Packages to AVOID

### ❌ Red Flags

**Unmaintained Packages:**
- Last update > 12 months ago
- Multiple unresolved critical issues
- No Flutter 3.x support

**Performance Killers:**
- Packages that cause jank (check performance tab)
- Large bundle size (>5MB for UI library)
- Synchronous file I/O

**Deprecated Packages:**
```yaml
# DON'T USE - Deprecated
provider: ^6.0.0              # Use Riverpod instead
get: ^4.6.0                   # Promotes bad patterns
```

### Alternatives to Popular but Problematic

```yaml
# Instead of 'provider' → Use 'riverpod'
hooks_riverpod: ^2.5.2

# Instead of 'get' → Use 'go_router'
go_router: ^14.2.3

# Instead of 'cached_network_image' → Use built-in with custom cache
flutter_cache_manager: ^3.4.1
```

## Dependency Management Best Practices

### Version Constraints

```yaml
# ✅ GOOD: Caret syntax (allows minor and patch updates)
dependencies:
  dio: ^5.6.0              # Allows >=5.6.0 <6.0.0
  
# ❌ BAD: Exact version (no updates)
dependencies:
  dio: 5.6.0               # Locked to exactly 5.6.0
  
# ⚠️ CAUTION: Loose constraint (might break)
dependencies:
  dio: '>=5.0.0 <7.0.0'    # Too permissive
```

### Updating Dependencies

```bash
# Check for outdated packages
flutter pub outdated

# Safe update (respects constraints)
flutter pub upgrade

# Update specific package
flutter pub upgrade dio

# Update to latest (including major versions)
flutter pub upgrade --major-versions
```

### Update Cadence

**Monthly:**
- Check `flutter pub outdated`
- Update patch versions automatically
- Review minor version updates

**Quarterly:**
- Review all dependencies
- Consider major version updates
- Remove unused dependencies

**Before Release:**
- Update all dependencies to latest stable
- Run full test suite
- Check for breaking changes

## Dependency Audit

### Security Audit

```bash
# Check for known vulnerabilities (future feature)
dart pub audit

# Manual check
# Review each dependency's security advisories on GitHub
```

### Size Audit

```bash
# Build release APK
flutter build apk --analyze-size

# Build release iOS
flutter build ios --analyze-size

# Results show size impact per package
```

### Performance Audit

```dart
// Track app startup time
void main() {
  final stopwatch = Stopwatch()..start();
  
  runApp(MyApp());
  
  WidgetsBinding.instance.addPostFrameCallback((_) {
    debugPrint('App startup time: ${stopwatch.elapsedMilliseconds}ms');
  });
}
```

**Target:** < 2 seconds cold start on mid-range devices

## Architecture-Specific Dependencies

### Using q_architecture Package

```yaml
dependencies:
  q_architecture: ^1.0.1
```

**Provides:**
- `BaseNotifier<T>` for state management
- `BaseState<T>` with Loading/Data/Error
- `EitherFailureOr<T>` type alias
- `Failure` class for error handling

**Usage:**

```dart
import 'package:q_architecture/q_architecture.dart';

// Notifier
class UserNotifier extends BaseNotifier<User> {
  @override
  void prepareForBuild() {
    _repository = ref.watch(userRepositoryProvider);
  }
  
  Future<void> loadUser() async {
    state = const BaseLoading();
    final result = await _repository.getUser();
    state = result.fold(BaseError.new, BaseData.new);
  }
}

// Repository
abstract interface class UserRepository {
  EitherFailureOr<User> getUser();
}
```

## Custom Package Development

### When to Create Custom Package

Create internal package when:
- **Reusability:** Used across 3+ projects
- **Separation:** Complex, self-contained functionality
- **Testing:** Easier to test in isolation
- **Team:** Multiple teams need same functionality

### Package Structure

```
packages/
└── my_package/
    ├── lib/
    │   ├── src/          # Private implementation
    │   └── my_package.dart  # Public API
    ├── test/
    ├── pubspec.yaml
    ├── README.md
    └── CHANGELOG.md
```

### Publishing to pub.dev

```yaml
# pubspec.yaml
name: my_package
version: 1.0.0
description: Clear, concise description
repository: https://github.com/username/my_package
issue_tracker: https://github.com/username/my_package/issues

environment:
  sdk: '>=3.2.0 <4.0.0'
  flutter: '>=3.16.0'
```

```bash
# Dry run
dart pub publish --dry-run

# Publish
dart pub publish
```

## Dependency Lock File

### Understanding pubspec.lock

```yaml
# pubspec.lock (generated, commit to repo)
packages:
  dio:
    dependency: "direct main"
    description:
      name: dio
      url: "https://pub.dartlang.org"
    source: hosted
    version: "5.6.0"
```

**Best Practice:**
- ✅ Commit `pubspec.lock` to repository
- ✅ Ensures consistent builds across team
- ✅ Prevents unexpected updates

## Troubleshooting

### Dependency Conflicts

```bash
# Error: Version conflict between packages
# Solution 1: Update all packages
flutter pub upgrade

# Solution 2: Override specific version
dependency_overrides:
  package_name: ^1.0.0

# Solution 3: Contact package maintainers
```

### Build Failures After Update

```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs

# If still failing, check:
# 1. Breaking changes in CHANGELOG
# 2. Migration guides
# 3. GitHub issues
```

### Slow Pub Get

```bash
# Clear pub cache
dart pub cache clean

# Use pub cache hosted URL
flutter pub get --trace  # See where it's slow
```

## Migration Strategy

### Major Version Updates

1. **Read CHANGELOG:** Identify breaking changes
2. **Check Migration Guide:** Follow official guide
3. **Update Tests First:** Ensure tests pass
4. **Update Incrementally:** One major update at a time
5. **Test Thoroughly:** Run full test suite
6. **Monitor:** Watch for issues post-deployment

### Flutter SDK Updates

```bash
# Upgrade Flutter SDK
flutter upgrade

# Check compatibility
flutter doctor
flutter pub outdated

# Update dependencies for new SDK
flutter pub upgrade
```

## Dependency Documentation

### Internal Documentation

**DEPENDENCIES.md:**

```markdown
# Project Dependencies

## State Management
- **riverpod** (^2.5.2): Primary state management
  - Why: Best DevTools, compile-time safety
  - Migration: None planned

## Backend
- **supabase_flutter** (^2.6.0): Backend-as-a-Service
  - Why: PostgreSQL, Auth, Storage in one
  - Note: Check for breaking changes in v3.0

## UI
- **google_fonts** (^6.2.1): Custom fonts
  - Why: Easy Google Fonts integration
  - Alternative: Bundle fonts locally

[Document all major dependencies]
```

## Checklist

Before adding any dependency:

- [ ] Evaluated using decision matrix (>80% score)
- [ ] Checked pub.dev score (>130)
- [ ] Verified maintenance status (updated in 3 months)
- [ ] Reviewed documentation quality
- [ ] Checked license compatibility
- [ ] Tested bundle size impact
- [ ] Added to DEPENDENCIES.md
- [ ] Documented why this package was chosen

## Quick Reference

### Commands

```bash
# Add dependency
flutter pub add package_name

# Add dev dependency
flutter pub add --dev package_name

# Remove dependency
flutter pub remove package_name

# Outdated check
flutter pub outdated

# Upgrade
flutter pub upgrade

# Get packages
flutter pub get

# Clean cache
flutter pub cache clean
```

### Version Syntax

```yaml
# Caret (recommended)
package: ^1.2.3    # >=1.2.3 <2.0.0

# Range
package: '>=1.0.0 <2.0.0'

# Exact
package: 1.2.3

# Git repository
package:
  git:
    url: https://github.com/user/package.git
    ref: main

# Path (local development)
package:
  path: ../local_package
```

## CI/CD Integration for Version Checking

Automate dependency checks in your CI/CD pipeline:

### GitHub Actions Example

Create `.github/workflows/check_dependencies.yml`:

```yaml
name: Check Dependencies

on:
  schedule:
    - cron: '0 0 * * 1'  # Weekly on Monday
  pull_request:
    paths:
      - 'pubspec.yaml'
  workflow_dispatch:

jobs:
  check-versions:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - uses: actions/setup-python@v4
        with:
          python-version: '3.x'
      
      - name: Check dependency versions
        run: python .cursor/tools/check_latest_versions.py
      
      - name: Upload report
        uses: actions/upload-artifact@v3
        with:
          name: dependency-report
          path: .cursor/tools/dependency_report.md
      
      - name: Check for low scores
        run: |
          if grep -q "❌ Low Score" .cursor/tools/dependency_report.md; then
            echo "::warning::Some dependencies have low pub scores"
          fi
```

### Pre-commit Hook

Create `.git/hooks/pre-commit`:

```bash
#!/bin/bash
# Check if pubspec.yaml changed
if git diff --cached --name-only | grep -q "pubspec.yaml"; then
    echo "Checking dependency versions..."
    python .cursor/tools/check_latest_versions.py
    
    # Optionally fail if low scores
    if grep -q "❌" .cursor/tools/dependency_report.md; then
        echo "⚠️  Warning: Some dependencies have issues"
        echo "Review .cursor/tools/dependency_report.md"
    fi
fi
```

### Automated Update PR

Create `.github/workflows/update_dependencies.yml`:

```yaml
name: Update Dependencies

on:
  schedule:
    - cron: '0 0 1 * *'  # Monthly
  workflow_dispatch:

jobs:
  update:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: 'stable'
      
      - name: Update dependencies
        run: |
          flutter pub upgrade --major-versions
          python .cursor/tools/check_latest_versions.py
      
      - name: Create Pull Request
        uses: peter-evans/create-pull-request@v5
        with:
          commit-message: 'chore: update dependencies'
          title: 'Update Flutter Dependencies'
          body: |
            Automated dependency update
            
            See dependency report in artifacts
          branch: automated/dependency-update
```

## Best Practices Summary

### ✅ DO

- ✅ Use automated version checker before adding packages
- ✅ Prefer packages with score ≥ 130
- ✅ Use caret (`^`) syntax for versions
- ✅ Commit `pubspec.lock`
- ✅ Update monthly
- ✅ Read CHANGELOGs before major updates
- ✅ Test after updates
- ✅ Document why each package was chosen

### ❌ DON'T

- ❌ Use exact versions (locks updates)
- ❌ Add packages without checking score
- ❌ Skip testing after updates
- ❌ Ignore deprecation warnings
- ❌ Copy versions from old tutorials
- ❌ Add packages "just in case"
- ❌ Use unmaintained packages

## Quick Commands Reference

```bash
# Check latest versions
python .cursor/tools/check_latest_versions.py [package]

# Add dependency (after checking version)
flutter pub add package_name

# Check for outdated packages
flutter pub outdated

# Update packages (respects constraints)
flutter pub upgrade

# Update to latest (including major)
flutter pub upgrade --major-versions

# Clean and rebuild
flutter clean && flutter pub get

# Analyze dependency tree
flutter pub deps

# Check for unused dependencies
dart pub deps --no-dev | grep -v "^|"
```

## Next Steps

- **Setup Environment:** Configure in [03_ENVIRONMENT_CONFIG.md](03_ENVIRONMENT_CONFIG.md)
- **Architecture:** Understand in [04_CLEAN_ARCHITECTURE.md](04_CLEAN_ARCHITECTURE.md)
- **State Management:** Implement in [05_STATE_MANAGEMENT.md](05_STATE_MANAGEMENT.md)
- **Version Checker Tool:** See [`.cursor/tools/README.md`](../.cursor/tools/README.md)

---

**Remember:** Every dependency is a promise to maintain. Use automation to choose wisely! 🤖

