# CI/CD Pipeline

Automate testing, building, and deployment with GitHub Actions or Codemagic.

## GitHub Actions

**.github/workflows/main.yml:**
```yaml
name: Flutter CI/CD

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.16.0'
      - run: flutter pub get
      - run: flutter analyze
      - run: flutter test --coverage
      
  build-android:
    needs: test
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: flutter build apk --release
      - uses: actions/upload-artifact@v3
        with:
          name: apk
          path: build/app/outputs/flutter-apk/*.apk
          
  build-ios:
    needs: test
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: flutter build ios --release --no-codesign
```

## Fastlane

**ios/fastlane/Fastfile:**
```ruby
default_platform(:ios)

platform :ios do
  desc "Build and upload to TestFlight"
  lane :beta do
    build_app(scheme: "Runner")
    upload_to_testflight
  end
end
```

**android/fastlane/Fastfile:**
```ruby
default_platform(:android)

platform :android do
  desc "Build and upload to Play Console"
  lane :beta do
    gradle(task: "bundle", build_type: "Release")
    upload_to_play_store(track: "internal")
  end
end
```

## Codemagic

**codemagic.yaml:**
```yaml
workflows:
  flutter-workflow:
    name: Flutter Workflow
    environment:
      flutter: stable
    scripts:
      - flutter pub get
      - flutter analyze
      - flutter test
      - flutter build apk --release
    artifacts:
      - build/app/outputs/**/*.apk
```

---

**Your deployment is now automated!**

