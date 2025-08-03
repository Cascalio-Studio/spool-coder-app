import '../../domain/repositories/rfid_repositories.dart';
import '../../domain/value_objects/rfid_data.dart' as domain;
import '../../domain/value_objects/temperature_profile.dart';
import '../../domain/value_objects/production_info.dart';
import '../../domain/value_objects/filament_length.dart';
import '../datasources/rfid_data_source.dart' as data;
import '../mappers/entity_mappers.dart';

/// Implementation of RFID reader repository
/// Part of the Data Layer: bridges domain interface with hardware data sources
class RfidReaderRepositoryImpl implements RfidReaderRepository {
  final data.RfidReaderDataSource _dataSource;

  const RfidReaderRepositoryImpl({
    required data.RfidReaderDataSource dataSource,
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
  Future<domain.RfidData> readTag(String tagId) async {
    final dataRfid = await _dataSource.readTag(tagId);
    return _convertToDomainEntity(dataRfid);
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
  Stream<domain.RfidData> get automaticScanStream => 
    _dataSource.automaticScanStream.map((data) => _convertToDomainEntity(data));

  /// Convert data source RfidData to domain RfidData
  domain.RfidData _convertToDomainEntity(data.RfidData dataRfid) {
    return domain.RfidData(
      uid: dataRfid.uid,
      scanTime: DateTime.now(), // Data source doesn't have scanTime, use current time
      filamentType: dataRfid.materialType.value,
      color: SpoolColorMapper.fromString(dataRfid.color.name),
      filamentLength: dataRfid.netLength,
      temperatureProfile: TemperatureProfile(
        minHotendTemperature: dataRfid.temperature.minHotendTemperature,
        maxHotendTemperature: dataRfid.temperature.maxHotendTemperature,
        bedTemperature: dataRfid.temperature.bedTemperature,
      ),
      productionInfo: ProductionInfo(
        productionDateTime: dataRfid.productionInfo.productionDateTime,
        batchId: dataRfid.productionInfo.batchId,
        trayInfoIndex: dataRfid.productionInfo.trayInfoIndex,
        materialId: dataRfid.productionInfo.materialId,
      ),
    );
  }
}

/// Implementation of RFID data repository
/// Part of the Data Layer: handles RFID data persistence and caching
class RfidDataRepositoryImpl implements RfidDataRepository {
  final data.RfidDataStorage _dataStorage;

  const RfidDataRepositoryImpl({
    required data.RfidDataStorage dataStorage,
  }) : _dataStorage = dataStorage;
  
  /// Simple mapping helper: map filamentType string to data.MaterialType
  data.MaterialType _mapMaterialType(String? filamentType) {
    // TODO: implement proper mapping; default to PLA
    return data.MaterialType.pla;
  }

  @override
  Future<void> storeRfidScan(String spoolId, domain.RfidData rfidData) async {
    final dataRfid = _convertToDataEntity(rfidData);
    await _dataStorage.storeScan(spoolId, dataRfid);
  }

  @override
  Future<domain.RfidData?> getLatestRfidScan(String spoolId) async {
    final dataRfid = await _dataStorage.getLatestScan(spoolId);
    return dataRfid != null ? _convertToDomainEntity(dataRfid) : null;
  }

  @override
  Future<List<domain.RfidData>> getRfidScanHistory(String spoolId, {
    DateTime? since,
    int? limit,
  }) async {
    final dataRfids = await _dataStorage.getScanHistory(
      spoolId,
      since: since,
      limit: limit,
    );
    return dataRfids.map((data) => _convertToDomainEntity(data)).toList();
  }

  @override
  Future<List<String>> findSpoolsByRfidUid(String uid) async {
    return await _dataStorage.findSpoolsByRfidUid(uid);
  }

  @override
  Future<void> cacheRfidData(String uid, domain.RfidData rfidData) async {
    final dataRfid = _convertToDataEntity(rfidData);
    await _dataStorage.cacheRfidData(uid, dataRfid);
  }

  @override
  Future<domain.RfidData?> getCachedRfidData(String uid) async {
    final dataRfid = await _dataStorage.getCachedRfidData(uid);
    return dataRfid != null ? _convertToDomainEntity(dataRfid) : null;
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
  
  /// Convert data source RfidData to domain RfidData
  domain.RfidData _convertToDomainEntity(data.RfidData dataRfid) {
    return domain.RfidData(
      uid: dataRfid.uid,
      scanTime: DateTime.now(),
      filamentType: dataRfid.materialType.value,
      detailedFilamentType: null,
      color: SpoolColorMapper.fromString(dataRfid.color.name),
      spoolWeight: null,
      filamentDiameter: null,
      temperatureProfile: TemperatureProfile(
        minHotendTemperature: dataRfid.temperature.minHotendTemperature,
        maxHotendTemperature: dataRfid.temperature.maxHotendTemperature,
        bedTemperature: dataRfid.temperature.bedTemperature,
      ),
      nozzleDiameter: null,
      trayUid: null,
      spoolWidth: null,
      productionInfo: ProductionInfo(
        productionDateTime: dataRfid.productionInfo.productionDateTime,
        batchId: dataRfid.productionInfo.batchId,
        trayInfoIndex: dataRfid.productionInfo.trayInfoIndex,
        materialId: dataRfid.productionInfo.materialId,
      ),
      filamentLength: dataRfid.netLength,
      xCamInfo: null,
      rsaSignature: null,
    );
  }

  /// Convert domain RfidData to data source RfidData
  data.RfidData _convertToDataEntity(domain.RfidData domainData) {
    return data.RfidData(
      uid: domainData.uid,
      materialType: _mapMaterialType(domainData.filamentType),
      color: data.RfidSpoolColor.named(domainData.color?.name ?? 'Unknown'),
      netLength: domainData.filamentLength ?? FilamentLength.meters(0),
      temperature: data.RfidTemperatureProfile(
        minHotendTemperature: domainData.temperatureProfile?.minHotendTemperature,
        maxHotendTemperature: domainData.temperatureProfile?.maxHotendTemperature,
        bedTemperature: domainData.temperatureProfile?.bedTemperature,
      ),
      productionInfo: data.ProductionInfo(
        productionDateTime: domainData.productionInfo?.productionDateTime,
        batchId: domainData.productionInfo?.batchId,
        materialId: domainData.productionInfo?.materialId,
        trayInfoIndex: domainData.productionInfo?.trayInfoIndex,
      ),
    );
  }
}

/// Implementation of RFID tag library repository
/// Part of the Data Layer: manages RFID tag patterns and material identification
class RfidTagLibraryRepositoryImpl implements RfidTagLibraryRepository {
  final data.RfidTagLibraryDataSource _dataSource;

  const RfidTagLibraryRepositoryImpl({
    required data.RfidTagLibraryDataSource dataSource,
  }) : _dataSource = dataSource;
  
  /// Map domain filamentType string to data.MaterialType
  data.MaterialType _mapMaterialType(String? filamentType) {
    if (filamentType == null) return data.MaterialType.pla;
    switch (filamentType.toUpperCase()) {
      case 'ABS': return data.MaterialType.abs;
      case 'PETG': return data.MaterialType.petg;
      case 'TPU': return data.MaterialType.tpu;
      default: return data.MaterialType.pla;
    }
  }
  

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
  Future<String?> identifyManufacturer(domain.RfidData rfidData) async {
    final dataRfid = data.RfidData(
      uid: rfidData.uid,
      materialType: _mapMaterialType(rfidData.filamentType),
      color: data.RfidSpoolColor.named(rfidData.color?.name ?? 'Unknown'),
      netLength: rfidData.filamentLength ?? FilamentLength.meters(0),
      temperature: data.RfidTemperatureProfile(
        minHotendTemperature: rfidData.temperatureProfile?.minHotendTemperature,
        maxHotendTemperature: rfidData.temperatureProfile?.maxHotendTemperature,
        bedTemperature: rfidData.temperatureProfile?.bedTemperature,
      ),
      productionInfo: data.ProductionInfo(
        productionDateTime: rfidData.productionInfo?.productionDateTime,
        batchId: rfidData.productionInfo?.batchId,
        trayInfoIndex: rfidData.productionInfo?.trayInfoIndex,
        materialId: rfidData.productionInfo?.materialId,
      ),
    );
    return await _dataSource.identifyManufacturer(dataRfid);
  }

  @override
  Future<bool> validateSignature(List<int> signature, List<int> publicKey) async {
    return await _dataSource.validateSignature(signature, publicKey);
  }
}