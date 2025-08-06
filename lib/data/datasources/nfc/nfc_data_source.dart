import '../../../domain/entities/nfc_scan_result.dart';

/// Modern NFC data source interface for real-time scanning
/// This replaces the old synchronous approach with reactive streams
abstract class NfcDataSource {
  /// Stream of scan results for reactive UI updates
  Stream<NfcScanResult> get scanResults;
  
  /// Check if NFC hardware is available on the device
  Future<bool> isNfcAvailable();
  
  /// Check if NFC is currently enabled in device settings
  Future<bool> isNfcEnabled();
  
  /// Start scanning for NFC tags with optional timeout
  Future<void> startScanning({Duration? timeout});
  
  /// Stop the current scanning session
  Future<void> stopScanning();
  
  /// Dispose of resources and clean up
  void dispose();
}
