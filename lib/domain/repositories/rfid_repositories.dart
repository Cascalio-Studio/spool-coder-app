import '../value_objects/rfid_data.dart';

/// Repository interface for RFID hardware operations
/// Part of the Domain Layer: defines contracts for RFID data access
abstract class RfidReaderRepository {
  /// Check if RFID reader hardware is available and connected
  Future<bool> isReaderAvailable();

  /// Initialize RFID reader connection
  Future<void> initialize();

  /// Disconnect from RFID reader
  Future<void> disconnect();

  /// Scan for available RFID tags in range
  Future<List<String>> scanForTags();

  /// Read complete RFID tag data by tag ID
  Future<RfidData> readTag(String tagId);

  /// Read specific blocks from RFID tag
  Future<Map<String, String>> readTagBlocks(String tagId, List<int> blockNumbers);

  /// Check if specific tag is still in range
  Future<bool> isTagPresent(String tagId);

  /// Get reader device information and capabilities
  Future<Map<String, dynamic>> getReaderInfo();

  /// Listen for tag presence changes (tag added/removed)
  Stream<String> get tagPresenceStream;

  /// Listen for automatic tag scans
  Stream<RfidData> get automaticScanStream;
}

/// Repository interface for RFID data persistence and caching
abstract class RfidDataRepository {
  /// Store RFID scan data with timestamp
  Future<void> storeRfidScan(String spoolId, RfidData rfidData);

  /// Retrieve latest RFID scan for a spool
  Future<RfidData?> getLatestRfidScan(String spoolId);

  /// Get RFID scan history for a spool
  Future<List<RfidData>> getRfidScanHistory(String spoolId, {
    DateTime? since,
    int? limit,
  });

  /// Find spools by RFID UID
  Future<List<String>> findSpoolsByRfidUid(String uid);

  /// Cache RFID data for offline access
  Future<void> cacheRfidData(String uid, RfidData rfidData);

  /// Retrieve cached RFID data
  Future<RfidData?> getCachedRfidData(String uid);

  /// Clear old RFID scan data
  Future<void> clearOldScans({DateTime? olderThan});

  /// Export RFID scan data for analysis
  Future<Map<String, dynamic>> exportRfidData({
    List<String>? spoolIds,
    DateTime? since,
  });

  /// Import RFID scan data from external source
  Future<void> importRfidData(Map<String, dynamic> data);
}

/// Repository interface for RFID tag library and templates
abstract class RfidTagLibraryRepository {
  /// Get known RFID tag patterns for material identification
  Future<List<Map<String, dynamic>>> getKnownTagPatterns();

  /// Add new RFID tag pattern to library
  Future<void> addTagPattern(Map<String, dynamic> pattern);

  /// Find material type by RFID signature
  Future<String?> identifyMaterialBySignature(List<int> signature);

  /// Get temperature profiles for known materials
  Future<Map<String, dynamic>?> getTemperatureProfile(String materialType);

  /// Update material temperature profile
  Future<void> updateTemperatureProfile(String materialType, Map<String, dynamic> profile);

  /// Get manufacturer information by RFID signature
  Future<String?> identifyManufacturer(RfidData rfidData);

  /// Validate RFID signature authenticity
  Future<bool> validateSignature(List<int> signature, List<int> publicKey);
}