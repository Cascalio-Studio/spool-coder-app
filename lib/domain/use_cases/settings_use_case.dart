import '../entities/user_settings.dart';
import '../repositories/settings_repository.dart';

/// Use case for managing user settings
/// Encapsulates business logic for settings operations
class SettingsUseCase {
  final SettingsRepository _repository;

  const SettingsUseCase(this._repository);

  /// Get current user settings
  Future<UserSettings> getSettings() async {
    return await _repository.getSettings();
  }

  /// Update user settings
  Future<void> updateSettings(UserSettings settings) async {
    await _repository.saveSettings(settings);
  }

  /// Update a specific setting field
  Future<void> updateSetting<T>({
    required String settingName,
    required T value,
  }) async {
    final currentSettings = await getSettings();
    
    UserSettings updatedSettings;
    
    switch (settingName) {
      case 'language':
        updatedSettings = currentSettings.copyWith(language: value as String);
        break;
      case 'dateTimeFormat':
        updatedSettings = currentSettings.copyWith(dateTimeFormat: value as String);
        break;
      case 'regionSettings':
        updatedSettings = currentSettings.copyWith(regionSettings: value as String);
        break;
      case 'themeMode':
        updatedSettings = currentSettings.copyWith(themeMode: value as AppThemeMode);
        break;
      case 'fontSize':
        updatedSettings = currentSettings.copyWith(fontSize: value as FontSize);
        break;
      case 'highContrastMode':
        updatedSettings = currentSettings.copyWith(highContrastMode: value as bool);
        break;
      case 'notificationsEnabled':
        updatedSettings = currentSettings.copyWith(notificationsEnabled: value as bool);
        break;
      case 'notificationSound':
        updatedSettings = currentSettings.copyWith(notificationSound: value as NotificationSound);
        break;
      case 'vibrationOnAlert':
        updatedSettings = currentSettings.copyWith(vibrationOnAlert: value as bool);
        break;
      case 'userDisplayName':
        updatedSettings = currentSettings.copyWith(userDisplayName: value as String?);
        break;
      case 'userEmail':
        updatedSettings = currentSettings.copyWith(userEmail: value as String?);
        break;
      case 'twoFactorAuthEnabled':
        updatedSettings = currentSettings.copyWith(twoFactorAuthEnabled: value as bool);
        break;
      case 'appLockType':
        updatedSettings = currentSettings.copyWith(appLockType: value as AppLockType);
        break;
      case 'biometricEnabled':
        updatedSettings = currentSettings.copyWith(biometricEnabled: value as bool);
        break;
      case 'diagnosticsEnabled':
        updatedSettings = currentSettings.copyWith(diagnosticsEnabled: value as bool);
        break;
      default:
        throw ArgumentError('Unknown setting: $settingName');
    }
    
    await updateSettings(updatedSettings);
  }

  /// Reset all settings to defaults
  Future<void> resetToDefaults() async {
    await _repository.resetToDefaults();
  }

  /// Export settings for diagnostics
  Future<String> exportSettings() async {
    return await _repository.exportSettings();
  }

  /// Clear all settings data
  Future<void> clearAllSettings() async {
    await _repository.clearAllSettings();
  }

  /// Check if settings exist
  Future<bool> hasExistingSettings() async {
    return await _repository.hasSettings();
  }

  /// Validate theme mode compatibility
  bool isThemeModeSupported(AppThemeMode mode) {
    // Add any platform-specific validation here
    return true;
  }

  /// Validate language support
  bool isLanguageSupported(String language) {
    const supportedLanguages = ['en', 'de', 'fr', 'es', 'it', 'ja', 'ko', 'zh'];
    return supportedLanguages.contains(language);
  }

  /// Get available notification sounds
  List<NotificationSound> getAvailableNotificationSounds() {
    return NotificationSound.values;
  }

  /// Get available app lock types
  List<AppLockType> getAvailableAppLockTypes() {
    return AppLockType.values;
  }
}
