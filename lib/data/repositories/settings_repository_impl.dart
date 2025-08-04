import 'dart:convert';
import '../../domain/entities/user_settings.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/settings_local_data_source.dart';

/// Implementation of settings repository using local data source
/// Handles data transformation between domain entities and storage format
class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDataSource _localDataSource;

  const SettingsRepositoryImpl(this._localDataSource);

  @override
  Future<UserSettings> getSettings() async {
    try {
      final settingsData = await _localDataSource.getSettingsData();
      
      if (settingsData == null) {
        // Return default settings if none exist
        return const UserSettings();
      }

      return UserSettings.fromMap(settingsData);
    } catch (e) {
      // Log error in production and return defaults
      return const UserSettings();
    }
  }

  @override
  Future<void> saveSettings(UserSettings settings) async {
    try {
      final settingsData = settings.toMap();
      await _localDataSource.saveSettingsData(settingsData);
    } catch (e) {
      // Log error in production
      throw Exception('Failed to save settings: $e');
    }
  }

  @override
  Future<void> resetToDefaults() async {
    try {
      const defaultSettings = UserSettings();
      await saveSettings(defaultSettings);
    } catch (e) {
      // Log error in production
      throw Exception('Failed to reset settings: $e');
    }
  }

  @override
  Future<bool> hasSettings() async {
    try {
      return await _localDataSource.hasSettingsData();
    } catch (e) {
      // Log error in production
      return false;
    }
  }

  @override
  Future<String> exportSettings() async {
    try {
      final settings = await getSettings();
      final settingsMap = settings.toMap();
      
      // Remove sensitive data from export
      final exportMap = Map<String, dynamic>.from(settingsMap);
      exportMap.remove('userEmail');
      exportMap.remove('userDisplayName');
      
      return const JsonEncoder.withIndent('  ').convert(exportMap);
    } catch (e) {
      // Log error in production
      throw Exception('Failed to export settings: $e');
    }
  }

  @override
  Future<void> clearAllSettings() async {
    try {
      await _localDataSource.clearSettingsData();
    } catch (e) {
      // Log error in production
      throw Exception('Failed to clear settings: $e');
    }
  }
}
