/// User settings entity - pure business logic object
/// Contains all user preferences and app configuration
class UserSettings {
  // General settings
  final String language;
  final String dateTimeFormat;
  final String regionSettings;

  // Appearance settings
  final AppThemeMode themeMode;
  final FontSize fontSize;
  final bool highContrastMode;

  // Notification settings
  final bool notificationsEnabled;
  final NotificationSound notificationSound;
  final bool vibrationOnAlert;

  // Account settings
  final String? userDisplayName;
  final String? userEmail;

  // Security settings
  final bool twoFactorAuthEnabled;
  final AppLockType appLockType;
  final bool biometricEnabled;

  // Advanced settings
  final bool diagnosticsEnabled;

  const UserSettings({
    this.language = 'en',
    this.dateTimeFormat = 'MM/dd/yyyy',
    this.regionSettings = 'US',
    this.themeMode = AppThemeMode.system,
    this.fontSize = FontSize.medium,
    this.highContrastMode = false,
    this.notificationsEnabled = true,
    this.notificationSound = NotificationSound.defaultSound,
    this.vibrationOnAlert = true,
    this.userDisplayName,
    this.userEmail,
    this.twoFactorAuthEnabled = false,
    this.appLockType = AppLockType.none,
    this.biometricEnabled = false,
    this.diagnosticsEnabled = false,
  });

  /// Create a copy of the settings with updated values
  UserSettings copyWith({
    String? language,
    String? dateTimeFormat,
    String? regionSettings,
    AppThemeMode? themeMode,
    FontSize? fontSize,
    bool? highContrastMode,
    bool? notificationsEnabled,
    NotificationSound? notificationSound,
    bool? vibrationOnAlert,
    String? userDisplayName,
    String? userEmail,
    bool? twoFactorAuthEnabled,
    AppLockType? appLockType,
    bool? biometricEnabled,
    bool? diagnosticsEnabled,
  }) {
    return UserSettings(
      language: language ?? this.language,
      dateTimeFormat: dateTimeFormat ?? this.dateTimeFormat,
      regionSettings: regionSettings ?? this.regionSettings,
      themeMode: themeMode ?? this.themeMode,
      fontSize: fontSize ?? this.fontSize,
      highContrastMode: highContrastMode ?? this.highContrastMode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      notificationSound: notificationSound ?? this.notificationSound,
      vibrationOnAlert: vibrationOnAlert ?? this.vibrationOnAlert,
      userDisplayName: userDisplayName ?? this.userDisplayName,
      userEmail: userEmail ?? this.userEmail,
      twoFactorAuthEnabled: twoFactorAuthEnabled ?? this.twoFactorAuthEnabled,
      appLockType: appLockType ?? this.appLockType,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      diagnosticsEnabled: diagnosticsEnabled ?? this.diagnosticsEnabled,
    );
  }

  /// Convert to Map for storage
  Map<String, dynamic> toMap() {
    return {
      'language': language,
      'dateTimeFormat': dateTimeFormat,
      'regionSettings': regionSettings,
      'themeMode': themeMode.index,
      'fontSize': fontSize.index,
      'highContrastMode': highContrastMode,
      'notificationsEnabled': notificationsEnabled,
      'notificationSound': notificationSound.index,
      'vibrationOnAlert': vibrationOnAlert,
      'userDisplayName': userDisplayName,
      'userEmail': userEmail,
      'twoFactorAuthEnabled': twoFactorAuthEnabled,
      'appLockType': appLockType.index,
      'biometricEnabled': biometricEnabled,
      'diagnosticsEnabled': diagnosticsEnabled,
    };
  }

  /// Create from Map for loading from storage
  factory UserSettings.fromMap(Map<String, dynamic> map) {
    return UserSettings(
      language: map['language'] ?? 'en',
      dateTimeFormat: map['dateTimeFormat'] ?? 'MM/dd/yyyy',
      regionSettings: map['regionSettings'] ?? 'US',
      themeMode: AppThemeMode.values[map['themeMode'] ?? 0],
      fontSize: FontSize.values[map['fontSize'] ?? 1],
      highContrastMode: map['highContrastMode'] ?? false,
      notificationsEnabled: map['notificationsEnabled'] ?? true,
      notificationSound: NotificationSound.values[map['notificationSound'] ?? 0],
      vibrationOnAlert: map['vibrationOnAlert'] ?? true,
      userDisplayName: map['userDisplayName'],
      userEmail: map['userEmail'],
      twoFactorAuthEnabled: map['twoFactorAuthEnabled'] ?? false,
      appLockType: AppLockType.values[map['appLockType'] ?? 0],
      biometricEnabled: map['biometricEnabled'] ?? false,
      diagnosticsEnabled: map['diagnosticsEnabled'] ?? false,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserSettings &&
        other.language == language &&
        other.dateTimeFormat == dateTimeFormat &&
        other.regionSettings == regionSettings &&
        other.themeMode == themeMode &&
        other.fontSize == fontSize &&
        other.highContrastMode == highContrastMode &&
        other.notificationsEnabled == notificationsEnabled &&
        other.notificationSound == notificationSound &&
        other.vibrationOnAlert == vibrationOnAlert &&
        other.userDisplayName == userDisplayName &&
        other.userEmail == userEmail &&
        other.twoFactorAuthEnabled == twoFactorAuthEnabled &&
        other.appLockType == appLockType &&
        other.biometricEnabled == biometricEnabled &&
        other.diagnosticsEnabled == diagnosticsEnabled;
  }

  @override
  int get hashCode {
    return Object.hash(
      language,
      dateTimeFormat,
      regionSettings,
      themeMode,
      fontSize,
      highContrastMode,
      notificationsEnabled,
      notificationSound,
      vibrationOnAlert,
      userDisplayName,
      userEmail,
      twoFactorAuthEnabled,
      appLockType,
      biometricEnabled,
      diagnosticsEnabled,
    );
  }
}

/// Theme mode options
enum AppThemeMode { light, dark, system }

/// Font size options
enum FontSize { small, medium, large }

/// Notification sound options
enum NotificationSound { defaultSound, chime, bell, none }

/// App lock type options
enum AppLockType { none, pin, biometric }
