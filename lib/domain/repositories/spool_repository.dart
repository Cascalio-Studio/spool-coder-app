import '../entities/spool.dart';
import '../value_objects/spool_uid.dart';

/// Repository interface for spool data operations
/// Part of the Domain Layer: defines contract for data layer implementation
abstract class SpoolRepository {
  /// Scan and read spool data from a physical device
  Future<Spool> scanSpool(ScanMethod method);

  /// Get spool by its unique identifier
  Future<Spool?> getSpoolById(SpoolUid uid);

  /// Get all spools from local storage/cache
  Future<List<Spool>> getAllSpools();

  /// Save spool data to local storage
  Future<void> saveSpool(Spool spool);

  /// Update existing spool data
  Future<void> updateSpool(Spool spool);

  /// Delete spool from storage
  Future<void> deleteSpool(SpoolUid uid);

  /// Write/program data to physical spool
  Future<void> writeSpool(Spool spool, ScanMethod method);

  /// Validate spool data integrity
  Future<bool> validateSpoolData(SpoolUid uid);

  /// Search spools by various criteria
  Future<List<Spool>> searchSpools({
    String? materialType,
    String? manufacturer,
    String? color,
    bool? isNearlyEmpty,
  });

  /// Get spools that are nearly empty
  Future<List<Spool>> getNearlyEmptySpools();

  /// Backup all spool data
  Future<String> exportSpoolData();

  /// Restore spool data from backup
  Future<void> importSpoolData(String backupData);
}

/// Scanning methods supported by the application
enum ScanMethod {
  nfc('NFC'),
  usb('USB'),
  bluetooth('Bluetooth'),
  manual('Manual Input');

  const ScanMethod(this.displayName);
  final String displayName;

  @override
  String toString() => displayName;
}