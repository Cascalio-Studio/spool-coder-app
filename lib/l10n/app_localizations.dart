import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_it.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('it')
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'Spool Coder'**
  String get appTitle;

  /// Home tab label
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// Read tab label
  ///
  /// In en, this message translates to:
  /// **'Read'**
  String get read;

  /// Write tab label
  ///
  /// In en, this message translates to:
  /// **'Write'**
  String get write;

  /// Settings tab label
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Profile tab label
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// Title for RFID reading screen
  ///
  /// In en, this message translates to:
  /// **'Read RFID Card'**
  String get readRfidCard;

  /// Instruction for RFID reading
  ///
  /// In en, this message translates to:
  /// **'Hold your RFID card near the reader'**
  String get holdCardNearReader;

  /// Title for RFID writing screen
  ///
  /// In en, this message translates to:
  /// **'Write RFID Card'**
  String get writeRfidCard;

  /// Instruction for RFID writing
  ///
  /// In en, this message translates to:
  /// **'Write data to your RFID card'**
  String get writeDataToCard;

  /// General settings section
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// Appearance settings section
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// Notifications settings section
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// Security settings section
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get security;

  /// Backup settings section
  ///
  /// In en, this message translates to:
  /// **'Backup & Sync'**
  String get backup;

  /// About setting
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// Language setting
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Language selection dialog title
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// Theme setting
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// System theme option
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// Light theme option
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// Dark theme option
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// Font size setting
  ///
  /// In en, this message translates to:
  /// **'Font Size'**
  String get fontSize;

  /// Small font size option
  ///
  /// In en, this message translates to:
  /// **'Small'**
  String get small;

  /// Medium font size option
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get medium;

  /// Large font size option
  ///
  /// In en, this message translates to:
  /// **'Large'**
  String get large;

  /// Push notifications setting
  ///
  /// In en, this message translates to:
  /// **'Push Notifications'**
  String get pushNotifications;

  /// Email notifications setting
  ///
  /// In en, this message translates to:
  /// **'Email Notifications'**
  String get emailNotifications;

  /// Sound setting
  ///
  /// In en, this message translates to:
  /// **'Sound'**
  String get soundEnabled;

  /// Vibration setting
  ///
  /// In en, this message translates to:
  /// **'Vibration'**
  String get vibrationEnabled;

  /// Biometric authentication setting
  ///
  /// In en, this message translates to:
  /// **'Biometric Authentication'**
  String get biometricAuth;

  /// App lock setting
  ///
  /// In en, this message translates to:
  /// **'App Lock'**
  String get appLock;

  /// Auto backup setting
  ///
  /// In en, this message translates to:
  /// **'Auto Backup'**
  String get autoBackup;

  /// Cloud sync setting
  ///
  /// In en, this message translates to:
  /// **'Cloud Sync'**
  String get cloudSync;

  /// App version setting
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// App build number label
  ///
  /// In en, this message translates to:
  /// **'Build Number'**
  String get buildNumber;

  /// English language option
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// German language option
  ///
  /// In en, this message translates to:
  /// **'German'**
  String get german;

  /// French language option
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get french;

  /// Spanish language option
  ///
  /// In en, this message translates to:
  /// **'Spanish'**
  String get spanish;

  /// Italian language option
  ///
  /// In en, this message translates to:
  /// **'Italian'**
  String get italian;

  /// Description for read card action
  ///
  /// In en, this message translates to:
  /// **'Scan your filament spool to read data'**
  String get scanFilamentSpool;

  /// Description for write card action
  ///
  /// In en, this message translates to:
  /// **'Program new data to your spool'**
  String get programSpoolData;

  /// Profile section description
  ///
  /// In en, this message translates to:
  /// **'Manage your account and preferences'**
  String get manageAccount;

  /// Read button label
  ///
  /// In en, this message translates to:
  /// **'READ'**
  String get readButtonLabel;

  /// Write button label
  ///
  /// In en, this message translates to:
  /// **'WRITE'**
  String get writeButtonLabel;

  /// Morning greeting message
  ///
  /// In en, this message translates to:
  /// **'Good morning, Alex'**
  String get goodMorning;

  /// Status showing last read information
  ///
  /// In en, this message translates to:
  /// **'Last read: PLA Blue (Prusament) • 3 spools managed'**
  String get lastReadStatus;

  /// Ready message for scanning
  ///
  /// In en, this message translates to:
  /// **'Ready to scan and program filament spools'**
  String get readyToScan;

  /// Spool selection section title
  ///
  /// In en, this message translates to:
  /// **'Spool Selection'**
  String get spoolSelection;

  /// Recent spools section title
  ///
  /// In en, this message translates to:
  /// **'Recent Spools'**
  String get recentSpools;

  /// Date and time format setting
  ///
  /// In en, this message translates to:
  /// **'Date & Time Format'**
  String get dateTimeFormat;

  /// Region setting
  ///
  /// In en, this message translates to:
  /// **'Region'**
  String get region;

  /// High contrast mode setting
  ///
  /// In en, this message translates to:
  /// **'High Contrast Mode'**
  String get highContrastMode;

  /// High contrast mode description
  ///
  /// In en, this message translates to:
  /// **'Improves text visibility'**
  String get improvesTextVisibility;

  /// Enable notifications setting
  ///
  /// In en, this message translates to:
  /// **'Enable Notifications'**
  String get enableNotifications;

  /// Enable notifications description
  ///
  /// In en, this message translates to:
  /// **'Receive app notifications'**
  String get receiveAppNotifications;

  /// Notification sound setting
  ///
  /// In en, this message translates to:
  /// **'Notification Sound'**
  String get notificationSound;

  /// Vibration setting description
  ///
  /// In en, this message translates to:
  /// **'Vibrate on alerts'**
  String get vibrateOnAlerts;

  /// Two-factor authentication setting
  ///
  /// In en, this message translates to:
  /// **'Two-Factor Authentication'**
  String get twoFactorAuth;

  /// Two-factor authentication description
  ///
  /// In en, this message translates to:
  /// **'Add extra security to your account'**
  String get addExtraSecurity;

  /// Biometric authentication description
  ///
  /// In en, this message translates to:
  /// **'Use fingerprint or face ID'**
  String get useFingerprintFaceId;

  /// Application info section header
  ///
  /// In en, this message translates to:
  /// **'Application Info'**
  String get applicationInfo;

  /// License information setting
  ///
  /// In en, this message translates to:
  /// **'License Information'**
  String get licenseInformation;

  /// Privacy policy setting
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// App description in about dialog
  ///
  /// In en, this message translates to:
  /// **'A Flutter app for reading and programming BambuLab filament spools.'**
  String get aboutAppDescription;

  /// Advanced settings section header
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get advanced;

  /// Reset settings title
  ///
  /// In en, this message translates to:
  /// **'Reset to Defaults'**
  String get resetToDefaults;

  /// Reset settings description
  ///
  /// In en, this message translates to:
  /// **'Reset all settings to default values'**
  String get resetAllSettingsToDefault;

  /// Export diagnostics title
  ///
  /// In en, this message translates to:
  /// **'Export Diagnostics'**
  String get exportDiagnostics;

  /// Export diagnostics description
  ///
  /// In en, this message translates to:
  /// **'Export settings for debugging'**
  String get exportSettingsForDebugging;

  /// Account section header
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// Sign out setting
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// Privacy policy placeholder message
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy coming soon'**
  String get privacyPolicyComingSoon;

  /// Sign out placeholder message
  ///
  /// In en, this message translates to:
  /// **'Sign out functionality coming soon'**
  String get signOutComingSoon;

  /// Amount of filament remaining on spool
  ///
  /// In en, this message translates to:
  /// **'{amount} kg remaining'**
  String kgRemaining(String amount);

  /// When the spool was last used
  ///
  /// In en, this message translates to:
  /// **'Last used: {date}'**
  String lastUsed(String date);

  /// Today date label
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// Days ago label
  ///
  /// In en, this message translates to:
  /// **'{days} days ago'**
  String daysAgo(String days);

  /// One week ago label
  ///
  /// In en, this message translates to:
  /// **'1 week ago'**
  String get weekAgo;

  /// Error message for failed setting update
  ///
  /// In en, this message translates to:
  /// **'Failed to update setting'**
  String get failedToUpdateSetting;

  /// Success message for settings reset
  ///
  /// In en, this message translates to:
  /// **'Settings reset to defaults'**
  String get settingsResetToDefaults;

  /// Cancel button text
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en', 'es', 'fr', 'it'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'it':
      return AppLocalizationsIt();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
