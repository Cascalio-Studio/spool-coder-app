import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/providers/app_locale_provider.dart';
import '../../../domain/entities/user_settings.dart';
import '../../../domain/use_cases/settings_use_case.dart';
import '../../../theme/theme.dart';
import '../../../l10n/app_localizations.dart';
import '../widgets/settings_widgets.dart';

/// Main settings screen with all user preferences
/// Implements the design concept with sections and modern UI
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final SettingsUseCase _settingsUseCase;
  late final AppLocaleProvider _localeProvider;
  UserSettings? _settings;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _settingsUseCase = GetIt.instance<SettingsUseCase>();
    _localeProvider = GetIt.instance<AppLocaleProvider>();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final settings = await _settingsUseCase.getSettings();
      setState(() {
        _settings = settings;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _settings = const UserSettings();
        _isLoading = false;
      });
    }
  }

  Future<void> _updateSetting<T>(String settingName, T value) async {
    if (_settings == null) return;

    try {
      await _settingsUseCase.updateSetting(
        settingName: settingName,
        value: value,
      );
      await _loadSettings(); // Reload to update UI
    } catch (e) {
      // Show error snackbar
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update setting: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _resetSettings() async {
    final confirmed = await _showResetConfirmation();
    if (!confirmed) return;

    try {
      await _settingsUseCase.resetToDefaults();
      await _loadSettings();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Settings reset to defaults'),
            backgroundColor: AppColors.accentGreen,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to reset settings: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<bool> _showResetConfirmation() async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Settings'),
        content: const Text('Are you sure you want to reset all settings to default values? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Reset'),
          ),
        ],
      ),
    ) ?? false;
  }

  Future<void> _exportDiagnostics() async {
    try {
      final exportData = await _settingsUseCase.exportSettings();
      
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Settings Export'),
            content: SingleChildScrollView(
              child: SelectableText(
                exportData,
                style: const TextStyle(fontFamily: 'monospace'),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to export settings: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      backgroundColor: AppColors.pureWhite,
      appBar: AppBar(
        title: Text(l10n.settings),
        backgroundColor: AppColors.pureWhite,
        foregroundColor: AppColors.primaryBlack,
        elevation: 0,
        surfaceTintColor: AppColors.pureWhite,
      ),
      body: _isLoading 
          ? const Center(child: CircularProgressIndicator())
          : _buildSettingsContent(),
    );
  }

  Widget _buildSettingsContent() {
    final l10n = AppLocalizations.of(context)!;
    
    if (_settings == null) {
      return const Center(
        child: Text('Failed to load settings'),
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Header
          ProfileHeader(
            userName: _settings!.userDisplayName ?? 'User',
            userEmail: _settings!.userEmail,
            onEditProfile: () {
              // TODO: Navigate to profile edit screen
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profile editing coming soon')),
              );
            },
          ),

          // General Settings
          SettingsSectionHeader(title: l10n.general),
          SettingsSection(
            children: [
              SettingsNavigationTile(
                leading: Icons.language,
                title: l10n.language,
                subtitle: _getLanguageDisplayName(_settings!.language),
                onTap: () => _showLanguageSelector(),
              ),
              SettingsNavigationTile(
                leading: Icons.schedule,
                title: l10n.dateTimeFormat,
                subtitle: _settings!.dateTimeFormat,
                onTap: () => _showDateTimeFormatSelector(),
              ),
              SettingsNavigationTile(
                leading: Icons.location_on,
                title: l10n.region,
                subtitle: _settings!.regionSettings,
                onTap: () => _showRegionSelector(),
              ),
            ],
          ),

          // Appearance Settings
          SettingsSectionHeader(title: l10n.appearance),
          SettingsSection(
            children: [
              SettingsNavigationTile(
                leading: Icons.palette,
                title: l10n.theme,
                subtitle: _getThemeModeDisplayName(_settings!.themeMode),
                onTap: () => _showThemeSelector(),
              ),
              SettingsNavigationTile(
                leading: Icons.text_fields,
                title: l10n.fontSize,
                subtitle: _getFontSizeDisplayName(_settings!.fontSize),
                onTap: () => _showFontSizeSelector(),
              ),
              SettingsSwitch(
                leading: Icons.contrast,
                title: l10n.highContrastMode,
                subtitle: l10n.improvesTextVisibility,
                value: _settings!.highContrastMode,
                onChanged: (value) => _updateSetting('highContrastMode', value),
              ),
            ],
          ),

          // Notification Settings
          SettingsSectionHeader(title: l10n.notifications),
          SettingsSection(
            children: [
              SettingsSwitch(
                leading: Icons.notifications,
                title: l10n.enableNotifications,
                subtitle: l10n.receiveAppNotifications,
                value: _settings!.notificationsEnabled,
                onChanged: (value) => _updateSetting('notificationsEnabled', value),
              ),
              SettingsNavigationTile(
                leading: Icons.volume_up,
                title: l10n.notificationSound,
                subtitle: _getNotificationSoundDisplayName(_settings!.notificationSound),
                onTap: () => _showNotificationSoundSelector(),
              ),
              SettingsSwitch(
                leading: Icons.vibration,
                title: l10n.vibrationEnabled,
                subtitle: l10n.vibrateOnAlerts,
                value: _settings!.vibrationOnAlert,
                onChanged: (value) => _updateSetting('vibrationOnAlert', value),
              ),
            ],
          ),

          // Security Settings
          SettingsSectionHeader(title: l10n.security),
          SettingsSection(
            children: [
              SettingsSwitch(
                leading: Icons.security,
                title: l10n.twoFactorAuth,
                subtitle: l10n.addExtraSecurity,
                value: _settings!.twoFactorAuthEnabled,
                onChanged: (value) => _updateSetting('twoFactorAuthEnabled', value),
              ),
              SettingsNavigationTile(
                leading: Icons.lock,
                title: l10n.appLock,
                subtitle: _getAppLockTypeDisplayName(_settings!.appLockType),
                onTap: () => _showAppLockSelector(),
              ),
              SettingsSwitch(
                leading: Icons.fingerprint,
                title: l10n.biometricAuth,
                subtitle: l10n.useFingerprintFaceId,
                value: _settings!.biometricEnabled,
                onChanged: (value) => _updateSetting('biometricEnabled', value),
              ),
            ],
          ),

          // Application Info
          SettingsSectionHeader(title: l10n.applicationInfo),
          SettingsSection(
            children: [
              SettingsTile(
                leading: Icons.info,
                title: l10n.version,
                subtitle: AppConstants.appVersion,
              ),
              SettingsNavigationTile(
                leading: Icons.description,
                title: l10n.licenseInformation,
                onTap: () {
                  showLicensePage(
                    context: context,
                    applicationName: AppConstants.appName,
                    applicationVersion: AppConstants.appVersion,
                  );
                },
              ),
              SettingsNavigationTile(
                leading: Icons.privacy_tip,
                title: l10n.privacyPolicy,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.privacyPolicyComingSoon)),
                  );
                },
              ),
              SettingsNavigationTile(
                leading: Icons.help,
                title: l10n.about,
                onTap: () {
                  showAboutDialog(
                    context: context,
                    applicationName: AppConstants.appName,
                    applicationVersion: AppConstants.appVersion,
                    children: [
                      Text(l10n.aboutAppDescription),
                    ],
                  );
                },
              ),
            ],
          ),

          // Advanced Settings
          SettingsSectionHeader(title: l10n.advanced),
          SettingsSection(
            children: [
              SettingsNavigationTile(
                leading: Icons.restore,
                title: l10n.resetToDefaults,
                subtitle: l10n.resetAllSettingsToDefault,
                onTap: _resetSettings,
              ),
              SettingsNavigationTile(
                leading: Icons.bug_report,
                title: l10n.exportDiagnostics,
                subtitle: l10n.exportSettingsForDebugging,
                onTap: _exportDiagnostics,
              ),
            ],
          ),

          // Account Actions
          SettingsSectionHeader(title: l10n.account),
          SettingsSection(
            children: [
              SettingsTile(
                title: l10n.signOut,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.signOutComingSoon)),
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  // Helper methods for display names
  String _getLanguageDisplayName(String language) {
    // Convert language name to code if needed
    final languageCode = AppLocaleProvider.getLanguageCodeFromName(language);
    return AppLocaleProvider.languageNames[languageCode] ?? language;
  }

  String _getThemeModeDisplayName(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.light:
        return 'Light';
      case AppThemeMode.dark:
        return 'Dark';
      case AppThemeMode.system:
        return 'System Default';
    }
  }

  String _getFontSizeDisplayName(FontSize size) {
    switch (size) {
      case FontSize.small:
        return 'Small';
      case FontSize.medium:
        return 'Medium';
      case FontSize.large:
        return 'Large';
    }
  }

  String _getNotificationSoundDisplayName(NotificationSound sound) {
    switch (sound) {
      case NotificationSound.defaultSound:
        return 'Default';
      case NotificationSound.chime:
        return 'Chime';
      case NotificationSound.bell:
        return 'Bell';
      case NotificationSound.none:
        return 'None';
    }
  }

  String _getAppLockTypeDisplayName(AppLockType type) {
    switch (type) {
      case AppLockType.none:
        return 'None';
      case AppLockType.pin:
        return 'PIN';
      case AppLockType.biometric:
        return 'Biometric';
    }
  }

  // Selector dialogs
  void _showLanguageSelector() {
    final l10n = AppLocalizations.of(context)!;
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(l10n.selectLanguage),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: AppLocaleProvider.supportedLocales.map((locale) {
              final languageName = AppLocaleProvider.languageNames[locale.languageCode] ?? 'Unknown';
              final isSelected = _localeProvider.currentLocale.languageCode == locale.languageCode;
              
              return ListTile(
                title: Text(languageName),
                leading: isSelected 
                  ? const Icon(Icons.check_circle, color: AppColors.accentGreen)
                  : const Icon(Icons.radio_button_unchecked),
                onTap: () async {
                  await _localeProvider.changeLanguage(languageName);
                  Navigator.of(context).pop();
                  // Reload settings to reflect the change
                  _loadSettings();
                },
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _showDateTimeFormatSelector() {
    // TODO: Implement date/time format selector
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Date/time format selector coming soon')),
    );
  }

  void _showRegionSelector() {
    // TODO: Implement region selector
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Region selector coming soon')),
    );
  }

  void _showThemeSelector() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: AppThemeMode.values.map((mode) {
            return RadioListTile<AppThemeMode>(
              title: Text(_getThemeModeDisplayName(mode)),
              value: mode,
              groupValue: _settings!.themeMode,
              onChanged: (value) {
                if (value != null) {
                  _updateSetting('themeMode', value);
                  Navigator.of(context).pop();
                }
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showFontSizeSelector() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Font Size'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: FontSize.values.map((size) {
            return RadioListTile<FontSize>(
              title: Text(_getFontSizeDisplayName(size)),
              value: size,
              groupValue: _settings!.fontSize,
              onChanged: (value) {
                if (value != null) {
                  _updateSetting('fontSize', value);
                  Navigator.of(context).pop();
                }
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showNotificationSoundSelector() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Notification Sound'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: NotificationSound.values.map((sound) {
            return RadioListTile<NotificationSound>(
              title: Text(_getNotificationSoundDisplayName(sound)),
              value: sound,
              groupValue: _settings!.notificationSound,
              onChanged: (value) {
                if (value != null) {
                  _updateSetting('notificationSound', value);
                  Navigator.of(context).pop();
                }
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showAppLockSelector() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose App Lock'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: AppLockType.values.map((type) {
            return RadioListTile<AppLockType>(
              title: Text(_getAppLockTypeDisplayName(type)),
              value: type,
              groupValue: _settings!.appLockType,
              onChanged: (value) {
                if (value != null) {
                  _updateSetting('appLockType', value);
                  Navigator.of(context).pop();
                }
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
