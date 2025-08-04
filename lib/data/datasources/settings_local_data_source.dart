/// Local data source interface for settings storage
/// Abstracts platform-specific storage implementation
abstract class SettingsLocalDataSource {
  /// Get all settings data as a map
  Future<Map<String, dynamic>?> getSettingsData();

  /// Save settings data to local storage
  Future<void> saveSettingsData(Map<String, dynamic> settingsData);

  /// Clear all settings data
  Future<void> clearSettingsData();

  /// Check if settings data exists
  Future<bool> hasSettingsData();

  /// Get a specific setting value
  Future<T?> getValue<T>(String key);

  /// Set a specific setting value
  Future<void> setValue<T>(String key, T value);

  /// Remove a specific setting
  Future<void> removeValue(String key);
}
