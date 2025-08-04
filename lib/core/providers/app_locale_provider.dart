import 'package:flutter/material.dart';
import 'package:spool_coder_app/core/di/injector.dart';
import 'package:spool_coder_app/domain/use_cases/settings_use_case.dart';
import 'package:spool_coder_app/domain/entities/user_settings.dart';

/// Provider for managing app locale and theme changes
class AppLocaleProvider extends ChangeNotifier {
  static const List<Locale> supportedLocales = [
    Locale('en'), // English
    Locale('de'), // German  
    Locale('fr'), // French
    Locale('es'), // Spanish
    Locale('it'), // Italian
  ];

  static const Map<String, String> languageNames = {
    'en': 'English',
    'de': 'German',
    'fr': 'French', 
    'es': 'Spanish',
    'it': 'Italian',
  };

  late SettingsUseCase _settingsUseCase;
  UserSettings _currentSettings = const UserSettings();
  
  AppLocaleProvider() {
    _settingsUseCase = locator<SettingsUseCase>();
    _loadSettings();
  }

  UserSettings get currentSettings => _currentSettings;
  
  Locale get currentLocale => _getLocaleFromLanguage(_currentSettings.language);
  
  ThemeMode get currentThemeMode => _getThemeMode(_currentSettings.themeMode);

  Future<void> _loadSettings() async {
    try {
      final settings = await _settingsUseCase.getSettings();
      _currentSettings = settings;
      notifyListeners();
    } catch (e) {
      // Use default settings if loading fails
      _currentSettings = const UserSettings();
      notifyListeners();
    }
  }

  Future<void> changeLanguage(String language) async {
    try {
      final updatedSettings = _currentSettings.copyWith(language: language);
      await _settingsUseCase.updateSettings(updatedSettings);
      _currentSettings = updatedSettings;
      notifyListeners();
    } catch (e) {
      // Handle error
      print('Failed to change language: $e');
    }
  }

  Future<void> changeTheme(AppThemeMode themeMode) async {
    try {
      final updatedSettings = _currentSettings.copyWith(themeMode: themeMode);
      await _settingsUseCase.updateSettings(updatedSettings);
      _currentSettings = updatedSettings;
      notifyListeners();
    } catch (e) {
      // Handle error
      print('Failed to change theme: $e');
    }
  }

  Locale _getLocaleFromLanguage(String language) {
    switch (language.toLowerCase()) {
      case 'german':
      case 'deutsch':
        return const Locale('de');
      case 'french':
      case 'français':
        return const Locale('fr');
      case 'spanish':
      case 'español':
        return const Locale('es');
      case 'italian':
      case 'italiano':
        return const Locale('it');
      case 'english':
      default:
        return const Locale('en');
    }
  }

  ThemeMode _getThemeMode(AppThemeMode themeMode) {
    switch (themeMode) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.system:
        return ThemeMode.system;
    }
  }

  String getLanguageDisplayName(String languageCode) {
    return languageNames[languageCode] ?? 'English';
  }

  static String getLanguageCodeFromName(String languageName) {
    for (final entry in languageNames.entries) {
      if (entry.value.toLowerCase() == languageName.toLowerCase()) {
        return entry.key;
      }
    }
    return 'en'; // Default to English
  }
}
