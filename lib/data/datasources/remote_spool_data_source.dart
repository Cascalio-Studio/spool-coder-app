import '../datasources/spool_data_source.dart';
import '../services/api_service.dart';
import '../../domain/entities/spool.dart';
import '../../domain/value_objects/spool_uid.dart';

/// Remote data source implementation using backend API
/// Part of the Data Layer: handles remote API operations
class RemoteSpoolDataSourceImpl extends RemoteSpoolDataSource {
  ApiService? _apiService;
  SpoolApiService? _spoolApiService;
  bool _isInitialized = false;
  AuthResult? _authResult;

  @override
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    // API service should be injected from outside
    // This is just placeholder initialization
    _isInitialized = true;
  }

  /// Initialize with API services
  Future<void> initializeWithServices(ApiService apiService, SpoolApiService spoolApiService) async {
    _apiService = apiService;
    _spoolApiService = spoolApiService;
    await _spoolApiService!.initialize(_apiService!);
    _isInitialized = true;
  }

  @override
  Future<bool> isAvailable() async {
    if (!_isInitialized || _apiService == null) return false;
    
    return await _apiService!.isAvailable();
  }

  @override
  Future<void> saveSpool(Spool spool) async {
    if (!_isInitialized || _spoolApiService == null) {
      throw StateError('Data source not initialized');
    }
    
    final spoolData = _spoolToMap(spool);
    final response = await _spoolApiService!.createSpool(spoolData);
    
    if (!response.success) {
      throw Exception('Failed to save spool: ${response.errorMessage}');
    }
  }

  @override
  Future<Spool?> getSpoolById(SpoolUid uid) async {
    if (!_isInitialized || _spoolApiService == null) {
      throw StateError('Data source not initialized');
    }
    
    final response = await _spoolApiService!.getSpoolById(uid.value);
    
    if (!response.success) {
      if (response.statusCode == 404) return null;
      throw Exception('Failed to get spool: ${response.errorMessage}');
    }
    
    if (response.data == null) return null;
    
    return _mapToSpool(response.data!);
  }

  @override
  Future<List<Spool>> getAllSpools() async {
    if (!_isInitialized || _spoolApiService == null) {
      throw StateError('Data source not initialized');
    }
    
    final response = await _spoolApiService!.getAllSpools();
    
    if (!response.success) {
      throw Exception('Failed to get spools: ${response.errorMessage}');
    }
    
    return response.data!.map((data) => _mapToSpool(data)).toList();
  }

  @override
  Future<void> updateSpool(Spool spool) async {
    if (!_isInitialized || _spoolApiService == null) {
      throw StateError('Data source not initialized');
    }
    
    final spoolData = _spoolToMap(spool);
    final response = await _spoolApiService!.updateSpool(spool.uid.value, spoolData);
    
    if (!response.success) {
      throw Exception('Failed to update spool: ${response.errorMessage}');
    }
  }

  @override
  Future<void> deleteSpool(SpoolUid uid) async {
    if (!_isInitialized || _spoolApiService == null) {
      throw StateError('Data source not initialized');
    }
    
    final response = await _spoolApiService!.deleteSpool(uid.value);
    
    if (!response.success) {
      throw Exception('Failed to delete spool: ${response.errorMessage}');
    }
  }

  @override
  Future<List<Spool>> searchSpools({
    String? materialType,
    String? manufacturer,
    String? color,
    bool? isNearlyEmpty,
  }) async {
    if (!_isInitialized || _spoolApiService == null) {
      throw StateError('Data source not initialized');
    }
    
    final response = await _spoolApiService!.searchSpools(
      materialType: materialType,
      manufacturer: manufacturer,
      color: color,
      isNearlyEmpty: isNearlyEmpty,
    );
    
    if (!response.success) {
      throw Exception('Failed to search spools: ${response.errorMessage}');
    }
    
    return response.data!.map((data) => _mapToSpool(data)).toList();
  }

  @override
  Future<List<Spool>> getNearlyEmptySpools() async {
    return searchSpools(isNearlyEmpty: true);
  }

  @override
  Future<String> exportSpoolData() async {
    if (!_isInitialized || _spoolApiService == null) {
      throw StateError('Data source not initialized');
    }
    
    final response = await _spoolApiService!.exportSpools();
    
    if (!response.success) {
      throw Exception('Failed to export spools: ${response.errorMessage}');
    }
    
    return response.data!;
  }

  @override
  Future<void> importSpoolData(String data) async {
    if (!_isInitialized || _spoolApiService == null) {
      throw StateError('Data source not initialized');
    }
    
    final response = await _spoolApiService!.importSpools(data);
    
    if (!response.success) {
      throw Exception('Failed to import spools: ${response.errorMessage}');
    }
    
    // Could return import result for detailed feedback
  }

  @override
  Future<SyncResult> sync() async {
    if (!_isInitialized || _spoolApiService == null) {
      throw StateError('Data source not initialized');
    }
    
    final startTime = DateTime.now();
    
    try {
      // Get current spools from server
      final allSpools = await getAllSpools();
      final spoolData = allSpools.map((spool) => _spoolToMap(spool)).toList();
      
      // Perform bidirectional sync
      final response = await _spoolApiService!.syncSpools(spoolData);
      
      if (!response.success) {
        return SyncResult(
          totalItems: 0,
          syncedItems: 0,
          conflictItems: 0,
          errorItems: 1,
          errors: [SyncError(
            spoolUid: 'N/A',
            operation: 'sync',
            errorMessage: response.errorMessage ?? 'Unknown sync error',
            timestamp: DateTime.now(),
          )],
          syncTime: startTime,
          syncDuration: DateTime.now().difference(startTime),
        );
      }
      
      final syncResponse = response.data!;
      
      return SyncResult(
        totalItems: spoolData.length,
        syncedItems: syncResponse.updatedSpools.length,
        conflictItems: syncResponse.conflictSpools.length,
        errorItems: 0,
        errors: [],
        syncTime: startTime,
        syncDuration: DateTime.now().difference(startTime),
      );
    } catch (e) {
      return SyncResult(
        totalItems: 0,
        syncedItems: 0,
        conflictItems: 0,
        errorItems: 1,
        errors: [SyncError(
          spoolUid: 'N/A',
          operation: 'sync',
          errorMessage: e.toString(),
          timestamp: DateTime.now(),
        )],
        syncTime: startTime,
        syncDuration: DateTime.now().difference(startTime),
      );
    }
  }

  @override
  Future<ServerStatus> getServerStatus() async {
    if (!_isInitialized || _apiService == null) {
      throw StateError('Data source not initialized');
    }
    
    final startTime = DateTime.now();
    final healthResponse = await _apiService!.getHealth();
    final responseTime = DateTime.now().difference(startTime).inMilliseconds;
    
    if (healthResponse.success && healthResponse.data != null) {
      return ServerStatus(
        isOnline: true,
        version: healthResponse.data!['version'] ?? 'unknown',
        serverTime: DateTime.tryParse(healthResponse.data!['timestamp'] ?? '') ?? DateTime.now(),
        responseTimeMs: responseTime,
        metadata: healthResponse.data!,
      );
    } else {
      return ServerStatus(
        isOnline: false,
        version: 'unknown',
        serverTime: DateTime.now(),
        responseTimeMs: responseTime,
        metadata: {'error': healthResponse.errorMessage},
      );
    }
  }

  @override
  Future<bool> authenticate(String? apiKey) async {
    if (!_isInitialized || _apiService == null) {
      throw StateError('Data source not initialized');
    }
    
    final response = await _apiService!.authenticate(apiKey);
    
    if (response.success && response.data != null) {
      _authResult = response.data!;
      return _authResult!.isAuthenticated;
    }
    
    return false;
  }

  @override
  Future<bool> hasPermission(String operation) async {
    if (_authResult == null || !_authResult!.isAuthenticated) {
      return false;
    }
    
    // Check permissions from auth result
    final permissions = _authResult!.userInfo['permissions'] as List<dynamic>?;
    return permissions?.contains(operation) ?? false;
  }

  @override
  Future<void> dispose() async {
    _apiService?.dispose();
    _apiService = null;
    _spoolApiService = null;
    _authResult = null;
    _isInitialized = false;
  }

  /// Convert Spool entity to Map for API
  Map<String, dynamic> _spoolToMap(Spool spool) {
    return {
      'uid': spool.uid.value,
      'materialType': spool.materialType.toString(),
      'manufacturer': spool.manufacturer,
      'color': spool.color.toString(),
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

  /// Convert Map from API to Spool entity
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

  /// Parse material type from API data
  dynamic _parseMaterialType(dynamic value) {
    // In a real implementation, this would use the actual MaterialType class
    return MockMaterialType(value?.toString() ?? 'PLA');
  }

  /// Parse color from API data  
  dynamic _parseColor(dynamic value) {
    // In a real implementation, this would use the actual SpoolColor class
    return MockSpoolColor(value?.toString() ?? 'Unknown');
  }

  /// Parse filament length from API data
  dynamic _parseFilamentLength(dynamic value) {
    // In a real implementation, this would use the actual FilamentLength class
    return MockFilamentLength((value ?? 0.0).toDouble());
  }
}

// Mock classes for compilation - these would be imported from actual value objects
class MockMaterialType {
  final String value;
  MockMaterialType(this.value);
  
  @override
  String toString() => value;
}

class MockSpoolColor {
  final String name;
  MockSpoolColor(this.name);
  
  @override
  String toString() => name;
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