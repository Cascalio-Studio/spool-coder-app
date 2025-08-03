import '../datasources/spool_data_source.dart';
import '../../domain/entities/spool.dart';
import '../../domain/value_objects/spool_uid.dart';

/// Local data source implementation using device storage
/// Part of the Data Layer: handles local storage operations
class LocalSpoolDataSourceImpl extends LocalSpoolDataSource {
  final Map<String, Map<String, dynamic>> _localStorage = {};
  bool _isInitialized = false;

  @override
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    // In a real implementation, this would:
    // - Initialize local database (SQLite, Hive, etc.)
    // - Load existing data from storage
    // - Set up database schema/migrations
    
    await Future.delayed(const Duration(milliseconds: 100));
    _isInitialized = true;
  }

  @override
  Future<bool> isAvailable() async {
    // Local storage is always available once initialized
    return _isInitialized;
  }

  @override
  Future<void> saveSpool(Spool spool) async {
    if (!_isInitialized) throw StateError('Data source not initialized');
    
    final data = _spoolToMap(spool);
    _localStorage[spool.uid.value] = data;
    
    // In a real implementation, this would save to actual local storage
    await Future.delayed(const Duration(milliseconds: 50));
  }

  @override
  Future<Spool?> getSpoolById(SpoolUid uid) async {
    if (!_isInitialized) throw StateError('Data source not initialized');
    
    final data = _localStorage[uid.value];
    if (data == null) return null;
    
    return _mapToSpool(data);
  }

  @override
  Future<List<Spool>> getAllSpools() async {
    if (!_isInitialized) throw StateError('Data source not initialized');
    
    return _localStorage.values
        .map((data) => _mapToSpool(data))
        .toList();
  }

  @override
  Future<void> updateSpool(Spool spool) async {
    if (!_isInitialized) throw StateError('Data source not initialized');
    
    if (!_localStorage.containsKey(spool.uid.value)) {
      throw ArgumentError('Spool not found: ${spool.uid.value}');
    }
    
    final data = _spoolToMap(spool);
    data['updatedAt'] = DateTime.now().toIso8601String();
    _localStorage[spool.uid.value] = data;
    
    await Future.delayed(const Duration(milliseconds: 30));
  }

  @override
  Future<void> deleteSpool(SpoolUid uid) async {
    if (!_isInitialized) throw StateError('Data source not initialized');
    
    _localStorage.remove(uid.value);
    await Future.delayed(const Duration(milliseconds: 20));
  }

  @override
  Future<List<Spool>> searchSpools({
    String? materialType,
    String? manufacturer,
    String? color,
    bool? isNearlyEmpty,
  }) async {
    if (!_isInitialized) throw StateError('Data source not initialized');
    
    var spools = await getAllSpools();
    
    // Apply filters
    if (materialType != null) {
      spools = spools.where((s) => s.materialType.value.toLowerCase() == materialType.toLowerCase()).toList();
    }
    
    if (manufacturer != null) {
      spools = spools.where((s) => s.manufacturer.toLowerCase() == manufacturer.toLowerCase()).toList();
    }
    
    if (color != null) {
      spools = spools.where((s) => s.color.name.toLowerCase() == color.toLowerCase()).toList();
    }
    
    if (isNearlyEmpty == true) {
      spools = spools.where((s) => s.isNearlyEmpty).toList();
    } else if (isNearlyEmpty == false) {
      spools = spools.where((s) => !s.isNearlyEmpty).toList();
    }
    
    return spools;
  }

  @override
  Future<List<Spool>> getNearlyEmptySpools() async {
    return searchSpools(isNearlyEmpty: true);
  }

  @override
  Future<String> exportSpoolData() async {
    if (!_isInitialized) throw StateError('Data source not initialized');
    
    final allSpools = await getAllSpools();
    final exportData = {
      'version': '1.0',
      'exportTime': DateTime.now().toIso8601String(),
      'totalSpools': allSpools.length,
      'spools': allSpools.map((spool) => _spoolToMap(spool)).toList(),
    };
    
    // In a real implementation, this would use JSON encoding
    return exportData.toString();
  }

  @override
  Future<void> importSpoolData(String data) async {
    if (!_isInitialized) throw StateError('Data source not initialized');
    
    // In a real implementation, this would parse JSON data
    // For now, just simulate the operation
    await Future.delayed(const Duration(milliseconds: 200));
    
    // Mock: assume importing 3 spools
    // In real implementation, would parse the data and save each spool
  }

  @override
  Future<void> clearAllData() async {
    if (!_isInitialized) throw StateError('Data source not initialized');
    
    _localStorage.clear();
    await Future.delayed(const Duration(milliseconds: 50));
  }

  @override
  Future<int> getStorageSize() async {
    if (!_isInitialized) throw StateError('Data source not initialized');
    
    // Mock storage size calculation
    return _localStorage.length * 1024; // 1KB per spool (mock)
  }

  @override
  Future<void> optimizeStorage() async {
    if (!_isInitialized) throw StateError('Data source not initialized');
    
    // In a real implementation, this would:
    // - Vacuum SQLite database  
    // - Compact storage files
    // - Remove orphaned data
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<void> dispose() async {
    // In a real implementation, this would close database connections
    _localStorage.clear();
    _isInitialized = false;
  }

  /// Convert Spool entity to Map for storage
  Map<String, dynamic> _spoolToMap(Spool spool) {
    return {
      'uid': spool.uid.value,
      'materialType': spool.materialType.value,
      'manufacturer': spool.manufacturer,
      'color': spool.color.name,
      'netLength': spool.netLength.meters,
      'remainingLength': spool.remainingLength.meters,
      'isWriteProtected': spool.isWriteProtected,
      'filamentDiameter': spool.filamentDiameter,
      'spoolWeight': spool.spoolWeight,
      'manufactureDate': spool.manufactureDate?.toIso8601String(),
      'expiryDate': spool.expiryDate?.toIso8601String(),
      'batchNumber': spool.batchNumber,
      'notes': spool.notes,
      'createdAt': spool.createdAt.toIso8601String(),
      'updatedAt': spool.updatedAt?.toIso8601String(),
      'nozzleDiameter': spool.nozzleDiameter,
      'trayUid': spool.trayUid,
      'spoolWidth': spool.spoolWidth,
      'isRfidScanned': spool.isRfidScanned,
    };
  }

  /// Convert Map from storage to Spool entity
  Spool _mapToSpool(Map<String, dynamic> data) {
    return Spool(
      uid: SpoolUid(data['uid']),
      materialType: _parseMaterialType(data['materialType']),
      manufacturer: data['manufacturer'] ?? 'Unknown',
      color: _parseColor(data['color']),
      netLength: _parseFilamentLength(data['netLength']),
      remainingLength: _parseFilamentLength(data['remainingLength']),
      isWriteProtected: data['isWriteProtected'] ?? false,
      filamentDiameter: data['filamentDiameter']?.toDouble(),
      spoolWeight: data['spoolWeight']?.toDouble(),
      manufactureDate: data['manufactureDate'] != null ? DateTime.parse(data['manufactureDate']) : null,
      expiryDate: data['expiryDate'] != null ? DateTime.parse(data['expiryDate']) : null,
      batchNumber: data['batchNumber'],
      notes: data['notes'],
      createdAt: DateTime.parse(data['createdAt']),
      updatedAt: data['updatedAt'] != null ? DateTime.parse(data['updatedAt']) : null,
      nozzleDiameter: data['nozzleDiameter']?.toDouble(),
      trayUid: data['trayUid'],
      spoolWidth: data['spoolWidth']?.toDouble(),
      isRfidScanned: data['isRfidScanned'] ?? false,
    );
  }

  /// Parse material type from stored data
  dynamic _parseMaterialType(dynamic value) {
    // In a real implementation, this would use the actual MaterialType class
    // For now, return a mock object
    return MockMaterialType(value?.toString() ?? 'PLA');
  }

  /// Parse color from stored data
  dynamic _parseColor(dynamic value) {
    // In a real implementation, this would use the actual SpoolColor class
    // For now, return a mock object
    return LocalMockSpoolColor(value?.toString() ?? 'Unknown');
  }

  /// Parse filament length from stored data
  dynamic _parseFilamentLength(dynamic value) {
    // In a real implementation, this would use the actual FilamentLength class
    // For now, return a mock object
    return MockFilamentLength((value ?? 0.0).toDouble());
  }
}

// Mock classes for compilation - these would be imported from actual value objects
class MockMaterialType {
  final String value;
  MockMaterialType(this.value);
}

class LocalMockSpoolColor {
  final String name;
  LocalMockSpoolColor(this.name);
}

class MockFilamentLength {
  final double meters;
  MockFilamentLength(this.meters);
  
  MockFilamentLength operator -(MockFilamentLength other) {
    return MockFilamentLength(meters - other.meters);
  }
  
  bool get isEmpty => meters <= 0;
  String format() => '${meters.toStringAsFixed(1)}m';
}