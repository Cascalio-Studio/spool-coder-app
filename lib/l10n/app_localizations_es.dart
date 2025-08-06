// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Spool Coder';

  @override
  String get home => 'Inicio';

  @override
  String get read => 'Leer';

  @override
  String get write => 'Escribir';

  @override
  String get settings => 'Configuración';

  @override
  String get profile => 'Perfil';

  @override
  String get readRfidCard => 'Leer tarjeta RFID';

  @override
  String get holdCardNearReader => 'Mantenga su tarjeta RFID cerca del lector';

  @override
  String get writeRfidCard => 'Escribir tarjeta RFID';

  @override
  String get writeDataToCard => 'Escribir datos en su tarjeta RFID';

  @override
  String get general => 'General';

  @override
  String get appearance => 'Apariencia';

  @override
  String get notifications => 'Notificaciones';

  @override
  String get security => 'Seguridad';

  @override
  String get backup => 'Copia de seguridad y sincronización';

  @override
  String get about => 'Acerca de';

  @override
  String get language => 'Idioma';

  @override
  String get selectLanguage => 'Seleccionar idioma';

  @override
  String get theme => 'Tema';

  @override
  String get system => 'Sistema';

  @override
  String get light => 'Claro';

  @override
  String get dark => 'Oscuro';

  @override
  String get fontSize => 'Tamaño de fuente';

  @override
  String get small => 'Pequeño';

  @override
  String get medium => 'Mediano';

  @override
  String get large => 'Grande';

  @override
  String get pushNotifications => 'Notificaciones push';

  @override
  String get emailNotifications => 'Notificaciones por correo';

  @override
  String get soundEnabled => 'Sonido';

  @override
  String get vibrationEnabled => 'Vibración';

  @override
  String get biometricAuth => 'Autenticación biométrica';

  @override
  String get appLock => 'Bloqueo de aplicación';

  @override
  String get autoBackup => 'Copia automática';

  @override
  String get cloudSync => 'Sincronización en la nube';

  @override
  String get version => 'Versión';

  @override
  String get buildNumber => 'Número de compilación';

  @override
  String get english => 'Inglés';

  @override
  String get german => 'Alemán';

  @override
  String get french => 'Francés';

  @override
  String get spanish => 'Español';

  @override
  String get italian => 'Italiano';

  @override
  String get scanFilamentSpool =>
      'Escanee su carrete de filamento para leer datos';

  @override
  String get programSpoolData => 'Programar nuevos datos en su carrete';

  @override
  String get manageAccount => 'Administre su cuenta y preferencias';

  @override
  String get readButtonLabel => 'LEER';

  @override
  String get writeButtonLabel => 'ESCRIBIR';

  @override
  String get goodMorning => 'Buenos días, Alex';

  @override
  String get lastReadStatus =>
      'Última lectura: PLA Azul (Prusament) • 3 carretes gestionados';

  @override
  String get readyToScan =>
      'Listo para escanear y programar carretes de filamento';

  @override
  String get spoolSelection => 'Selección de carrete';

  @override
  String get recentSpools => 'Carretes recientes';

  @override
  String get dateTimeFormat => 'Formato de fecha y hora';

  @override
  String get region => 'Región';

  @override
  String get highContrastMode => 'Modo alto contraste';

  @override
  String get improvesTextVisibility => 'Mejora la visibilidad del texto';

  @override
  String get enableNotifications => 'Habilitar notificaciones';

  @override
  String get receiveAppNotifications => 'Recibir notificaciones de la app';

  @override
  String get notificationSound => 'Sonido de notificación';

  @override
  String get vibrateOnAlerts => 'Vibrar en alertas';

  @override
  String get twoFactorAuth => 'Autenticación de dos factores';

  @override
  String get addExtraSecurity => 'Agregar seguridad extra a su cuenta';

  @override
  String get useFingerprintFaceId => 'Usar huella digital o Face ID';

  @override
  String get applicationInfo => 'Información de la aplicación';

  @override
  String get licenseInformation => 'Información de licencia';

  @override
  String get privacyPolicy => 'Política de privacidad';

  @override
  String get aboutAppDescription =>
      'Una aplicación Flutter para leer y programar bobinas de filamento BambuLab.';

  @override
  String get advanced => 'Avanzado';

  @override
  String get resetToDefaults => 'Restablecer predeterminados';

  @override
  String get resetAllSettingsToDefault =>
      'Restablecer todas las configuraciones a valores predeterminados';

  @override
  String get exportDiagnostics => 'Exportar diagnósticos';

  @override
  String get exportSettingsForDebugging =>
      'Exportar configuraciones para depuración';

  @override
  String get account => 'Cuenta';

  @override
  String get signOut => 'Cerrar sesión';

  @override
  String get privacyPolicyComingSoon => 'Política de privacidad próximamente';

  @override
  String get signOutComingSoon => 'Funcionalidad de cerrar sesión próximamente';

  @override
  String kgRemaining(String amount) {
    return '$amount kg restante';
  }

  @override
  String lastUsed(String date) {
    return 'Última vez usado: $date';
  }

  @override
  String get today => 'Hoy';

  @override
  String daysAgo(String days) {
    return 'hace $days días';
  }

  @override
  String get weekAgo => '1 week ago';

  @override
  String get failedToUpdateSetting => 'Error al actualizar configuración';

  @override
  String get settingsResetToDefaults =>
      'Configuraciones restablecidas por defecto';

  @override
  String get cancel => 'Cancelar';

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
