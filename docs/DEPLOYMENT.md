# Deployment Guide

This guide covers building, testing, and deploying the Spool Coder app across different platforms and environments.

## Quick Start

### Prerequisites
- Flutter SDK (latest stable)
- Android Studio / Xcode (for platform builds)
- Connected device or emulator

### Basic Commands
```bash
# Install dependencies
flutter pub get

# Run in debug mode
flutter run

# Build for release
flutter build apk --release  # Android
flutter build ios --release  # iOS
```

## Platform-Specific Deployment

### Android

#### Samsung Galaxy S20 Ultra (Tested)
The app has been specifically tested and optimized for the Samsung Galaxy S20 Ultra (SM-G988B).

```bash
# Build for Samsung Galaxy S20 Ultra (android-arm64)
flutter build apk --release --target-platform android-arm64

# Install on connected device
flutter install

# Or use ADB directly
adb install build/app/outputs/flutter-apk/app-release.apk
```

#### Android Configuration
- **Minimum SDK**: API 21 (Android 5.0)
- **Target SDK**: API 34 (Android 14)
- **Architecture**: arm64-v8a (primary), armeabi-v7a (fallback)

#### Required Permissions
```xml
<!-- AndroidManifest.xml -->
<uses-permission android:name="android.permission.NFC" />
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />

<!-- NFC Feature -->
<uses-feature
    android:name="android.hardware.nfc"
    android:required="true" />
```

#### NFC Intent Filters
```xml
<!-- For automatic NFC tag handling -->
<intent-filter>
    <action android:name="android.nfc.action.TECH_DISCOVERED" />
    <category android:name="android.intent.category.DEFAULT" />
</intent-filter>
<meta-data
    android:name="android.nfc.action.TECH_DISCOVERED"
    android:resource="@xml/nfc_tech_filter" />
```

### iOS

#### Build Configuration
```bash
# Build for iOS devices
flutter build ios --release

# For iOS Simulator
flutter build ios --debug --simulator
```

#### iOS Configuration
- **Minimum Version**: iOS 12.0
- **Architecture**: arm64 (iPhone), x86_64 (Simulator)
- **Capabilities**: Near Field Communication Tag Reading

#### Required Info.plist Entries
```xml
<!-- Info.plist -->
<key>NFCReaderUsageDescription</key>
<string>This app uses NFC to read filament spool information</string>

<key>com.apple.developer.nfc.readersession.formats</key>
<array>
    <string>NDEF</string>
    <string>TAG</string>
</array>
```

## Environment Configuration

### Development Environment
```bash
# Debug build with hot reload
flutter run --debug

# Profile build for performance testing
flutter run --profile

# Enable additional logging
flutter run --verbose
```

### Staging Environment
```bash
# Build with staging configuration
flutter build apk --release --dart-define=ENVIRONMENT=staging
flutter build ios --release --dart-define=ENVIRONMENT=staging
```

### Production Environment
```bash
# Production builds with optimization
flutter build apk --release --dart-define=ENVIRONMENT=production --shrink
flutter build ios --release --dart-define=ENVIRONMENT=production
```

## Testing Before Deployment

### Automated Testing
```bash
# Run all tests
flutter test

# Run integration tests
flutter test integration_test/

# Run specific test files
flutter test test/domain/
```

### Device Testing Checklist

#### NFC Functionality
- [ ] NFC availability detection
- [ ] Tag scanning and reading
- [ ] Error handling for unsupported tags
- [ ] Timeout handling (30 seconds)
- [ ] Multiple scan sessions

#### UI/UX Testing
- [ ] Theme switching (Light/Dark/High Contrast)
- [ ] Language switching (EN, DE, FR, ES, IT)
- [ ] Font size scaling
- [ ] Navigation flow
- [ ] Responsive design on different screen sizes

#### Performance Testing
- [ ] App startup time
- [ ] Memory usage during scanning
- [ ] Battery consumption
- [ ] Background behavior

## Release Process

### Version Management
```bash
# Update version in pubspec.yaml
version: 1.2.3+4  # version+build_number

# Generate release notes
git log --oneline v1.2.2..HEAD > RELEASE_NOTES.md
```

### Android Release
```bash
# Generate signed APK
flutter build apk --release

# Generate App Bundle for Play Store
flutter build appbundle --release

# Verify signature
jarsigner -verify -verbose build/app/outputs/bundle/release/app-release.aab
```

### iOS Release
```bash
# Build for App Store
flutter build ios --release

# Create archive in Xcode
# Product > Archive
# Window > Organizer > Upload to App Store
```

## Troubleshooting

### Common Build Issues

#### Android
```bash
# Clean build artifacts
flutter clean
flutter pub get
flutter build apk --release

# Check for dependency conflicts
flutter doctor
flutter pub deps
```

#### iOS
```bash
# Update CocoaPods
cd ios && pod install --repo-update

# Clean derived data
rm -rf ~/Library/Developer/Xcode/DerivedData/

# Reset iOS Simulator
xcrun simctl erase all
```

### NFC Issues
- Ensure NFC is enabled on device
- Check permissions in app settings
- Verify NFC tag compatibility
- Test with known working tags

### Performance Issues
```bash
# Profile app performance
flutter run --profile
flutter run --trace-startup

# Analyze bundle size
flutter build apk --analyze-size
```

## Deployment Targets

### Minimum Device Requirements
- **Android**: API 21+, NFC-enabled device, 2GB RAM
- **iOS**: iOS 12.0+, NFC-capable device (iPhone 7+)

### Recommended Devices
- **Samsung Galaxy S20 Ultra** (primary test device)
- **iPhone 12 Pro** or newer
- **Google Pixel 6** or newer

### Known Compatible Devices
- Samsung Galaxy S20/S21/S22 series
- iPhone 7 and newer (NFC capable)
- Google Pixel 3 and newer
- OnePlus 8 and newer

## Monitoring & Analytics

### Crash Reporting
- Configure Firebase Crashlytics for production builds
- Monitor crash-free rates and performance metrics

### User Analytics
- Track NFC scan success rates
- Monitor feature usage patterns
- Analyze performance across device types

### Performance Monitoring
- App startup times
- NFC operation latency
- Memory usage patterns
- Battery consumption metrics

## Security Considerations

### Code Obfuscation
```bash
# Enable obfuscation for release builds
flutter build apk --release --obfuscate --split-debug-info=symbols/

# Store debug symbols securely for crash analysis
```

### Data Protection
- Encrypt local storage where sensitive data is stored
- Validate all RFID data before processing
- Implement secure communication for backend integration

### NFC Security
- Validate tag authenticity using RSA signatures
- Sanitize all data read from NFC tags
- Implement rate limiting for scan operations

This deployment guide should be updated as new platforms, devices, or deployment requirements are added to the project.
