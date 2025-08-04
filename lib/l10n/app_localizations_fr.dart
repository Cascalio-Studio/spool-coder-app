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
}
