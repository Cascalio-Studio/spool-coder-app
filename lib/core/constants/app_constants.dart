/// Core application constants
/// Shared across all layers
class AppConstants {
  static const String appName = 'Spool Coder';
  static const String appVersion = '0.1.0';
  
  // Spool data constants
  static const double defaultSpoolLength = 1000.0;
  static const double lowFilamentThreshold = 0.1; // 10%
  
  // Scan timeouts
  static const Duration nfcScanTimeout = Duration(seconds: 30);
  static const Duration usbScanTimeout = Duration(seconds: 10);
  static const Duration bluetoothScanTimeout = Duration(seconds: 15);
  
  // UI constants
  static const double defaultPadding = 16.0;
  static const double defaultBorderRadius = 8.0;
}