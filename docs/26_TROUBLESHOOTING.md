# Troubleshooting

Common issues and solutions in Flutter development.

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

---

**Solutions to common problems!**

