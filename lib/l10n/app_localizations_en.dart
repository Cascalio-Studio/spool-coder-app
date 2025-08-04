// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Spool Coder';

  @override
  String get home => 'Home';

  @override
  String get read => 'Read';

  @override
  String get write => 'Write';

  @override
  String get settings => 'Settings';

  @override
  String get profile => 'Profile';

  @override
  String get readRfidCard => 'Read RFID Card';

  @override
  String get holdCardNearReader => 'Hold your RFID card near the reader';

  @override
  String get writeRfidCard => 'Write RFID Card';

  @override
  String get writeDataToCard => 'Write data to your RFID card';

  @override
  String get general => 'General';

  @override
  String get appearance => 'Appearance';

  @override
  String get notifications => 'Notifications';

  @override
  String get security => 'Security';

  @override
  String get backup => 'Backup & Sync';

  @override
  String get about => 'About';

  @override
  String get language => 'Language';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get theme => 'Theme';

  @override
  String get system => 'System';

  @override
  String get light => 'Light';

  @override
  String get dark => 'Dark';

  @override
  String get fontSize => 'Font Size';

  @override
  String get small => 'Small';

  @override
  String get medium => 'Medium';

  @override
  String get large => 'Large';

  @override
  String get pushNotifications => 'Push Notifications';

  @override
  String get emailNotifications => 'Email Notifications';

  @override
  String get soundEnabled => 'Sound';

  @override
  String get vibrationEnabled => 'Vibration';

  @override
  String get biometricAuth => 'Biometric Authentication';

  @override
  String get appLock => 'App Lock';

  @override
  String get autoBackup => 'Auto Backup';

  @override
  String get cloudSync => 'Cloud Sync';

  @override
  String get version => 'Version';

  @override
  String get buildNumber => 'Build Number';

  @override
  String get english => 'English';

  @override
  String get german => 'German';

  @override
  String get french => 'French';

  @override
  String get spanish => 'Spanish';

  @override
  String get italian => 'Italian';

  @override
  String get scanFilamentSpool => 'Scan your filament spool to read data';

  @override
  String get programSpoolData => 'Program new data to your spool';

  @override
  String get manageAccount => 'Manage your account and preferences';

  @override
  String get readButtonLabel => 'READ';

  @override
  String get writeButtonLabel => 'WRITE';

  @override
  String get goodMorning => 'Good morning, Alex';

  @override
  String get lastReadStatus =>
      'Last read: PLA Blue (Prusament) • 3 spools managed';

  @override
  String get readyToScan => 'Ready to scan and program filament spools';

  @override
  String get spoolSelection => 'Spool Selection';

  @override
  String get recentSpools => 'Recent Spools';

  @override
  String get dateTimeFormat => 'Date & Time Format';

  @override
  String get region => 'Region';

  @override
  String get highContrastMode => 'High Contrast Mode';

  @override
  String get improvesTextVisibility => 'Improves text visibility';

  @override
  String get enableNotifications => 'Enable Notifications';

  @override
  String get receiveAppNotifications => 'Receive app notifications';

  @override
  String get notificationSound => 'Notification Sound';

  @override
  String get vibrateOnAlerts => 'Vibrate on alerts';

  @override
  String get twoFactorAuth => 'Two-Factor Authentication';

  @override
  String get addExtraSecurity => 'Add extra security to your account';

  @override
  String get useFingerprintFaceId => 'Use fingerprint or face ID';

  @override
  String get applicationInfo => 'Application Info';

  @override
  String get licenseInformation => 'License Information';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get aboutAppDescription =>
      'A Flutter app for reading and programming BambuLab filament spools.';

  @override
  String get advanced => 'Advanced';

  @override
  String get resetToDefaults => 'Reset to Defaults';

  @override
  String get resetAllSettingsToDefault =>
      'Reset all settings to default values';

  @override
  String get exportDiagnostics => 'Export Diagnostics';

  @override
  String get exportSettingsForDebugging => 'Export settings for debugging';

  @override
  String get account => 'Account';

  @override
  String get signOut => 'Sign Out';

  @override
  String get privacyPolicyComingSoon => 'Privacy Policy coming soon';

  @override
  String get signOutComingSoon => 'Sign out functionality coming soon';

  @override
  String kgRemaining(String amount) {
    return '$amount kg remaining';
  }

  @override
  String lastUsed(String date) {
    return 'Last used: $date';
  }

  @override
  String get today => 'Today';

  @override
  String daysAgo(String days) {
    return '$days days ago';
  }

  @override
  String get weekAgo => '1 week ago';

  @override
  String get failedToUpdateSetting => 'Failed to update setting';

  @override
  String get settingsResetToDefaults => 'Settings reset to defaults';

  @override
  String get cancel => 'Cancel';
}
