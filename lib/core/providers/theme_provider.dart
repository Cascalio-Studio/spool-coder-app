import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../domain/entities/user_settings.dart';
import '../../domain/use_cases/settings_use_case.dart';
import '../../theme/app_theme.dart';

/// Provider for managing app theme based on user settings
class ThemeProvider extends ChangeNotifier {
  late final SettingsUseCase _settingsUseCase;
  AppThemeMode _currentTheme = AppThemeMode.system;
  bool _highContrastMode = false;

  ThemeProvider() {
    _settingsUseCase = GetIt.instance<SettingsUseCase>();
    _loadThemeSettings();
  }

  /// Current theme mode
  AppThemeMode get currentTheme => _currentTheme;

  /// Whether high contrast mode is enabled
  bool get highContrastMode => _highContrastMode;

  /// Get the appropriate ThemeData based on current settings
  ThemeData getThemeData(BuildContext context) {
    final brightness = _getEffectiveBrightness(context);
    
    if (brightness == Brightness.dark) {
      return _highContrastMode ? _getHighContrastDarkTheme() : AppTheme.darkTheme;
    } else {
      return _highContrastMode ? _getHighContrastLightTheme() : AppTheme.lightTheme;
    }
  }

  /// Get the effective brightness based on current theme mode
  Brightness _getEffectiveBrightness(BuildContext context) {
    switch (_currentTheme) {
      case AppThemeMode.light:
        return Brightness.light;
      case AppThemeMode.dark:
        return Brightness.dark;
      case AppThemeMode.system:
        return MediaQuery.of(context).platformBrightness;
    }
  }

  /// Load theme settings from storage
  Future<void> _loadThemeSettings() async {
    try {
      final settings = await _settingsUseCase.getSettings();
      _currentTheme = settings.themeMode;
      _highContrastMode = settings.highContrastMode;
      notifyListeners();
    } catch (e) {
      // Use defaults if loading fails
      _currentTheme = AppThemeMode.system;
      _highContrastMode = false;
    }
  }

  /// Update theme mode
  Future<void> updateThemeMode(AppThemeMode mode) async {
    try {
      await _settingsUseCase.updateSetting(
        settingName: 'themeMode',
        value: mode,
      );
      _currentTheme = mode;
      notifyListeners();
    } catch (e) {
      // Handle error
      debugPrint('Failed to update theme mode: $e');
    }
  }

  /// Update high contrast mode
  Future<void> updateHighContrastMode(bool enabled) async {
    try {
      await _settingsUseCase.updateSetting(
        settingName: 'highContrastMode',
        value: enabled,
      );
      _highContrastMode = enabled;
      notifyListeners();
    } catch (e) {
      // Handle error
      debugPrint('Failed to update high contrast mode: $e');
    }
  }

  /// Refresh theme settings (useful when settings change externally)
  Future<void> refreshThemeSettings() async {
    await _loadThemeSettings();
  }

  /// Get high contrast light theme
  ThemeData _getHighContrastLightTheme() {
    return AppTheme.lightTheme.copyWith(
      colorScheme: AppTheme.lightTheme.colorScheme.copyWith(
        surface: Colors.white,
        onSurface: Colors.black,
        background: Colors.white,
        onBackground: Colors.black,
        primary: Colors.black,
        onPrimary: Colors.white,
      ),
      textTheme: AppTheme.lightTheme.textTheme.apply(
        bodyColor: Colors.black,
        displayColor: Colors.black,
      ),
      iconTheme: const IconThemeData(
        color: Colors.black,
      ),
      appBarTheme: AppTheme.lightTheme.appBarTheme.copyWith(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      cardTheme: AppTheme.lightTheme.cardTheme.copyWith(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(
            color: Colors.black,
            width: 2,
          ),
        ),
      ),
    );
  }

  /// Get high contrast dark theme
  ThemeData _getHighContrastDarkTheme() {
    return AppTheme.darkTheme.copyWith(
      colorScheme: AppTheme.darkTheme.colorScheme.copyWith(
        surface: Colors.black,
        onSurface: Colors.white,
        background: Colors.black,
        onBackground: Colors.white,
        primary: Colors.white,
        onPrimary: Colors.black,
      ),
      textTheme: AppTheme.darkTheme.textTheme.apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
      appBarTheme: AppTheme.darkTheme.appBarTheme.copyWith(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      cardTheme: AppTheme.darkTheme.cardTheme.copyWith(
        color: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(
            color: Colors.white,
            width: 2,
          ),
        ),
      ),
    );
  }
}
