// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'Spool Coder';

  @override
  String get home => 'Home';

  @override
  String get read => 'Leggi';

  @override
  String get write => 'Scrivi';

  @override
  String get settings => 'Impostazioni';

  @override
  String get profile => 'Profilo';

  @override
  String get readRfidCard => 'Leggi carta RFID';

  @override
  String get holdCardNearReader => 'Tieni la tua carta RFID vicino al lettore';

  @override
  String get writeRfidCard => 'Scrivi carta RFID';

  @override
  String get writeDataToCard => 'Scrivi dati sulla tua carta RFID';

  @override
  String get general => 'Generale';

  @override
  String get appearance => 'Aspetto';

  @override
  String get notifications => 'Notifiche';

  @override
  String get security => 'Sicurezza';

  @override
  String get backup => 'Backup e sincronizzazione';

  @override
  String get about => 'Informazioni';

  @override
  String get language => 'Lingua';

  @override
  String get selectLanguage => 'Seleziona lingua';

  @override
  String get theme => 'Tema';

  @override
  String get system => 'Sistema';

  @override
  String get light => 'Chiaro';

  @override
  String get dark => 'Scuro';

  @override
  String get fontSize => 'Dimensione carattere';

  @override
  String get small => 'Piccolo';

  @override
  String get medium => 'Medio';

  @override
  String get large => 'Grande';

  @override
  String get pushNotifications => 'Notifiche push';

  @override
  String get emailNotifications => 'Notifiche email';

  @override
  String get soundEnabled => 'Suono';

  @override
  String get vibrationEnabled => 'Vibrazione';

  @override
  String get biometricAuth => 'Autenticazione biometrica';

  @override
  String get appLock => 'Blocco app';

  @override
  String get autoBackup => 'Backup automatico';

  @override
  String get cloudSync => 'Sincronizzazione cloud';

  @override
  String get version => 'Versione';

  @override
  String get buildNumber => 'Numero build';

  @override
  String get english => 'Inglese';

  @override
  String get german => 'Tedesco';

  @override
  String get french => 'Francese';

  @override
  String get spanish => 'Spagnolo';

  @override
  String get italian => 'Italiano';

  @override
  String get scanFilamentSpool =>
      'Scansiona la tua bobina di filamento per leggere i dati';

  @override
  String get programSpoolData => 'Programma nuovi dati sulla tua bobina';

  @override
  String get manageAccount => 'Gestisci il tuo account e le preferenze';

  @override
  String get readButtonLabel => 'LEGGI';

  @override
  String get writeButtonLabel => 'SCRIVI';

  @override
  String get goodMorning => 'Buongiorno, Alex';

  @override
  String get lastReadStatus =>
      'Ultima lettura: PLA Blu (Prusament) • 3 bobine gestite';

  @override
  String get readyToScan =>
      'Pronto a scansionare e programmare bobine di filamento';

  @override
  String get spoolSelection => 'Selezione bobina';

  @override
  String get recentSpools => 'Bobine recenti';

  @override
  String get dateTimeFormat => 'Formato data e ora';

  @override
  String get region => 'Regione';

  @override
  String get highContrastMode => 'Modalità alto contrasto';

  @override
  String get improvesTextVisibility => 'Migliora la visibilità del testo';

  @override
  String get enableNotifications => 'Abilita notifiche';

  @override
  String get receiveAppNotifications => 'Ricevi notifiche dell\'app';

  @override
  String get notificationSound => 'Suono notifica';

  @override
  String get vibrateOnAlerts => 'Vibra agli avvisi';

  @override
  String get twoFactorAuth => 'Autenticazione a due fattori';

  @override
  String get addExtraSecurity => 'Aggiungi sicurezza extra al tuo account';

  @override
  String get useFingerprintFaceId => 'Usa impronta digitale o Face ID';

  @override
  String get applicationInfo => 'Informazioni sull\'applicazione';

  @override
  String get licenseInformation => 'Informazioni sulla licenza';

  @override
  String get privacyPolicy => 'Informativa sulla privacy';

  @override
  String get aboutAppDescription =>
      'Un\'app Flutter per leggere e programmare le bobine di filamento BambuLab.';

  @override
  String get advanced => 'Avanzate';

  @override
  String get resetToDefaults => 'Ripristina predefiniti';

  @override
  String get resetAllSettingsToDefault =>
      'Ripristina tutte le impostazioni ai valori predefiniti';

  @override
  String get exportDiagnostics => 'Esporta diagnostiche';

  @override
  String get exportSettingsForDebugging => 'Esporta impostazioni per il debug';

  @override
  String get account => 'Account';

  @override
  String get signOut => 'Disconnetti';

  @override
  String get privacyPolicyComingSoon =>
      'Informativa sulla privacy prossimamente';

  @override
  String get signOutComingSoon =>
      'Funzionalità di disconnessione prossimamente';

  @override
  String kgRemaining(String amount) {
    return '$amount kg rimanenti';
  }

  @override
  String lastUsed(String date) {
    return 'Ultima volta usato: $date';
  }

  @override
  String get today => 'Oggi';

  @override
  String daysAgo(String days) {
    return '$days giorni fa';
  }

  @override
  String get weekAgo => 'una settimana fa';

  @override
  String get failedToUpdateSetting => 'Impossibile aggiornare l\'impostazione';

  @override
  String get settingsResetToDefaults =>
      'Impostazioni ripristinate ai valori predefiniti';

  @override
  String get cancel => 'Annulla';
}
