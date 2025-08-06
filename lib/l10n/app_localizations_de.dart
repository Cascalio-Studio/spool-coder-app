// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Spool Coder';

  @override
  String get home => 'Startseite';

  @override
  String get read => 'Lesen';

  @override
  String get write => 'Schreiben';

  @override
  String get settings => 'Einstellungen';

  @override
  String get profile => 'Profil';

  @override
  String get readRfidCard => 'RFID-Karte lesen';

  @override
  String get holdCardNearReader =>
      'Halten Sie Ihre RFID-Karte in die Nähe des Lesegeräts';

  @override
  String get writeRfidCard => 'RFID-Karte schreiben';

  @override
  String get writeDataToCard => 'Daten auf Ihre RFID-Karte schreiben';

  @override
  String get general => 'Allgemein';

  @override
  String get appearance => 'Erscheinungsbild';

  @override
  String get notifications => 'Benachrichtigungen';

  @override
  String get security => 'Sicherheit';

  @override
  String get backup => 'Sicherung & Synchronisation';

  @override
  String get about => 'Über';

  @override
  String get language => 'Sprache';

  @override
  String get selectLanguage => 'Sprache auswählen';

  @override
  String get theme => 'Theme';

  @override
  String get system => 'System';

  @override
  String get light => 'Hell';

  @override
  String get dark => 'Dunkel';

  @override
  String get fontSize => 'Schriftgröße';

  @override
  String get small => 'Klein';

  @override
  String get medium => 'Mittel';

  @override
  String get large => 'Groß';

  @override
  String get pushNotifications => 'Push-Benachrichtigungen';

  @override
  String get emailNotifications => 'E-Mail-Benachrichtigungen';

  @override
  String get soundEnabled => 'Ton';

  @override
  String get vibrationEnabled => 'Vibration';

  @override
  String get biometricAuth => 'Biometrische Authentifizierung';

  @override
  String get appLock => 'App-Sperre';

  @override
  String get autoBackup => 'Automatische Sicherung';

  @override
  String get cloudSync => 'Cloud-Synchronisation';

  @override
  String get version => 'Version';

  @override
  String get buildNumber => 'Build-Nummer';

  @override
  String get english => 'Englisch';

  @override
  String get german => 'Deutsch';

  @override
  String get french => 'Französisch';

  @override
  String get spanish => 'Spanisch';

  @override
  String get italian => 'Italienisch';

  @override
  String get scanFilamentSpool =>
      'Scannen Sie Ihre Filamentspule, um Daten zu lesen';

  @override
  String get programSpoolData => 'Neue Daten auf Ihre Spule programmieren';

  @override
  String get manageAccount => 'Verwalten Sie Ihr Konto und Ihre Einstellungen';

  @override
  String get readButtonLabel => 'LESEN';

  @override
  String get writeButtonLabel => 'SCHREIBEN';

  @override
  String get goodMorning => 'Guten Morgen, Alex';

  @override
  String get lastReadStatus =>
      'Zuletzt gelesen: PLA Blau (Prusament) • 3 Spulen verwaltet';

  @override
  String get readyToScan =>
      'Bereit zum Scannen und Programmieren von Filamentspulen';

  @override
  String get spoolSelection => 'Spulenauswahl';

  @override
  String get recentSpools => 'Kürzlich verwendete Spulen';

  @override
  String get dateTimeFormat => 'Datums- & Zeitformat';

  @override
  String get region => 'Region';

  @override
  String get highContrastMode => 'Hoher Kontrast Modus';

  @override
  String get improvesTextVisibility => 'Verbessert die Textsichtbarkeit';

  @override
  String get enableNotifications => 'Benachrichtigungen aktivieren';

  @override
  String get receiveAppNotifications => 'App-Benachrichtigungen erhalten';

  @override
  String get notificationSound => 'Benachrichtigungston';

  @override
  String get vibrateOnAlerts => 'Bei Warnungen vibrieren';

  @override
  String get twoFactorAuth => 'Zwei-Faktor-Authentifizierung';

  @override
  String get addExtraSecurity => 'Zusätzliche Sicherheit für Ihr Konto';

  @override
  String get useFingerprintFaceId => 'Fingerabdruck oder Face ID verwenden';

  @override
  String get applicationInfo => 'Anwendungsinformationen';

  @override
  String get licenseInformation => 'Lizenzinformationen';

  @override
  String get privacyPolicy => 'Datenschutzrichtlinie';

  @override
  String get aboutAppDescription =>
      'Eine Flutter-App zum Lesen und Programmieren von BambuLab-Filamentspulen.';

  @override
  String get advanced => 'Erweitert';

  @override
  String get resetToDefaults => 'Auf Standard zurücksetzen';

  @override
  String get resetAllSettingsToDefault =>
      'Alle Einstellungen auf Standardwerte zurücksetzen';

  @override
  String get exportDiagnostics => 'Diagnose exportieren';

  @override
  String get exportSettingsForDebugging =>
      'Einstellungen für Debugging exportieren';

  @override
  String get account => 'Konto';

  @override
  String get signOut => 'Abmelden';

  @override
  String get privacyPolicyComingSoon => 'Datenschutzrichtlinie kommt bald';

  @override
  String get signOutComingSoon => 'Abmeldefunktion kommt bald';

  @override
  String kgRemaining(String amount) {
    return '$amount kg verbleibend';
  }

  @override
  String lastUsed(String date) {
    return 'Zuletzt verwendet: $date';
  }

  @override
  String get today => 'Heute';

  @override
  String daysAgo(String days) {
    return 'vor $days Tagen';
  }

  @override
  String get weekAgo => '1 week ago';

  @override
  String get failedToUpdateSetting =>
      'Einstellung konnte nicht aktualisiert werden';

  @override
  String get settingsResetToDefaults =>
      'Einstellungen auf Standard zurückgesetzt';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get tapScanButtonToStart =>
      'Tap the scan button to start reading your NFC spool';

  @override
  String get scanSuccessful => 'Scan Successful!';

  @override
  String get scanFailed => 'Scan Failed';

  @override
  String get nfcReady => 'NFC Ready';

  @override
  String get scanning => 'Scanning...';

  @override
  String get scanComplete => 'Scan Complete';

  @override
  String get scanError => 'Scan Error';

  @override
  String get startScan => 'START SCAN';

  @override
  String get scanAgain => 'SCAN AGAIN';
}
