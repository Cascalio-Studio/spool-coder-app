import '../entities/user_settings.dart';

/// Repository interface for settings data access
/// Defines contract for settings persistence without implementation details
abstract class SettingsRepository {
  /// Load user settings from persistent storage
  Future<UserSettings> getSettings();

  /// Save user settings to persistent storage
  Future<void> saveSettings(UserSettings settings);

  /// Reset settings to default values
  Future<void> resetToDefaults();

  /// Check if settings exist in storage
  Future<bool> hasSettings();

  /// Export settings as JSON for diagnostics
  Future<String> exportSettings();

  /// Clear all settings data
  Future<void> clearAllSettings();
}
