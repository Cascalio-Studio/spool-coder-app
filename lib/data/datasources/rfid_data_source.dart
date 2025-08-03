import 'dart:async';
import '../../domain/value_objects/filament_length.dart';

/// Abstract data source for RFID reader hardware operations
/// Part of the Data Layer: defines contract for RFID hardware access
abstract class RfidReaderDataSource {
  /// Initialize RFID reader connection
  Future<void> initialize();

  /// Check if reader is available and connected
  Future<bool> isReaderAvailable();

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

  /// Stream for tag presence changes
  Stream<String> get tagPresenceStream;

  /// Stream for automatic tag scans
  Stream<RfidData> get automaticScanStream;

  /// Dispose resources
  Future<void> dispose();
}

/// Abstract data source for RFID data storage and caching
/// Part of the Data Layer: defines contract for RFID data persistence
abstract class RfidDataStorage {
  /// Initialize storage
  Future<void> initialize();

  /// Store RFID scan data with timestamp
  Future<void> storeScan(String spoolId, RfidData rfidData);

  /// Get latest RFID scan for a spool
  Future<RfidData?> getLatestScan(String spoolId);

  /// Get RFID scan history for a spool
  Future<List<RfidData>> getScanHistory(String spoolId, {
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

  /// Export RFID scan data
  Future<Map<String, dynamic>> exportRfidData({
    List<String>? spoolIds,
    DateTime? since,
  });

  /// Import RFID scan data
  Future<void> importRfidData(Map<String, dynamic> data);

  /// Dispose resources
  Future<void> dispose();
}

/// Abstract data source for RFID tag library and patterns
/// Part of the Data Layer: defines contract for tag pattern management
abstract class RfidTagLibraryDataSource {
  /// Initialize tag library
  Future<void> initialize();

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

  /// Dispose resources
  Future<void> dispose();
}

/// Mock implementation of RFID reader data source
/// Part of the Data Layer: mock hardware implementation for development
class MockRfidReaderDataSource implements RfidReaderDataSource {
  bool _isInitialized = false;
  bool _isConnected = false;
  
  final StreamController<String> _tagPresenceController = StreamController<String>.broadcast();
  final StreamController<RfidData> _automaticScanController = StreamController<RfidData>.broadcast();

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _isInitialized = true;
    _isConnected = true;
  }

  @override
  Future<bool> isReaderAvailable() async {
    return _isInitialized && _isConnected;
  }

  @override
  Future<void> disconnect() async {
    _isConnected = false;
    await Future.delayed(const Duration(milliseconds: 100));
  }

  @override
  Future<List<String>> scanForTags() async {
    if (!_isConnected) throw StateError('Reader not connected');
    
    await Future.delayed(const Duration(seconds: 2));
    
    // Mock return some tag IDs
    return ['TAG_001', 'TAG_002', 'TAG_003'];
  }

  @override
  Future<RfidData> readTag(String tagId) async {
    if (!_isConnected) throw StateError('Reader not connected');
    
    await Future.delayed(const Duration(milliseconds: 800));
    
    // Mock RFID data based on tag ID
    return _createMockRfidData(tagId);
  }

  @override
  Future<Map<String, String>> readTagBlocks(String tagId, List<int> blockNumbers) async {
    if (!_isConnected) throw StateError('Reader not connected');
    
    await Future.delayed(const Duration(milliseconds: 400));
    
    // Mock block data
    final blockData = <String, String>{};
    for (final blockNum in blockNumbers) {
      blockData['block_$blockNum'] = 'MOCK_DATA_${tagId}_$blockNum';
    }
    
    return blockData;
  }

  @override
  Future<bool> isTagPresent(String tagId) async {
    if (!_isConnected) return false;
    
    await Future.delayed(const Duration(milliseconds: 100));
    
    // Mock: assume tag is present for known IDs
    return ['TAG_001', 'TAG_002', 'TAG_003'].contains(tagId);
  }

  @override
  Future<Map<String, dynamic>> getReaderInfo() async {
    return {
      'model': 'Mock RFID Reader v1.0',
      'version': '1.0.0',
      'capabilities': ['NFC', 'ISO14443A', 'ISO15693'],
      'maxRange': '5cm',
      'supportedFrequencies': ['13.56MHz'],
    };
  }

  @override
  Stream<String> get tagPresenceStream => _tagPresenceController.stream;

  @override
  Stream<RfidData> get automaticScanStream => _automaticScanController.stream;

  @override
  Future<void> dispose() async {
    await _tagPresenceController.close();
    await _automaticScanController.close();
    _isConnected = false;
    _isInitialized = false;
  }

  /// Create mock RFID data for testing
  RfidData _createMockRfidData(String tagId) {
    return RfidData(
      uid: tagId,
      materialType: _getMockMaterialType(tagId),
      color: _getMockColor(tagId),
      temperature: _getMockTemperatureProfile(tagId),
      productionInfo: _getMockProductionInfo(tagId),
      netLength: FilamentLength.meters(1000.0),
    );
  }

  MaterialType _getMockMaterialType(String tagId) {
    switch (tagId) {
      case 'TAG_001':
        return MaterialType.pla;
      case 'TAG_002':
        return MaterialType.petg;
      case 'TAG_003':
        return MaterialType.abs;
      default:
        return MaterialType.pla;
    }
  }

  RfidSpoolColor _getMockColor(String tagId) {
    switch (tagId) {
      case 'TAG_001':
        return RfidSpoolColor.named('Blue');
      case 'TAG_002':  
        return RfidSpoolColor.named('Red');
      case 'TAG_003':
        return RfidSpoolColor.named('Black');
      default:
        return RfidSpoolColor.named('White');
    }
  }

  RfidTemperatureProfile _getMockTemperatureProfile(String tagId) {
    final material = _getMockMaterialType(tagId);
    switch (material.value) {
      case 'PLA':
        return RfidTemperatureProfile(
          minHotendTemperature: 190,
          maxHotendTemperature: 220,
          bedTemperature: 35,
        );
      case 'PETG':
        return RfidTemperatureProfile(
          minHotendTemperature: 230,
          maxHotendTemperature: 260,
          bedTemperature: 70,
        );
      case 'ABS':
        return RfidTemperatureProfile(
          minHotendTemperature: 250,
          maxHotendTemperature: 280,
          bedTemperature: 90,
        );
      default:
        return RfidTemperatureProfile(
          minHotendTemperature: 200,
          maxHotendTemperature: 230,
          bedTemperature: 60,
        );
    }
  }

  ProductionInfo _getMockProductionInfo(String tagId) {
    return ProductionInfo(
      productionDateTime: DateTime.now().subtract(const Duration(days: 30)),
      batchId: 'BATCH_${tagId}_2024',
      materialId: 'MAT_${tagId}',
      trayInfoIndex: 'TRAY_${tagId}_INDEX',
    );
  }
}

/// Local implementation of RFID data storage
/// Part of the Data Layer: handles local storage of RFID scan data
class LocalRfidDataStorage implements RfidDataStorage {
  final Map<String, List<Map<String, dynamic>>> _scanHistory = {};
  final Map<String, Map<String, dynamic>> _cachedData = {};
  bool _isInitialized = false;

  @override
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    // In a real implementation, this would initialize local database
    await Future.delayed(const Duration(milliseconds: 100));
    _isInitialized = true;
  }

  @override
  Future<void> storeScan(String spoolId, RfidData rfidData) async {
    if (!_isInitialized) await initialize();
    
    final scanData = {
      'spoolId': spoolId,
      'rfidData': _rfidDataToMap(rfidData),
      'timestamp': DateTime.now().toIso8601String(),
    };
    
    _scanHistory.putIfAbsent(spoolId, () => []).add(scanData);
    
    // Keep only last 100 scans per spool
    if (_scanHistory[spoolId]!.length > 100) {
      _scanHistory[spoolId]!.removeAt(0);
    }
  }

  @override
  Future<RfidData?> getLatestScan(String spoolId) async {
    if (!_isInitialized) await initialize();
    
    final scans = _scanHistory[spoolId];
    if (scans == null || scans.isEmpty) return null;
    
    final latestScan = scans.last;
    return _mapToRfidData(latestScan['rfidData']);
  }

  @override
  Future<List<RfidData>> getScanHistory(String spoolId, {
    DateTime? since,
    int? limit,
  }) async {
    if (!_isInitialized) await initialize();
    
    var scans = _scanHistory[spoolId] ?? [];
    
    // Filter by date if specified
    if (since != null) {
      scans = scans.where((scan) {
        final timestamp = DateTime.parse(scan['timestamp']);
        return timestamp.isAfter(since);
      }).toList();
    }
    
    // Apply limit if specified
    if (limit != null && scans.length > limit) {
      scans = scans.sublist(scans.length - limit);
    }
    
    return scans.map((scan) => _mapToRfidData(scan['rfidData'])).toList();
  }

  @override
  Future<List<String>> findSpoolsByRfidUid(String uid) async {
    if (!_isInitialized) await initialize();
    
    final spoolIds = <String>[];
    
    for (final entry in _scanHistory.entries) {
      final spoolId = entry.key;
      final scans = entry.value;
      
      for (final scan in scans) {
        final rfidData = scan['rfidData'] as Map<String, dynamic>;
        if (rfidData['uid'] == uid) {
          spoolIds.add(spoolId);
          break;
        }
      }
    }
    
    return spoolIds;
  }

  @override
  Future<void> cacheRfidData(String uid, RfidData rfidData) async {
    if (!_isInitialized) await initialize();
    
    _cachedData[uid] = {
      'data': _rfidDataToMap(rfidData),
      'cachedAt': DateTime.now().toIso8601String(),
    };
  }

  @override
  Future<RfidData?> getCachedRfidData(String uid) async {
    if (!_isInitialized) await initialize();
    
    final cached = _cachedData[uid];
    if (cached == null) return null;
    
    return _mapToRfidData(cached['data']);
  }

  @override
  Future<void> clearOldScans({DateTime? olderThan}) async {
    if (!_isInitialized) await initialize();
    
    final cutoffDate = olderThan ?? DateTime.now().subtract(const Duration(days: 30));
    
    for (final spoolId in _scanHistory.keys) {
      _scanHistory[spoolId]!.removeWhere((scan) {
        final timestamp = DateTime.parse(scan['timestamp']);
        return timestamp.isBefore(cutoffDate);
      });
    }
    
    // Remove empty entries
    _scanHistory.removeWhere((key, value) => value.isEmpty);
  }

  @override
  Future<Map<String, dynamic>> exportRfidData({
    List<String>? spoolIds,
    DateTime? since,
  }) async {
    if (!_isInitialized) await initialize();
    
    final exportData = <String, dynamic>{
      'version': '1.0',
      'exportTime': DateTime.now().toIso8601String(),
      'scans': <String, dynamic>{},
    };
    
    final relevantSpoolIds = spoolIds ?? _scanHistory.keys.toList();
    
    for (final spoolId in relevantSpoolIds) {
      final scans = await getScanHistory(spoolId, since: since);
      if (scans.isNotEmpty) {
        exportData['scans'][spoolId] = scans.map((data) => _rfidDataToMap(data)).toList();
      }
    }
    
    return exportData;
  }

  @override
  Future<void> importRfidData(Map<String, dynamic> data) async {
    if (!_isInitialized) await initialize();
    
    final scans = data['scans'] as Map<String, dynamic>? ?? {};
    
    for (final entry in scans.entries) {
      final spoolId = entry.key;
      final spoolScans = entry.value as List<dynamic>;
      
      for (final scanData in spoolScans) {
        final rfidData = _mapToRfidData(scanData);
        await storeScan(spoolId, rfidData);
      }
    }
  }

  @override
  Future<void> dispose() async {
    _scanHistory.clear();
    _cachedData.clear();
    _isInitialized = false;
  }

  /// Convert RfidData to map for storage
  Map<String, dynamic> _rfidDataToMap(RfidData rfidData) {
    return {
      'uid': rfidData.uid,
      'materialType': rfidData.materialType.value,
      'color': rfidData.color.name,
      'netLength': rfidData.netLength.meters,
      'temperatureProfile': {
        'minHotendTemp': rfidData.temperature.minHotendTemperature,
        'maxHotendTemp': rfidData.temperature.maxHotendTemperature,
        'bedTemp': rfidData.temperature.bedTemperature,
      },
      'productionInfo': {
        'productionDateTime': rfidData.productionInfo.productionDateTime?.toIso8601String(),
        'batchId': rfidData.productionInfo.batchId,
        'materialId': rfidData.productionInfo.materialId,
        'trayInfoIndex': rfidData.productionInfo.trayInfoIndex,
      },
    };
  }

  /// Convert map to RfidData entity
  RfidData _mapToRfidData(Map<String, dynamic> data) {
    return RfidData(
      uid: data['uid'],
      materialType: _parseMaterialType(data['materialType']),
      color: RfidSpoolColor.named(data['color']),
      netLength: FilamentLength.meters(data['netLength']),
      temperature: RfidTemperatureProfile(
        minHotendTemperature: data['temperatureProfile']['minHotendTemp'],
        maxHotendTemperature: data['temperatureProfile']['maxHotendTemp'],
        bedTemperature: data['temperatureProfile']['bedTemp'],
      ),
      productionInfo: ProductionInfo(
        productionDateTime: data['productionInfo']['productionDateTime'] != null
            ? DateTime.parse(data['productionInfo']['productionDateTime'])
            : null,
        batchId: data['productionInfo']['batchId'],
        materialId: data['productionInfo']['materialId'],
        trayInfoIndex: data['productionInfo']['trayInfoIndex'],
      ),
    );
  }

  MaterialType _parseMaterialType(String value) {
    switch (value.toUpperCase()) {
      case 'PLA':
        return MaterialType.pla;
      case 'PETG':
        return MaterialType.petg;
      case 'ABS':
        return MaterialType.abs;
      case 'TPU':
        return MaterialType.tpu;
      default:
        return MaterialType.pla;
    }
  }
}

/// Local implementation of RFID tag library
/// Part of the Data Layer: manages tag patterns and material identification
class LocalRfidTagLibraryDataSource implements RfidTagLibraryDataSource {
  final Map<String, Map<String, dynamic>> _tagPatterns = {};
  final Map<String, Map<String, dynamic>> _temperatureProfiles = {};
  bool _isInitialized = false;

  @override
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    await _loadDefaultPatterns();
    await _loadDefaultTemperatureProfiles();
    _isInitialized = true;
  }

  @override
  Future<List<Map<String, dynamic>>> getKnownTagPatterns() async {
    if (!_isInitialized) await initialize();
    
    return _tagPatterns.values.toList();
  }

  @override
  Future<void> addTagPattern(Map<String, dynamic> pattern) async {
    if (!_isInitialized) await initialize();
    
    final id = pattern['id'] ?? 'pattern_${DateTime.now().millisecondsSinceEpoch}';
    _tagPatterns[id] = Map.from(pattern)..['id'] = id;
  }

  @override
  Future<String?> identifyMaterialBySignature(List<int> signature) async {
    if (!_isInitialized) await initialize();
    
    // Mock material identification based on signature
    if (signature.isEmpty) return null;
    
    final firstByte = signature[0];
    switch (firstByte % 4) {
      case 0:
        return 'PLA';
      case 1:
        return 'PETG';
      case 2:
        return 'ABS';
      case 3:
        return 'TPU';
      default:
        return 'PLA';
    }
  }

  @override
  Future<Map<String, dynamic>?> getTemperatureProfile(String materialType) async {
    if (!_isInitialized) await initialize();
    
    return _temperatureProfiles[materialType.toUpperCase()];
  }

  @override
  Future<void> updateTemperatureProfile(String materialType, Map<String, dynamic> profile) async {
    if (!_isInitialized) await initialize();
    
    _temperatureProfiles[materialType.toUpperCase()] = Map.from(profile);
  }

  @override
  Future<String?> identifyManufacturer(RfidData rfidData) async {
    // Mock manufacturer identification based on UID pattern
    final uid = rfidData.uid;
    
    if (uid.startsWith('04')) {
      return 'BambuLab';
    } else if (uid.startsWith('05')) {
      return 'Prusa';
    } else if (uid.startsWith('06')) {
      return 'Polymaker';
    } else {
      return 'Unknown';
    }
  }

  @override
  Future<bool> validateSignature(List<int> signature, List<int> publicKey) async {
    // Mock signature validation
    await Future.delayed(const Duration(milliseconds: 200));
    
    // Simple mock: valid if signature and key are not empty
    return signature.isNotEmpty && publicKey.isNotEmpty;
  }

  @override
  Future<void> dispose() async {
    _tagPatterns.clear();
    _temperatureProfiles.clear();
    _isInitialized = false;
  }

  /// Load default tag patterns
  Future<void> _loadDefaultPatterns() async {
    final patterns = [
      {
        'id': 'bambu_pla_pattern',
        'materialType': 'PLA',
        'manufacturer': 'BambuLab',
        'signaturePattern': [0x04, 0x01, 0x02],
        'description': 'BambuLab PLA signature pattern',
      },
      {
        'id': 'bambu_petg_pattern',
        'materialType': 'PETG',
        'manufacturer': 'BambuLab',
        'signaturePattern': [0x04, 0x02, 0x02],
        'description': 'BambuLab PETG signature pattern',
      },
    ];
    
    for (final pattern in patterns) {
      _tagPatterns[pattern['id'] as String] = pattern;
    }
  }

  /// Load default temperature profiles
  Future<void> _loadDefaultTemperatureProfiles() async {
    _temperatureProfiles['PLA'] = {
      'minHotendTemperature': 190,
      'maxHotendTemperature': 220,
      'bedTemperature': 35,
      'dryingTemperature': 40,
      'dryingTimeHours': 4,
    };
    
    _temperatureProfiles['PETG'] = {
      'minHotendTemperature': 230,
      'maxHotendTemperature': 260,
      'bedTemperature': 70,
      'dryingTemperature': 65,
      'dryingTimeHours': 8,
    };
    
    _temperatureProfiles['ABS'] = {
      'minHotendTemperature': 250,
      'maxHotendTemperature': 280,
      'bedTemperature': 90,
      'dryingTemperature': 80,
      'dryingTimeHours': 6,
    };
    
    _temperatureProfiles['TPU'] = {
      'minHotendTemperature': 220,
      'maxHotendTemperature': 250,
      'bedTemperature': 45,
      'dryingTemperature': 50,
      'dryingTimeHours': 12,
    };
  }
}

// Mock domain classes for compilation
class MaterialType {
  final String value;
  final String displayName;
  
  const MaterialType._(this.value, this.displayName);
  
  static const MaterialType pla = MaterialType._('PLA', 'PLA');
  static const MaterialType petg = MaterialType._('PETG', 'PETG');
  static const MaterialType abs = MaterialType._('ABS', 'ABS');
  static const MaterialType tpu = MaterialType._('TPU', 'TPU');
}

class RfidSpoolColor {
  final String name;
  const RfidSpoolColor._(this.name);
  
  static RfidSpoolColor named(String name) => RfidSpoolColor._(name);
}



class RfidTemperatureProfile {
  final int? minHotendTemperature;
  final int? maxHotendTemperature;
  final int? bedTemperature;
  
  const RfidTemperatureProfile({
    this.minHotendTemperature,
    this.maxHotendTemperature,
    this.bedTemperature,
  });
}

class ProductionInfo {
  final DateTime? productionDateTime;
  final String? batchId;
  final String? materialId;
  final String? trayInfoIndex;
  
  const ProductionInfo({
    this.productionDateTime,
    this.batchId,
    this.materialId,
    this.trayInfoIndex,
  });
}

class RfidData {
  final String uid;
  final MaterialType materialType;
  final RfidSpoolColor color;
  final FilamentLength netLength;
  final RfidTemperatureProfile temperature;
  final ProductionInfo productionInfo;
  
  const RfidData({
    required this.uid,
    required this.materialType,
    required this.color,
    required this.netLength,
    required this.temperature,
    required this.productionInfo,
  });
}