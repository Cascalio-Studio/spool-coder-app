import '../../domain/repositories/rfid_repositories.dart';
import '../../domain/value_objects/rfid_data.dart';
import '../datasources/rfid_data_source.dart';

/// Implementation of RFID reader repository
/// Part of the Data Layer: bridges domain interface with hardware data sources
class RfidReaderRepositoryImpl implements RfidReaderRepository {
  final RfidReaderDataSource _dataSource;

  const RfidReaderRepositoryImpl({
    required RfidReaderDataSource dataSource,
  }) : _dataSource = dataSource;

  @override
  Future<bool> isReaderAvailable() async {
    return await _dataSource.isReaderAvailable();
  }

  @override
  Future<void> initialize() async {
    await _dataSource.initialize();
  }

  @override
  Future<void> disconnect() async {
    await _dataSource.disconnect();
  }

  @override
  Future<List<String>> scanForTags() async {
    return await _dataSource.scanForTags();
  }

  @override
  Future<RfidData> readTag(String tagId) async {
    return await _dataSource.readTag(tagId);
  }

  @override
  Future<Map<String, String>> readTagBlocks(String tagId, List<int> blockNumbers) async {
    return await _dataSource.readTagBlocks(tagId, blockNumbers);
  }

  @override
  Future<bool> isTagPresent(String tagId) async {
    return await _dataSource.isTagPresent(tagId);
  }

  @override
  Future<Map<String, dynamic>> getReaderInfo() async {
    return await _dataSource.getReaderInfo();
  }

  @override
  Stream<String> get tagPresenceStream => _dataSource.tagPresenceStream;

  @override
  Stream<RfidData> get automaticScanStream => _dataSource.automaticScanStream;
}

/// Implementation of RFID data repository
/// Part of the Data Layer: handles RFID data persistence and caching
class RfidDataRepositoryImpl implements RfidDataRepository {
  final RfidDataStorage _dataStorage;

  const RfidDataRepositoryImpl({
    required RfidDataStorage dataStorage,
  }) : _dataStorage = dataStorage;

  @override
  Future<void> storeRfidScan(String spoolId, RfidData rfidData) async {
    await _dataStorage.storeScan(spoolId, rfidData);
  }

  @override
  Future<RfidData?> getLatestRfidScan(String spoolId) async {
    return await _dataStorage.getLatestScan(spoolId);
  }

  @override
  Future<List<RfidData>> getRfidScanHistory(String spoolId, {
    DateTime? since,
    int? limit,
  }) async {
    return await _dataStorage.getScanHistory(
      spoolId,
      since: since,
      limit: limit,
    );
  }

  @override
  Future<List<String>> findSpoolsByRfidUid(String uid) async {
    return await _dataStorage.findSpoolsByRfidUid(uid);
  }

  @override
  Future<void> cacheRfidData(String uid, RfidData rfidData) async {
    await _dataStorage.cacheRfidData(uid, rfidData);
  }

  @override
  Future<RfidData?> getCachedRfidData(String uid) async {
    return await _dataStorage.getCachedRfidData(uid);
  }

  @override
  Future<void> clearOldScans({DateTime? olderThan}) async {
    await _dataStorage.clearOldScans(olderThan: olderThan);
  }

  @override
  Future<Map<String, dynamic>> exportRfidData({
    List<String>? spoolIds,
    DateTime? since,
  }) async {
    return await _dataStorage.exportRfidData(
      spoolIds: spoolIds,
      since: since,
    );
  }

  @override
  Future<void> importRfidData(Map<String, dynamic> data) async {
    await _dataStorage.importRfidData(data);
  }
}

/// Implementation of RFID tag library repository
/// Part of the Data Layer: manages RFID tag patterns and material identification
class RfidTagLibraryRepositoryImpl implements RfidTagLibraryRepository {
  final RfidTagLibraryDataSource _dataSource;

  const RfidTagLibraryRepositoryImpl({
    required RfidTagLibraryDataSource dataSource,
  }) : _dataSource = dataSource;

  @override
  Future<List<Map<String, dynamic>>> getKnownTagPatterns() async {
    return await _dataSource.getKnownTagPatterns();
  }

  @override
  Future<void> addTagPattern(Map<String, dynamic> pattern) async {
    await _dataSource.addTagPattern(pattern);
  }

  @override
  Future<String?> identifyMaterialBySignature(List<int> signature) async {
    return await _dataSource.identifyMaterialBySignature(signature);
  }

  @override
  Future<Map<String, dynamic>?> getTemperatureProfile(String materialType) async {
    return await _dataSource.getTemperatureProfile(materialType);
  }

  @override
  Future<void> updateTemperatureProfile(String materialType, Map<String, dynamic> profile) async {
    await _dataSource.updateTemperatureProfile(materialType, profile);
  }

  @override
  Future<String?> identifyManufacturer(RfidData rfidData) async {
    return await _dataSource.identifyManufacturer(rfidData);
  }

  @override
  Future<bool> validateSignature(List<int> signature, List<int> publicKey) async {
    return await _dataSource.validateSignature(signature, publicKey);
  }
}