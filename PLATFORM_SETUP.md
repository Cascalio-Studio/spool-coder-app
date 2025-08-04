# Platform Setup Guide

This project excludes auto-generated platform folders from version control. When setting up the project or adding new platforms, follow these steps:

## Initial Setup

After cloning the repository, you'll need to generate the platform folders:

```bash
# Get dependencies
flutter pub get

# Create platform folders (choose what you need)
flutter create --platforms android,ios,windows,macos,linux,web .
```

## Available Platforms

### Android
```bash
flutter create --platform android .
```

### iOS  
```bash
flutter create --platform ios .
```

### Windows
```bash
flutter create --platform windows .
```

### macOS
```bash
flutter create --platform macos .
```

### Linux
```bash
flutter create --platform linux .
```

### Web
```bash
flutter create --platform web .
```

## All Platforms at Once
```bash
flutter create --platforms android,ios,windows,macos,linux,web .
```

## Important Notes

- Platform folders are auto-generated and should not be committed
- Any platform-specific customizations will need to be documented separately
- CI/CD pipelines should include platform generation steps
- Team members must run the platform creation commands after cloning

## Building and Running

After creating platforms:

```bash
# Run on available platform
flutter run

# Build for specific platform
flutter build android
flutter build windows
flutter build web
```
