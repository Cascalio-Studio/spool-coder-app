// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Spool Coder';

  @override
  String get home => 'Accueil';

  @override
  String get read => 'Lire';

  @override
  String get write => 'Écrire';

  @override
  String get settings => 'Paramètres';

  @override
  String get profile => 'Profil';

  @override
  String get readRfidCard => 'Lire la carte RFID';

  @override
  String get holdCardNearReader => 'Tenez votre carte RFID près du lecteur';

  @override
  String get writeRfidCard => 'Écrire la carte RFID';

  @override
  String get writeDataToCard => 'Écrire des données sur votre carte RFID';

  @override
  String get general => 'Général';

  @override
  String get appearance => 'Apparence';

  @override
  String get notifications => 'Notifications';

  @override
  String get security => 'Sécurité';

  @override
  String get backup => 'Sauvegarde et synchronisation';

  @override
  String get about => 'À propos';

  @override
  String get language => 'Langue';

  @override
  String get selectLanguage => 'Sélectionner la langue';

  @override
  String get theme => 'Thème';

  @override
  String get system => 'Système';

  @override
  String get light => 'Clair';

  @override
  String get dark => 'Sombre';

  @override
  String get fontSize => 'Taille de police';

  @override
  String get small => 'Petit';

  @override
  String get medium => 'Moyen';

  @override
  String get large => 'Grand';

  @override
  String get pushNotifications => 'Notifications push';

  @override
  String get emailNotifications => 'Notifications par e-mail';

  @override
  String get soundEnabled => 'Son';

  @override
  String get vibrationEnabled => 'Vibration';

  @override
  String get biometricAuth => 'Authentification biométrique';

  @override
  String get appLock => 'Verrouillage de l\'application';

  @override
  String get autoBackup => 'Sauvegarde automatique';

  @override
  String get cloudSync => 'Synchronisation cloud';

  @override
  String get version => 'Version';

  @override
  String get buildNumber => 'Numéro de build';

  @override
  String get english => 'Anglais';

  @override
  String get german => 'Allemand';

  @override
  String get french => 'Français';

  @override
  String get spanish => 'Espagnol';

  @override
  String get italian => 'Italien';

  @override
  String get scanFilamentSpool =>
      'Scannez votre bobine de filament pour lire les données';

  @override
  String get programSpoolData =>
      'Programmer de nouvelles données sur votre bobine';

  @override
  String get manageAccount => 'Gérez votre compte et vos préférences';

  @override
  String get readButtonLabel => 'LIRE';

  @override
  String get writeButtonLabel => 'ÉCRIRE';

  @override
  String get goodMorning => 'Bonjour, Alex';

  @override
  String get lastReadStatus =>
      'Dernière lecture: PLA Bleu (Prusament) • 3 bobines gérées';

  @override
  String get readyToScan =>
      'Prêt à scanner et programmer les bobines de filament';

  @override
  String get spoolSelection => 'Sélection de bobine';

  @override
  String get recentSpools => 'Bobines récentes';

  @override
  String get dateTimeFormat => 'Format de date et heure';

  @override
  String get region => 'Région';

  @override
  String get highContrastMode => 'Mode haut contraste';

  @override
  String get improvesTextVisibility => 'Améliore la visibilité du texte';

  @override
  String get enableNotifications => 'Activer les notifications';

  @override
  String get receiveAppNotifications => 'Recevoir les notifications de l\'app';

  @override
  String get notificationSound => 'Son de notification';

  @override
  String get vibrateOnAlerts => 'Vibrer lors des alertes';

  @override
  String get twoFactorAuth => 'Authentification à deux facteurs';

  @override
  String get addExtraSecurity =>
      'Ajouter une sécurité supplémentaire à votre compte';

  @override
  String get useFingerprintFaceId =>
      'Utiliser l\'empreinte digitale ou Face ID';

  @override
  String get applicationInfo => 'Informations sur l\'application';

  @override
  String get licenseInformation => 'Informations de licence';

  @override
  String get privacyPolicy => 'Politique de confidentialité';

  @override
  String get aboutAppDescription =>
      'Une application Flutter pour lire et programmer les bobines de filament BambuLab.';

  @override
  String get advanced => 'Avancé';

  @override
  String get resetToDefaults => 'Remettre par défaut';

  @override
  String get resetAllSettingsToDefault =>
      'Remettre tous les paramètres aux valeurs par défaut';

  @override
  String get exportDiagnostics => 'Exporter les diagnostics';

  @override
  String get exportSettingsForDebugging =>
      'Exporter les paramètres pour le débogage';

  @override
  String get account => 'Compte';

  @override
  String get signOut => 'Se déconnecter';

  @override
  String get privacyPolicyComingSoon =>
      'Politique de confidentialité bientôt disponible';

  @override
  String get signOutComingSoon =>
      'Fonctionnalité de déconnexion bientôt disponible';

  @override
  String kgRemaining(String amount) {
    return '$amount kg restant';
  }

  @override
  String lastUsed(String date) {
    return 'Dernière utilisation : $date';
  }

  @override
  String get today => 'Aujourd\'hui';

  @override
  String daysAgo(String days) {
    return 'il y a $days jours';
  }

  @override
  String get weekAgo => '1 week ago';

  @override
  String get failedToUpdateSetting => 'Échec de la mise à jour du paramètre';

  @override
  String get settingsResetToDefaults => 'Paramètres remis par défaut';

  @override
  String get cancel => 'Annuler';

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
