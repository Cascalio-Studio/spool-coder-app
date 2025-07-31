import '../value_objects/rfid_data.dart';
import '../entities/spool.dart';

/// Use case interface for scanning RFID tags
/// Part of the Domain Layer: defines RFID scanning business operations
abstract class ScanRfidTagUseCase {
  /// Scan an RFID tag and return the raw data
  /// Throws [RfidScanException] if scanning fails
  Future<RfidData> scanTag(String? tagId);

  /// Scan RFID tag and create a Spool entity from the data
  /// Optionally specify remaining length if different from total
  Future<Spool> scanAndCreateSpool(String? tagId, {
    double? remainingLengthMeters,
  });
}

/// Use case interface for parsing RFID data from external sources
abstract class ParseRfidDataUseCase {
  /// Parse RFID data from hex block dump (Proxmark3 format)
  RfidData parseFromHexDump(Map<String, String> blocks);

  /// Parse RFID data from binary dump
  RfidData parseFromBinaryDump(List<int> binaryData);

  /// Validate RFID data structure and content
  List<String> validateRfidStructure(RfidData rfidData);
}

/// Use case interface for RFID-based spool identification
abstract class IdentifySpoolFromRfidUseCase {
  /// Match RFID data to existing spool in repository
  Future<Spool?> findMatchingSpool(RfidData rfidData);

  /// Update existing spool with fresh RFID scan data
  Future<Spool> updateSpoolFromRfid(Spool existingSpool, RfidData newRfidData);

  /// Check if RFID data matches existing spool
  bool doesRfidMatchSpool(RfidData rfidData, Spool spool);
}

/// Use case interface for RFID-based material verification
abstract class VerifyMaterialFromRfidUseCase {
  /// Verify that RFID data matches expected material type
  Future<bool> verifyMaterialType(RfidData rfidData, String expectedMaterialType);

  /// Get detailed material information from RFID data
  Future<Map<String, dynamic>> getMaterialInfo(RfidData rfidData);

  /// Check if material is compatible with printer configuration
  Future<bool> checkPrinterCompatibility(RfidData rfidData, Map<String, dynamic> printerSpecs);
}

/// Use case interface for generating RFID-based recommendations
abstract class GenerateRfidRecommendationsUseCase {
  /// Generate printing recommendations based on RFID data
  Future<Map<String, dynamic>> generatePrintingRecommendations(RfidData rfidData);

  /// Analyze RFID data for potential issues or warnings
  Future<List<String>> analyzeForIssues(RfidData rfidData);

  /// Get maintenance recommendations based on material type and age
  Future<List<String>> getMaintenanceRecommendations(RfidData rfidData);
}

/// Use case interface for RFID data archiving and history
abstract class ArchiveRfidDataUseCase {
  /// Store RFID scan history for a spool
  Future<void> archiveScanData(String spoolId, RfidData rfidData);

  /// Retrieve RFID scan history for a spool
  Future<List<RfidData>> getScanHistory(String spoolId);

  /// Compare RFID scans to detect changes or tampering
  Future<List<String>> compareScanData(RfidData oldScan, RfidData newScan);
}