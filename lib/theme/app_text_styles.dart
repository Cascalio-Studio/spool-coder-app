import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Text styles based on the design concept using Space Grotesk font
/// Font Hierarchy:
/// - Display Large: 32px, Bold - Welcome messages, main headings
/// - Display Medium: 24px, Medium - Section headers
/// - Title Large: 20px, Medium - Card titles
/// - Body Large: 16px, Regular - Primary content text
/// - Body Medium: 14px, Regular - Secondary content
/// - Label Large: 14px, Medium - Button labels
/// - Label Small: 12px, Regular - Helper text, captions
class AppTextStyles {
  // Private constructor to prevent instantiation
  AppTextStyles._();

  /// Base font family - Space Grotesk for everything
  static const String fontFamily = 'Space Grotesk';

  /// Display Large - 32px, Bold
  /// Used for: Welcome messages, main headings
  static const TextStyle displayLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.bold,
    height: 1.2,
    letterSpacing: -0.5,
    color: AppColors.primaryBlack,
  );

  /// Display Medium - 24px, Medium
  /// Used for: Section headers, page titles
  static const TextStyle displayMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w500,
    height: 1.3,
    letterSpacing: -0.3,
    color: AppColors.primaryBlack,
  );

  /// Display Small - 20px, Medium
  /// Used for: Subsection headers
  static const TextStyle displaySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w500,
    height: 1.3,
    letterSpacing: -0.2,
    color: AppColors.primaryBlack,
  );

  /// Title Large - 20px, Medium
  /// Used for: Card titles, dialog titles
  static const TextStyle titleLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w500,
    height: 1.3,
    letterSpacing: -0.2,
    color: AppColors.primaryBlack,
  );

  /// Title Medium - 18px, Medium
  /// Used for: Card subtitles
  static const TextStyle titleMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w500,
    height: 1.3,
    letterSpacing: -0.1,
    color: AppColors.primaryBlack,
  );

  /// Title Small - 16px, Medium
  /// Used for: Small card titles
  static const TextStyle titleSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.4,
    letterSpacing: 0,
    color: AppColors.primaryBlack,
  );

  /// Body Large - 16px, Regular
  /// Used for: Primary content text, form labels
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.normal,
    height: 1.5,
    letterSpacing: 0,
    color: AppColors.primaryBlack,
  );

  /// Body Medium - 14px, Regular
  /// Used for: Secondary content, descriptions
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.normal,
    height: 1.4,
    letterSpacing: 0,
    color: AppColors.primaryBlack,
  );

  /// Body Small - 12px, Regular
  /// Used for: Small content text
  static const TextStyle bodySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.normal,
    height: 1.4,
    letterSpacing: 0,
    color: AppColors.primaryBlack,
  );

  /// Label Large - 14px, Medium
  /// Used for: Button labels, form field labels
  static const TextStyle labelLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.4,
    letterSpacing: 0.1,
    color: AppColors.primaryBlack,
  );

  /// Label Medium - 12px, Medium
  /// Used for: Small button labels
  static const TextStyle labelMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.4,
    letterSpacing: 0.1,
    color: AppColors.primaryBlack,
  );

  /// Label Small - 12px, Regular
  /// Used for: Helper text, captions, navigation labels
  static const TextStyle labelSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.normal,
    height: 1.4,
    letterSpacing: 0.1,
    color: AppColors.primaryBlack,
  );

  /// Complete text theme for Flutter ThemeData
  static const TextTheme textTheme = TextTheme(
    displayLarge: displayLarge,
    displayMedium: displayMedium,
    displaySmall: displaySmall,
    titleLarge: titleLarge,
    titleMedium: titleMedium,
    titleSmall: titleSmall,
    bodyLarge: bodyLarge,
    bodyMedium: bodyMedium,
    bodySmall: bodySmall,
    labelLarge: labelLarge,
    labelMedium: labelMedium,
    labelSmall: labelSmall,
  );

  /// Text style variations with color modifications

  /// Secondary text styles (with reduced opacity)
  static TextStyle get displayLargeSecondary => displayLarge.copyWith(
    color: AppColors.textSecondary,
  );

  static TextStyle get displayMediumSecondary => displayMedium.copyWith(
    color: AppColors.textSecondary,
  );

  static TextStyle get titleLargeSecondary => titleLarge.copyWith(
    color: AppColors.textSecondary,
  );

  static TextStyle get bodyLargeSecondary => bodyLarge.copyWith(
    color: AppColors.textSecondary,
  );

  static TextStyle get bodyMediumSecondary => bodyMedium.copyWith(
    color: AppColors.textSecondary,
  );

  static TextStyle get labelLargeSecondary => labelLarge.copyWith(
    color: AppColors.textSecondary,
  );

  static TextStyle get labelSmallSecondary => labelSmall.copyWith(
    color: AppColors.textSecondary,
  );

  /// Tertiary text styles (more muted)
  static TextStyle get bodyLargeTertiary => bodyLarge.copyWith(
    color: AppColors.textTertiary,
  );

  static TextStyle get bodyMediumTertiary => bodyMedium.copyWith(
    color: AppColors.textTertiary,
  );

  static TextStyle get labelSmallTertiary => labelSmall.copyWith(
    color: AppColors.textTertiary,
  );

  /// White text styles (for dark backgrounds)
  static TextStyle get displayLargeWhite => displayLarge.copyWith(
    color: AppColors.pureWhite,
  );

  static TextStyle get displayMediumWhite => displayMedium.copyWith(
    color: AppColors.pureWhite,
  );

  static TextStyle get titleLargeWhite => titleLarge.copyWith(
    color: AppColors.pureWhite,
  );

  static TextStyle get bodyLargeWhite => bodyLarge.copyWith(
    color: AppColors.pureWhite,
  );

  static TextStyle get bodyMediumWhite => bodyMedium.copyWith(
    color: AppColors.pureWhite,
  );

  static TextStyle get labelLargeWhite => labelLarge.copyWith(
    color: AppColors.pureWhite,
  );

  /// Green text styles (for accent elements)
  static TextStyle get bodyLargeGreen => bodyLarge.copyWith(
    color: AppColors.accentGreen,
  );

  static TextStyle get labelLargeGreen => labelLarge.copyWith(
    color: AppColors.accentGreen,
  );

  /// Error text styles
  static TextStyle get bodyLargeError => bodyLarge.copyWith(
    color: AppColors.errorRed,
  );

  static TextStyle get bodyMediumError => bodyMedium.copyWith(
    color: AppColors.errorRed,
  );

  static TextStyle get labelLargeError => labelLarge.copyWith(
    color: AppColors.errorRed,
  );

  /// Special text styles for specific use cases

  /// Welcome greeting style
  static const TextStyle welcomeGreeting = TextStyle(
    fontFamily: fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.bold,
    height: 1.2,
    letterSpacing: -0.5,
    color: AppColors.primaryBlack,
  );

  /// Welcome subtitle style
  static TextStyle get welcomeSubtitle => bodyMedium.copyWith(
    color: AppColors.textSecondary,
  );

  /// Spool card title style
  static const TextStyle spoolCardTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.3,
    letterSpacing: 0,
    color: AppColors.primaryBlack,
  );

  /// Spool card brand style
  static TextStyle get spoolCardBrand => bodyMedium.copyWith(
    color: AppColors.textSecondary,
  );

  /// Spool card amount style (emphasized)
  static const TextStyle spoolCardAmount = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.3,
    letterSpacing: 0,
    color: AppColors.primaryBlack,
  );

  /// Spool card last used style
  static TextStyle get spoolCardLastUsed => labelSmall.copyWith(
    color: AppColors.textTertiary,
  );

  /// Button text style (for primary buttons)
  static const TextStyle buttonPrimary = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.4,
    letterSpacing: 0.1,
    color: AppColors.primaryBlack,
  );

  /// Button text style (for secondary buttons)
  static const TextStyle buttonSecondary = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.4,
    letterSpacing: 0.1,
    color: AppColors.primaryBlack,
  );

  /// Navigation label style
  static TextStyle get navigationLabel => labelSmall;

  /// Section header style
  static TextStyle get sectionHeader => bodyLarge.copyWith(
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );
}
