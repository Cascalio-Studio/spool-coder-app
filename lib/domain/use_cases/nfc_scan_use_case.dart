import '../entities/spool.dart';
import '../value_objects/rfid_data.dart';

/// Enumeration for NFC scan states
enum NfcScanState {
  idle,
  scanning,
  found,
  reading,
  success,
  error,
}

/// Use case for NFC scanning operations
/// Part of the Domain Layer: defines business operations for NFC scanning
abstract class NfcScanUseCase {
  /// Start scanning for NFC tags
  Future<void> startScanning();
  
  /// Stop scanning for NFC tags
  Future<void> stopScanning();
  
  /// Check if NFC is available on the device
  Future<bool> isNfcAvailable();
  
  /// Check if NFC is enabled
  Future<bool> isNfcEnabled();
  
  /// Request NFC permissions
  Future<bool> requestNfcPermissions();
  
  /// Read RFID data from detected tag
  Future<RfidData> readRfidTag();
  
  /// Create spool from scanned RFID data
  Future<Spool> createSpoolFromScan(RfidData rfidData);
  
  /// Listen to scan state changes
  Stream<NfcScanState> get scanStateStream;
  
  /// Listen to scan progress (0.0 to 1.0)
  Stream<double> get scanProgressStream;
  
  /// Listen to error messages
  Stream<String> get errorStream;
  
  /// Listen to scanned data
  Stream<RfidData> get scannedDataStream;
}
