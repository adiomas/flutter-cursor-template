# iOS Configuration

Setup iOS project for development and App Store submission.

## Xcode Setup

1. Open `ios/Runner.xcworkspace` in Xcode
2. Select Runner target
3. Set Bundle Identifier: `com.yourcompany.yourapp`
4. Set Team: Your Apple Developer Team
5. Set Deployment Target: iOS 12.0+

## Certificates & Provisioning

### Development Certificate
1. Xcode → Preferences → Accounts
2. Add Apple ID
3. Manage Certificates → Create Development Certificate

### Distribution Certificate
1. developer.apple.com → Certificates
2. Create → iOS Distribution
3. Download and install

### Provisioning Profiles
```bash
# Automatic signing (recommended for dev)
# Xcode handles this automatically

# Manual signing (for CI/CD)
# Download profiles from developer.apple.com
```

## App Store Connect

1. Create app at appstoreconnect.apple.com
2. Fill app information
3. Add screenshots
4. Set pricing and availability
5. Submit for review

## Build & Archive

```bash
# Build
flutter build ios --release

# Archive in Xcode
# Product → Archive
# Distribute App → App Store Connect
```

## Info.plist Permissions

```xml
<key>NSCameraUsageDescription</key>
<string>Need camera for profile photos</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>Need photos for profile</string>
<key>NSLocationWhenInUseUsageDescription</key>
<string>Need location for nearby features</string>
```

---

**iOS is configured and ready!**

