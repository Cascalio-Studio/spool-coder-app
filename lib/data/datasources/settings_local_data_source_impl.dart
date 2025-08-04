import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'settings_local_data_source.dart';

/// SharedPreferences implementation of settings local data source
/// Provides persistent storage using Flutter's SharedPreferences
class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  static const String _settingsKey = 'user_settings';
  final SharedPreferences _prefs;

  const SettingsLocalDataSourceImpl(this._prefs);

  @override
  Future<Map<String, dynamic>?> getSettingsData() async {
    try {
      final settingsJson = _prefs.getString(_settingsKey);
      if (settingsJson == null) return null;
      
      return json.decode(settingsJson) as Map<String, dynamic>;
    } catch (e) {
      // Log error in production
      return null;
    }
  }

  @override
  Future<void> saveSettingsData(Map<String, dynamic> settingsData) async {
    try {
      final settingsJson = json.encode(settingsData);
      await _prefs.setString(_settingsKey, settingsJson);
    } catch (e) {
      // Log error in production
      throw Exception('Failed to save settings: $e');
    }
  }

  @override
  Future<void> clearSettingsData() async {
    try {
      await _prefs.remove(_settingsKey);
    } catch (e) {
      // Log error in production
      throw Exception('Failed to clear settings: $e');
    }
  }

  @override
  Future<bool> hasSettingsData() async {
    return _prefs.containsKey(_settingsKey);
  }

  @override
  Future<T?> getValue<T>(String key) async {
    try {
      // Handle different types
      if (T == String) {
        return _prefs.getString(key) as T?;
      } else if (T == int) {
        return _prefs.getInt(key) as T?;
      } else if (T == bool) {
        return _prefs.getBool(key) as T?;
      } else if (T == double) {
        return _prefs.getDouble(key) as T?;
      } else if (T == List<String>) {
        return _prefs.getStringList(key) as T?;
      }
      return null;
    } catch (e) {
      // Log error in production
      return null;
    }
  }

  @override
  Future<void> setValue<T>(String key, T value) async {
    try {
      // Handle different types
      if (value is String) {
        await _prefs.setString(key, value);
      } else if (value is int) {
        await _prefs.setInt(key, value);
      } else if (value is bool) {
        await _prefs.setBool(key, value);
      } else if (value is double) {
        await _prefs.setDouble(key, value);
      } else if (value is List<String>) {
        await _prefs.setStringList(key, value);
      } else {
        throw ArgumentError('Unsupported type: ${T.toString()}');
      }
    } catch (e) {
      // Log error in production
      throw Exception('Failed to set value for key $key: $e');
    }
  }

  @override
  Future<void> removeValue(String key) async {
    try {
      await _prefs.remove(key);
    } catch (e) {
      // Log error in production
      throw Exception('Failed to remove value for key $key: $e');
    }
  }
}
