# Android Configuration

Setup Android project for development and Play Store submission.

## Gradle Configuration

**android/app/build.gradle:**
```gradle
android {
    compileSdkVersion 34
    defaultConfig {
        applicationId "com.yourcompany.yourapp"
        minSdkVersion 21
        targetSdkVersion 34
        versionCode 1
        versionName "1.0.0"
    }
}
```

## Signing

**android/key.properties:**
```properties
storePassword=your-password
keyPassword=your-password
keyAlias=upload
storeFile=../upload-keystore.jks
```

**android/app/build.gradle:**
```gradle
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }
    buildTypes {
        release {
            signingConfig signingConfigs.release
        }
    }
}
```

## Generate Keystore

```bash
keytool -genkey -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

## Permissions

**android/app/src/main/AndroidManifest.xml:**
```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.CAMERA"/>
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
```

## Portrait Orientation Lock

The app is configured to only support portrait orientation:

**android/app/src/main/AndroidManifest.xml:**
```xml
<activity
    android:name=".MainActivity"
    ...
    android:screenOrientation="portrait"
    ...>
```

## Splash Screen

Splash screen is configured via `launch_background.xml` and uses images from `mipmap-*/launch_image.png`.

**To update splash screen:**
1. Replace images in `android/app/src/main/res/mipmap-*/launch_image.png`:
   - `mipmap-mdpi/launch_image.png` (1x - 1080x1920)
   - `mipmap-hdpi/launch_image.png` (1.5x - 1620x2880)
   - `mipmap-xhdpi/launch_image.png` (2x - 2160x3840)
   - `mipmap-xxhdpi/launch_image.png` (3x - 3240x5760)
   - `mipmap-xxxhdpi/launch_image.png` (4x - 4320x7680)
2. The `launch_background.xml` uses `gravity="fill"` to fill the entire screen

## Build

```bash
# Build APK
flutter build apk --release

# Build App Bundle
flutter build appbundle --release
```

---

**Android is configured and ready!**

