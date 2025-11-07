# Cursor Tools for Flutter Development

Automated tools for maintaining Flutter projects with latest best practices.

## 📦 Dependency Version Checker

Automatically checks pub.dev for the latest stable versions of your Flutter dependencies.

### Usage

**Check all recommended packages:**

```bash
# Using Python (recommended - includes metrics)
python .cursor/tools/check_latest_versions.py

# Using Bash
bash .cursor/tools/check_latest_versions.sh
```

**Check specific package:**

```bash
python .cursor/tools/check_latest_versions.py riverpod
bash .cursor/tools/check_latest_versions.sh riverpod
```

### Features

✅ Checks latest stable versions from pub.dev  
✅ Displays pub.dev scores (grantedPoints/maxPoints)  
✅ Shows popularity metrics  
✅ Warns about low-scored packages  
✅ Generates ready-to-use `pubspec.yaml` snippet  
✅ Creates markdown report with status indicators  
✅ Saves outputs to files for easy reference

### Output Files

After running the Python version, you'll get:

- **`.cursor/tools/latest_versions.yaml`** - Ready to copy versions
- **`.cursor/tools/dependency_report.md`** - Detailed report with scores

### Example Output

```
🔍 Flutter Dependency Version Checker

Checking all recommended packages...

Checking hooks_riverpod...
✓ hooks_riverpod: ^2.5.2
  Score: 140/140 | Popularity: 98%

Checking flutter_hooks...
✓ flutter_hooks: ^0.20.5
  Score: 130/140 | Popularity: 95%

━━━ PUBSPEC.YAML ━━━
dependencies:
  flutter:
    sdk: flutter

  hooks_riverpod: ^2.5.2
  flutter_hooks: ^0.20.5
  go_router: ^14.2.3
  ...
```

### Integration with Cursor AI

When AI needs to add a dependency, it should:

1. Run version checker: `python .cursor/tools/check_latest_versions.py [package_name]`
2. Use the returned version in `pubspec.yaml`
3. Verify package score is acceptable (>130 for production)

### Recommended Packages

The tool checks these packages by default:

**Dependencies:**
- State Management: `hooks_riverpod`, `flutter_hooks`
- Navigation: `go_router`
- Utilities: `either_dart`, `equatable`, `intl`
- Backend: `supabase_flutter`, `dio`
- UI: `flutter_svg`, `google_fonts`, `flutter_animate`
- Storage: `shared_preferences`
- Logging: `loggy`, `flutter_loggy`
- Platform: `permission_handler`, `file_picker`, `image_picker`, `url_launcher`, `share_plus`

**Dev Dependencies:**
- Code Generation: `build_runner`, `json_serializable`
- Linting: `flutter_lints`, `custom_lint`, `riverpod_lint`
- Testing: `mocktail`

### Customization

To check additional packages, edit the `DEFAULT_PACKAGES` dict in `check_latest_versions.py`:

```python
DEFAULT_PACKAGES = {
    'dependencies': [
        'your_package_here',
        # ... other packages
    ],
    'dev_dependencies': [
        # ... dev packages
    ]
}
```

## 🔄 Workflow for Adding New Dependencies

### For AI Agent (Cursor):

1. **Detect dependency need** from user request
2. **Check latest version:**
   ```bash
   python .cursor/tools/check_latest_versions.py [package_name]
   ```
3. **Verify package quality:**
   - Score ≥ 130 (excellent)
   - Score ≥ 100 (acceptable with review)
   - Score < 100 (requires justification)
4. **Add to pubspec.yaml** with caret syntax:
   ```yaml
   dependencies:
     package_name: ^X.Y.Z  # Latest from checker
   ```
5. **Run pub get:**
   ```bash
   flutter pub get
   ```

### For Developers:

1. Before adding any dependency, run the checker
2. Review the package score and popularity
3. Read package documentation on pub.dev
4. Consider bundle size impact
5. Add with latest stable version

## 📅 Maintenance Schedule

**Monthly:** Run checker to see available updates

```bash
python .cursor/tools/check_latest_versions.py
```

**Before Major Release:** Update all dependencies

```bash
flutter pub outdated
flutter pub upgrade --major-versions
# Then run checker to verify versions
```

**After Flutter SDK Update:** Check compatibility

```bash
flutter upgrade
python .cursor/tools/check_latest_versions.py
flutter pub upgrade
```

## 🚀 CI/CD Integration

Add to your CI pipeline to check for outdated dependencies:

```yaml
# .github/workflows/check_deps.yml
name: Check Dependencies
on:
  schedule:
    - cron: '0 0 * * 1'  # Weekly on Monday
  workflow_dispatch:

jobs:
  check:
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
```

## 🛠️ Troubleshooting

**Error: "Could not find latest version"**
- Check internet connection
- Verify package name is correct on pub.dev
- Package might be unpublished or deprecated

**Error: "Connection timeout"**
- pub.dev might be down (check status.dart.dev)
- Increase timeout in script
- Try again later

**Low Package Score Warning**
- Review package on pub.dev
- Check maintenance status
- Consider alternatives
- Contact package maintainer

## 📝 Notes

- Always use caret (`^`) syntax for version constraints
- Commit `pubspec.lock` to ensure consistent builds
- Review CHANGELOG before updating major versions
- Test thoroughly after dependency updates

## 🔗 Related Documentation

- [02_DEPENDENCIES_STRATEGY.md](../../docs/02_DEPENDENCIES_STRATEGY.md) - Full dependency management guide
- [pub.dev](https://pub.dev) - Dart package repository
- [Dart pub versioning](https://dart.dev/tools/pub/versioning) - Version constraint syntax

---

**Remember:** Every dependency is a promise to maintain. Choose wisely! 🎯

