# Flutter Theme Configuration - Implementation Guide

This document explains how to implement and use the custom theme configuration based on the Spool Coder App design concept.

## Overview

The theme system consists of three main files:
- `app_theme.dart` - Main theme configuration
- `app_colors.dart` - Color constants and utilities
- `app_text_styles.dart` - Typography definitions

## Setup Instructions

### 1. Add Font Assets

First, add the Space Grotesk font files to `assets/fonts/` directory:
- SpaceGrotesk-Regular.ttf
- SpaceGrotesk-Medium.ttf
- SpaceGrotesk-SemiBold.ttf
- SpaceGrotesk-Bold.ttf

### 2. Update Main App

Update your `main.dart` to use the custom theme:

```dart
import 'package:flutter/material.dart';
import 'package:spool_coder_app/theme/theme.dart';

void main() {
  runApp(const SpoolCoderApp());
}

class SpoolCoderApp extends StatelessWidget {
  const SpoolCoderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spool Coder',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme, // Future implementation
      themeMode: ThemeMode.light,
      home: const HomeScreen(),
    );
  }
}
```

## Usage Examples

### Using Colors

```dart
import 'package:flutter/material.dart';
import 'package:spool_coder_app/theme/theme.dart';

class ExampleWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      // Using direct color constants
      color: AppColors.accentGreen,
      child: Text(
        'Hello World',
        // Using colors from theme extension
        style: TextStyle(color: context.appColors.primaryBlack),
      ),
    );
  }
}
```

### Using Text Styles

```dart
class TextExampleWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Using theme text styles
        Text(
          'Welcome Message',
          style: Theme.of(context).textTheme.displayLarge,
        ),
        // Using custom text styles
        Text(
          'Subtitle',
          style: AppTextStyles.bodyMediumSecondary,
        ),
        // Using specialized styles
        Text(
          'Spool Information',
          style: AppTextStyles.spoolCardTitle,
        ),
      ],
    );
  }
}
```

### Creating Themed Buttons

```dart
class ThemedButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Primary button (automatically styled)
        ElevatedButton(
          onPressed: () {},
          child: Text('Read RFID'),
        ),
        
        // Secondary button
        OutlinedButton(
          onPressed: () {},
          child: Text('Cancel'),
        ),
        
        // Custom styled button
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.accentGreen,
            foregroundColor: AppColors.primaryBlack,
          ),
          child: Text('Write RFID'),
        ),
      ],
    );
  }
}
```

### Creating Spool Cards

```dart
class SpoolCard extends StatelessWidget {
  final String filamentType;
  final String brand;
  final String color;
  final double remainingKg;
  final String lastUsed;

  const SpoolCard({
    super.key,
    required this.filamentType,
    required this.brand,
    required this.color,
    required this.remainingKg,
    required this.lastUsed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Color indicator
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: AppColors.accentGreen, // Use actual color
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  filamentType,
                  style: AppTextStyles.spoolCardTitle,
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              brand,
              style: AppTextStyles.spoolCardBrand,
            ),
            const Divider(height: 20),
            Text(
              '${remainingKg.toStringAsFixed(1)} kg remaining',
              style: AppTextStyles.spoolCardAmount,
            ),
            const SizedBox(height: 4),
            Text(
              'Last used: $lastUsed',
              style: AppTextStyles.spoolCardLastUsed,
            ),
          ],
        ),
      ),
    );
  }
}
```

### Settings Screen Items

```dart
class SettingsItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;

  const SettingsItem({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      trailing: trailing ?? const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}

// Usage in settings screen
class SettingsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.backgroundGray,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          SettingsItem(
            icon: Icons.person,
            title: 'Profile Settings',
            onTap: () {},
          ),
          const Divider(height: 1),
          SettingsItem(
            icon: Icons.lock,
            title: 'Password',
            onTap: () {},
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notifications'),
            trailing: Switch(
              value: true,
              onChanged: (value) {},
            ),
          ),
        ],
      ),
    );
  }
}
```

## Theme Customization

### Adding New Colors

To add new colors, update `app_colors.dart`:

```dart
static const Color newColor = Color(0xFF123456);
```

### Adding New Text Styles

To add new text styles, update `app_text_styles.dart`:

```dart
static const TextStyle newStyle = TextStyle(
  fontFamily: fontFamily,
  fontSize: 18,
  fontWeight: FontWeight.w600,
  color: AppColors.primaryBlack,
);
```

### Modifying Button Styles

To modify button styles, update the relevant theme in `app_theme.dart`:

```dart
elevatedButtonTheme: ElevatedButtonThemeData(
  style: ElevatedButton.styleFrom(
    // Your custom styling
  ),
),
```

## Design Tokens

The theme implements the following design tokens from the design concept:

### Colors
- Primary Black: #202020
- Accent Green: #C9F158  
- Background Gray: #F2F3F5
- Pure White: #FFFFFF

### Typography
- Font Family: Space Grotesk
- Display Large: 32px, Bold
- Display Medium: 24px, Medium
- Title Large: 20px, Medium
- Body Large: 16px, Regular
- Body Medium: 14px, Regular
- Label Large: 14px, Medium
- Label Small: 12px, Regular

### Spacing
- Card Border Radius: 12px
- Button Border Radius: 12px
- Section Border Radius: 16px
- Standard Padding: 16px
- Large Padding: 24px

### Elevation
- Card Elevation: 2px
- Button Elevation: 0px (flat design)
- Shadow Color: Black with 8% opacity

This theme configuration ensures consistent styling across the entire application while following the modern, minimalist design concept.
