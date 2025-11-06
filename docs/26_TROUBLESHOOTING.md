# Troubleshooting

Common issues and solutions in Flutter development.

## Bug Investigation Protocol

For systematic debugging approaches, see the [Bug Investigation & Fixing Protocol](../../.cursor/rules/ui_ux_excellence.md#bug-investigation--fixing-protocol) in the UI/UX Excellence rules. This includes:

- **Phase 1:** Understanding the error (read full error message, identify type, locate source)
- **Phase 2:** Analyzing complete flow (read error-causing file, trace data flow, check related files)
- **Phase 3:** Research if needed (search documentation, similar issues)
- **Phase 4:** Finding root cause (logic error, null check, async timing, state initialization)
- **Phase 5:** Fixing carefully (minimal changes, verify no side effects, add safeguards)

The protocol emphasizes reading complete files, tracing data flow through all layers (repository → notifier → page/widget), and documenting root causes with prevention measures.

## Build Issues

### Pod Install Fails (iOS)
```bash
cd ios
pod deintegrate
pod install --repo-update
cd ..
flutter clean
flutter pub get
```

### Gradle Build Fails (Android)
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter build apk
```

### Build Runner Issues
```bash
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
```

## Runtime Issues

### Hot Reload Not Working
```bash
# Restart with hot restart
r (in terminal)

# Full restart
R (in terminal)

# Or
flutter run --no-hot
```

### Package Version Conflicts
```bash
flutter pub upgrade
# Or force specific version in pubspec.yaml
dependency_overrides:
  package_name: ^1.0.0
```

### Memory Leaks
```dart
// ✅ GOOD: Dispose controllers
@override
void dispose() {
  _controller.dispose();
  _subscription?.cancel();
  super.dispose();
}
```

## Platform Issues

### iOS Signing Issues
1. Xcode → Preferences → Accounts
2. Download Manual Profiles
3. Clean build folder
4. Archive again

### Android Keystore Issues
```bash
# Verify keystore
keytool -list -v -keystore upload-keystore.jks

# Check key.properties path
# Ensure storeFile path is correct
```

## Performance Issues

### App Slow on Release
```bash
# Profile build
flutter run --profile

# Check DevTools performance tab
```

### Large App Size
```bash
# Split APKs by ABI
flutter build apk --split-per-abi

# Analyze size
flutter build apk --analyze-size
```

## Common Errors

### "Unsupported operation: Platform._operatingSystem"
Use `kIsWeb` instead of `Platform.isX` for web

### "A RenderFlex overflowed"
Use `Expanded` or `Flexible` widgets

### "setState() called after dispose()"
Check if `mounted` before calling setState

> **Systematic Bug Fixing:** For comprehensive bug investigation workflows, root cause analysis techniques, and bug fix examples, see the [Bug Investigation & Fixing Protocol](../../.cursor/rules/ui_ux_excellence.md#bug-investigation--fixing-protocol) in the UI/UX Excellence rules. Also see [File Organization & Clean Structure](../../.cursor/rules/ui_ux_excellence.md#file-organization--clean-structure) for preventing issues through proper file organization.

---

**Solutions to common problems!**

