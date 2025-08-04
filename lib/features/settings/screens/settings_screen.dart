import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../../core/constants/app_constants.dart';
import '../../../domain/entities/user_settings.dart';
import '../../../domain/use_cases/settings_use_case.dart';
import '../../../theme/theme.dart';
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
  UserSettings? _settings;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _settingsUseCase = GetIt.instance<SettingsUseCase>();
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
    return Scaffold(
      backgroundColor: AppColors.pureWhite,
      appBar: AppBar(
        title: const Text('Settings'),
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
          const SettingsSectionHeader(title: 'General'),
          SettingsSection(
            children: [
              SettingsNavigationTile(
                leading: Icons.language,
                title: 'Language',
                subtitle: _getLanguageDisplayName(_settings!.language),
                onTap: () => _showLanguageSelector(),
              ),
              SettingsNavigationTile(
                leading: Icons.schedule,
                title: 'Date & Time Format',
                subtitle: _settings!.dateTimeFormat,
                onTap: () => _showDateTimeFormatSelector(),
              ),
              SettingsNavigationTile(
                leading: Icons.location_on,
                title: 'Region',
                subtitle: _settings!.regionSettings,
                onTap: () => _showRegionSelector(),
              ),
            ],
          ),

          // Appearance Settings
          const SettingsSectionHeader(title: 'Appearance'),
          SettingsSection(
            children: [
              SettingsNavigationTile(
                leading: Icons.palette,
                title: 'Theme',
                subtitle: _getThemeModeDisplayName(_settings!.themeMode),
                onTap: () => _showThemeSelector(),
              ),
              SettingsNavigationTile(
                leading: Icons.text_fields,
                title: 'Font Size',
                subtitle: _getFontSizeDisplayName(_settings!.fontSize),
                onTap: () => _showFontSizeSelector(),
              ),
              SettingsSwitch(
                leading: Icons.contrast,
                title: 'High Contrast Mode',
                subtitle: 'Improves text visibility',
                value: _settings!.highContrastMode,
                onChanged: (value) => _updateSetting('highContrastMode', value),
              ),
            ],
          ),

          // Notification Settings
          const SettingsSectionHeader(title: 'Notifications'),
          SettingsSection(
            children: [
              SettingsSwitch(
                leading: Icons.notifications,
                title: 'Enable Notifications',
                subtitle: 'Receive app notifications',
                value: _settings!.notificationsEnabled,
                onChanged: (value) => _updateSetting('notificationsEnabled', value),
              ),
              SettingsNavigationTile(
                leading: Icons.volume_up,
                title: 'Notification Sound',
                subtitle: _getNotificationSoundDisplayName(_settings!.notificationSound),
                onTap: () => _showNotificationSoundSelector(),
              ),
              SettingsSwitch(
                leading: Icons.vibration,
                title: 'Vibration',
                subtitle: 'Vibrate on alerts',
                value: _settings!.vibrationOnAlert,
                onChanged: (value) => _updateSetting('vibrationOnAlert', value),
              ),
            ],
          ),

          // Security Settings
          const SettingsSectionHeader(title: 'Security'),
          SettingsSection(
            children: [
              SettingsSwitch(
                leading: Icons.security,
                title: 'Two-Factor Authentication',
                subtitle: 'Add extra security to your account',
                value: _settings!.twoFactorAuthEnabled,
                onChanged: (value) => _updateSetting('twoFactorAuthEnabled', value),
              ),
              SettingsNavigationTile(
                leading: Icons.lock,
                title: 'App Lock',
                subtitle: _getAppLockTypeDisplayName(_settings!.appLockType),
                onTap: () => _showAppLockSelector(),
              ),
              SettingsSwitch(
                leading: Icons.fingerprint,
                title: 'Biometric Authentication',
                subtitle: 'Use fingerprint or face ID',
                value: _settings!.biometricEnabled,
                onChanged: (value) => _updateSetting('biometricEnabled', value),
              ),
            ],
          ),

          // Application Info
          const SettingsSectionHeader(title: 'Application Info'),
          SettingsSection(
            children: [
              SettingsTile(
                leading: Icons.info,
                title: 'Version',
                subtitle: AppConstants.appVersion,
              ),
              SettingsNavigationTile(
                leading: Icons.description,
                title: 'License Information',
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
                title: 'Privacy Policy',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Privacy Policy coming soon')),
                  );
                },
              ),
              SettingsNavigationTile(
                leading: Icons.help,
                title: 'About',
                onTap: () {
                  showAboutDialog(
                    context: context,
                    applicationName: AppConstants.appName,
                    applicationVersion: AppConstants.appVersion,
                    children: [
                      const Text('A Flutter app for reading and programming BambuLab filament spools.'),
                    ],
                  );
                },
              ),
            ],
          ),

          // Advanced Settings
          const SettingsSectionHeader(title: 'Advanced'),
          SettingsSection(
            children: [
              SettingsNavigationTile(
                leading: Icons.restore,
                title: 'Reset to Defaults',
                subtitle: 'Reset all settings to default values',
                onTap: _resetSettings,
              ),
              SettingsNavigationTile(
                leading: Icons.bug_report,
                title: 'Export Diagnostics',
                subtitle: 'Export settings for debugging',
                onTap: _exportDiagnostics,
              ),
            ],
          ),

          // Account Actions
          const SettingsSectionHeader(title: 'Account'),
          SettingsSection(
            children: [
              SettingsTile(
                title: 'Sign Out',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Sign out functionality coming soon')),
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
    switch (language) {
      case 'en':
        return 'English';
      case 'de':
        return 'Deutsch';
      case 'fr':
        return 'Français';
      case 'es':
        return 'Español';
      case 'it':
        return 'Italiano';
      case 'ja':
        return '日本語';
      case 'ko':
        return '한국어';
      case 'zh':
        return '中文';
      default:
        return language;
    }
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

  // Selector dialogs (simplified implementations)
  void _showLanguageSelector() {
    // TODO: Implement language selector
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Language selector coming soon')),
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
