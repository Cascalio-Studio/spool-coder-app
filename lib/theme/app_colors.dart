import 'package:flutter/material.dart';

/// App color constants based on the design concept
/// Colors: Black (#202020), Green (#C9F158), Gray (#F2F3F5), White (#FFFFFF)
class AppColors {
  // Private constructor to prevent instantiation
  AppColors._();

  /// Primary Colors from Design Concept
  static const Color primaryBlack = Color(0xFF202020);
  static const Color accentGreen = Color(0xFFC9F158);
  static const Color backgroundGray = Color(0xFFF2F3F5);
  static const Color pureWhite = Color(0xFFFFFFFF);

  /// Derived Colors
  /// Muted black for inactive elements (primaryBlack with 40% opacity)
  static final Color mutedBlack = primaryBlack.withValues(alpha: 0.4);
  
  /// Error color (not in design concept but needed for forms/validation)
  static const Color errorRed = Color(0xFFFF3B30);

  /// Color variations for different states
  static final Color accentGreenPressed = _darkenColor(accentGreen, 0.1);
  static final Color backgroundGrayLight = _lightenColor(backgroundGray, 0.05);
  static final Color primaryBlackLight = primaryBlack.withValues(alpha: 0.7);

  /// Helper method to darken a color
  static Color _darkenColor(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);
    final darkened = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return darkened.toColor();
  }

  /// Helper method to lighten a color
  static Color _lightenColor(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);
    final lightened = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));
    return lightened.toColor();
  }

  /// Gradient definitions for cards and backgrounds
  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      pureWhite,
      backgroundGray,
    ],
    stops: [0.0, 1.0],
  );

  /// Green accent gradient for selected states
  static LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      accentGreen,
      _darkenColor(accentGreen, 0.05),
    ],
    stops: [0.0, 1.0],
  );

  /// Shadow colors for elevation
  static final Color shadowColor = primaryBlack.withValues(alpha: 0.08);
  static final Color shadowColorDark = primaryBlack.withValues(alpha: 0.16);

  /// Overlay colors for modal backgrounds
  static final Color overlayColor = primaryBlack.withValues(alpha: 0.5);
  static final Color overlayColorLight = primaryBlack.withValues(alpha: 0.3);

  /// Border colors
  static final Color borderColor = backgroundGray;
  static final Color borderColorActive = accentGreen;
  static final Color borderColorError = errorRed;

  /// Text colors with opacity variations
  static final Color textSecondary = primaryBlack.withValues(alpha: 0.7);
  static final Color textTertiary = primaryBlack.withValues(alpha: 0.5);
  static final Color textQuaternary = primaryBlack.withValues(alpha: 0.3);

  /// Status colors
  static const Color successGreen = accentGreen;
  static const Color warningOrange = Color(0xFFFF9500);
  static const Color infoBlue = Color(0xFF007AFF);

  /// Spool color indicators (for filament colors)
  static const List<Color> spoolColors = [
    Color(0xFF000000), // Black
    Color(0xFFFFFFFF), // White
    Color(0xFFFF0000), // Red
    Color(0xFF00FF00), // Green
    Color(0xFF0000FF), // Blue
    Color(0xFFFFFF00), // Yellow
    Color(0xFFFF00FF), // Magenta
    Color(0xFF00FFFF), // Cyan
    Color(0xFFFFA500), // Orange
    Color(0xFF800080), // Purple
    Color(0xFFA52A2A), // Brown
    Color(0xFFFFB6C1), // Light Pink
    Color(0xFF90EE90), // Light Green
    Color(0xFFADD8E6), // Light Blue
    Color(0xFFFFFFE0), // Light Yellow
    Color(0xFFF0F0F0), // Light Gray
    Color(0xFF808080), // Gray
    Color(0xFF404040), // Dark Gray
  ];

  /// Get a spool color by index (with fallback)
  static Color getSpoolColor(int index) {
    if (index < 0 || index >= spoolColors.length) {
      return spoolColors[0]; // Default to black
    }
    return spoolColors[index];
  }

  /// Get contrasting text color for a given background color
  static Color getContrastingTextColor(Color backgroundColor) {
    // Calculate relative luminance
    final luminance = (0.299 * (backgroundColor.r * 255.0).round() + 
                     0.587 * (backgroundColor.g * 255.0).round() + 
                     0.114 * (backgroundColor.b * 255.0).round()) / 255;
    
    // Return white for dark backgrounds, black for light backgrounds
    return luminance > 0.5 ? primaryBlack : pureWhite;
  }
}
