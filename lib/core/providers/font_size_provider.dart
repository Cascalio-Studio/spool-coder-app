import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../domain/entities/user_settings.dart';
import '../../domain/use_cases/settings_use_case.dart';

/// Provider for managing font size scaling based on user settings
class FontSizeProvider extends ChangeNotifier {
  late final SettingsUseCase _settingsUseCase;
  FontSize _currentFontSize = FontSize.medium;

  FontSizeProvider() {
    _settingsUseCase = GetIt.instance<SettingsUseCase>();
    _loadFontSizeSettings();
  }

  /// Current font size setting
  FontSize get currentFontSize => _currentFontSize;

  /// Get text scale factor based on font size setting
  double get textScaleFactor {
    switch (_currentFontSize) {
      case FontSize.small:
        return 0.85;
      case FontSize.medium:
        return 1.0;
      case FontSize.large:
        return 1.15;
    }
  }

  /// Load font size settings from storage
  Future<void> _loadFontSizeSettings() async {
    try {
      final settings = await _settingsUseCase.getSettings();
      _currentFontSize = settings.fontSize;
      notifyListeners();
    } catch (e) {
      // Use default if loading fails
      _currentFontSize = FontSize.medium;
    }
  }

  /// Update font size setting
  Future<void> updateFontSize(FontSize fontSize) async {
    try {
      await _settingsUseCase.updateSetting(
        settingName: 'fontSize',
        value: fontSize,
      );
      _currentFontSize = fontSize;
      notifyListeners();
    } catch (e) {
      // Handle error
      debugPrint('Failed to update font size: $e');
    }
  }

  /// Refresh font size settings (useful when settings change externally)
  Future<void> refreshFontSizeSettings() async {
    await _loadFontSizeSettings();
  }
}
