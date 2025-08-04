import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

/// Main theme configuration for the Spool Coder app
/// Implements the design concept with Space Grotesk typography and custom color palette
class AppTheme {
  // Private constructor to prevent instantiation
  AppTheme._();

  /// Light theme configuration
  static ThemeData get lightTheme {
    return ThemeData(
      // Use Material 3 design system
      useMaterial3: true,
      
      // Color scheme based on our design concept
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.accentGreen,
        brightness: Brightness.light,
        primary: AppColors.accentGreen,
        onPrimary: AppColors.primaryBlack,
        secondary: AppColors.primaryBlack,
        onSecondary: AppColors.pureWhite,
        surface: AppColors.pureWhite,
        onSurface: AppColors.primaryBlack,
        background: AppColors.pureWhite,
        onBackground: AppColors.primaryBlack,
        error: AppColors.errorRed,
        onError: AppColors.pureWhite,
      ),

      // Custom color extensions
      extensions: <ThemeExtension<dynamic>>[
        AppColorsExtension(
          primaryBlack: AppColors.primaryBlack,
          accentGreen: AppColors.accentGreen,
          backgroundGray: AppColors.backgroundGray,
          pureWhite: AppColors.pureWhite,
          mutedBlack: AppColors.mutedBlack,
          errorRed: AppColors.errorRed,
        ),
      ],

      // Typography using Space Grotesk
      textTheme: AppTextStyles.textTheme,
      
      // App bar theme
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.pureWhite,
        foregroundColor: AppColors.primaryBlack,
        elevation: 0,
        scrolledUnderElevation: 1,
        surfaceTintColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: AppTextStyles.displayMedium,
        toolbarTextStyle: AppTextStyles.bodyLarge,
        iconTheme: IconThemeData(
          color: AppColors.primaryBlack,
          size: 24,
        ),
      ),

      // Bottom navigation bar theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.pureWhite,
        selectedItemColor: AppColors.accentGreen,
        unselectedItemColor: AppColors.mutedBlack,
        selectedLabelStyle: AppTextStyles.labelSmall,
        unselectedLabelStyle: AppTextStyles.labelSmall,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),

      // Card theme
      cardTheme: CardThemeData(
        color: AppColors.pureWhite,
        surfaceTintColor: Colors.transparent,
        shadowColor: AppColors.primaryBlack.withOpacity(0.08),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: AppColors.backgroundGray,
            width: 1,
          ),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),

      // Elevated button theme (Primary action buttons)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accentGreen,
          foregroundColor: AppColors.primaryBlack,
          disabledBackgroundColor: AppColors.backgroundGray,
          disabledForegroundColor: AppColors.mutedBlack,
          textStyle: AppTextStyles.labelLarge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          minimumSize: const Size(double.infinity, 48),
          elevation: 0,
          shadowColor: Colors.transparent,
        ),
      ),

      // Outlined button theme (Secondary buttons)
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryBlack,
          backgroundColor: AppColors.pureWhite,
          disabledForegroundColor: AppColors.mutedBlack,
          textStyle: AppTextStyles.labelLarge,
          side: BorderSide(
            color: AppColors.primaryBlack,
            width: 1,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          minimumSize: const Size(double.infinity, 48),
        ),
      ),

      // Text button theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryBlack,
          textStyle: AppTextStyles.labelLarge,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),

      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.backgroundGray,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColors.backgroundGray,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColors.accentGreen,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColors.errorRed,
            width: 1,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColors.errorRed,
            width: 2,
          ),
        ),
        labelStyle: AppTextStyles.bodyMedium,
        hintStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.mutedBlack,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),

      // Switch theme (for toggle switches in settings)
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith<Color>(
          (Set<WidgetState> states) {
            return AppColors.pureWhite;
          },
        ),
        trackColor: WidgetStateProperty.resolveWith<Color>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.selected)) {
              return AppColors.accentGreen;
            }
            return AppColors.backgroundGray;
          },
        ),
        overlayColor: WidgetStateProperty.resolveWith<Color>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.selected)) {
              return AppColors.accentGreen.withOpacity(0.12);
            }
            return AppColors.mutedBlack.withOpacity(0.12);
          },
        ),
      ),

      // List tile theme (for settings items)
      listTileTheme: ListTileThemeData(
        tileColor: AppColors.pureWhite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        titleTextStyle: AppTextStyles.bodyLarge,
        subtitleTextStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.mutedBlack,
        ),
        iconColor: AppColors.primaryBlack,
        dense: false,
      ),

      // Icon theme
      iconTheme: IconThemeData(
        color: AppColors.primaryBlack,
        size: 24,
      ),

      // Divider theme
      dividerTheme: DividerThemeData(
        color: AppColors.backgroundGray,
        thickness: 1,
        space: 1,
      ),

      // Dialog theme
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.pureWhite,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        titleTextStyle: AppTextStyles.titleLarge,
        contentTextStyle: AppTextStyles.bodyLarge,
      ),

      // Scaffold background
      scaffoldBackgroundColor: AppColors.pureWhite,

      // Splash color (touch feedback)
      splashColor: AppColors.accentGreen.withOpacity(0.12),
      highlightColor: AppColors.accentGreen.withOpacity(0.08),

      // Focus color
      focusColor: AppColors.accentGreen.withOpacity(0.12),
    );
  }

  /// Dark theme configuration (for future implementation)
  static ThemeData get darkTheme {
    // For now, return light theme
    // TODO: Implement dark theme based on user requirements
    return lightTheme;
  }
}

/// Custom color extension to access our specific colors
@immutable
class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  const AppColorsExtension({
    required this.primaryBlack,
    required this.accentGreen,
    required this.backgroundGray,
    required this.pureWhite,
    required this.mutedBlack,
    required this.errorRed,
  });

  final Color primaryBlack;
  final Color accentGreen;
  final Color backgroundGray;
  final Color pureWhite;
  final Color mutedBlack;
  final Color errorRed;

  @override
  AppColorsExtension copyWith({
    Color? primaryBlack,
    Color? accentGreen,
    Color? backgroundGray,
    Color? pureWhite,
    Color? mutedBlack,
    Color? errorRed,
  }) {
    return AppColorsExtension(
      primaryBlack: primaryBlack ?? this.primaryBlack,
      accentGreen: accentGreen ?? this.accentGreen,
      backgroundGray: backgroundGray ?? this.backgroundGray,
      pureWhite: pureWhite ?? this.pureWhite,
      mutedBlack: mutedBlack ?? this.mutedBlack,
      errorRed: errorRed ?? this.errorRed,
    );
  }

  @override
  AppColorsExtension lerp(AppColorsExtension? other, double t) {
    if (other is! AppColorsExtension) {
      return this;
    }
    return AppColorsExtension(
      primaryBlack: Color.lerp(primaryBlack, other.primaryBlack, t)!,
      accentGreen: Color.lerp(accentGreen, other.accentGreen, t)!,
      backgroundGray: Color.lerp(backgroundGray, other.backgroundGray, t)!,
      pureWhite: Color.lerp(pureWhite, other.pureWhite, t)!,
      mutedBlack: Color.lerp(mutedBlack, other.mutedBlack, t)!,
      errorRed: Color.lerp(errorRed, other.errorRed, t)!,
    );
  }
}

/// Extension to easily access custom colors from BuildContext
extension AppColorsContextExtension on BuildContext {
  AppColorsExtension get appColors =>
      Theme.of(this).extension<AppColorsExtension>()!;
}
