import '../../core/config/app_config.dart';
import '../../domain/entities/spool.dart';
import '../../domain/value_objects/spool_uid.dart';

/// API response wrapper
class ApiResponse<T> {
  final T? data;
  final bool success;
  final String? errorMessage;
  final int? statusCode;
  final Map<String, dynamic>? metadata;

  const ApiResponse({
    this.data,
    required this.success,
    this.errorMessage,
    this.statusCode,
    this.metadata,
  });

  /// Create successful response
  factory ApiResponse.success(T data, {int? statusCode, Map<String, dynamic>? metadata}) {
    return ApiResponse<T>(
      data: data,
      success: true,
      statusCode: statusCode,
      metadata: metadata,
    );
  }

  /// Create error response
  factory ApiResponse.error(String errorMessage, {int? statusCode, Map<String, dynamic>? metadata}) {
    return ApiResponse<T>(
      success: false,
      errorMessage: errorMessage,
      statusCode: statusCode,
      metadata: metadata,
    );
  }
}

/// API client for backend communication
/// Part of the Data Layer: handles HTTP communication with backend
abstract class ApiService {
  /// Initialize the API service
  Future<void> initialize(BackendConfig config);

  /// Check if API is available
  Future<bool> isAvailable();

  /// Test connection to API
  Future<ApiResponse<Map<String, dynamic>>> ping();

  /// Get API health status
  Future<ApiResponse<Map<String, dynamic>>> getHealth();

  /// Authenticate with API
  Future<ApiResponse<AuthResult>> authenticate(String? apiKey);

  /// Make GET request
  Future<ApiResponse<T>> get<T>(String endpoint, {Map<String, String>? headers});

  /// Make POST request
  Future<ApiResponse<T>> post<T>(String endpoint, {dynamic body, Map<String, String>? headers});

  /// Make PUT request
  Future<ApiResponse<T>> put<T>(String endpoint, {dynamic body, Map<String, String>? headers});

  /// Make DELETE request
  Future<ApiResponse<T>> delete<T>(String endpoint, {Map<String, String>? headers});

  /// Upload file
  Future<ApiResponse<Map<String, dynamic>>> uploadFile(String endpoint, String filePath, {Map<String, String>? headers});

  /// Download file
  Future<ApiResponse<List<int>>> downloadFile(String endpoint, {Map<String, String>? headers});

  /// Dispose resources
  Future<void> dispose();
}

/// Authentication result
class AuthResult {
  final bool isAuthenticated;
  final String? token;
  final DateTime? expiresAt;
  final Map<String, dynamic> userInfo;

  const AuthResult({
    required this.isAuthenticated,
    this.token,
    this.expiresAt,
    this.userInfo = const {},
  });

  bool get isExpired {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }
}

/// Spool API service for backend spool operations
/// Part of the Data Layer: handles spool-specific API calls
abstract class SpoolApiService {
  /// Initialize with API service
  Future<void> initialize(ApiService apiService);

  /// Get all spools from server
  Future<ApiResponse<List<Map<String, dynamic>>>> getAllSpools();

  /// Get spool by ID from server
  Future<ApiResponse<Map<String, dynamic>?>> getSpoolById(String uid);

  /// Create new spool on server
  Future<ApiResponse<Map<String, dynamic>>> createSpool(Map<String, dynamic> spoolData);

  /// Update existing spool on server
  Future<ApiResponse<Map<String, dynamic>>> updateSpool(String uid, Map<String, dynamic> spoolData);

  /// Delete spool from server
  Future<ApiResponse<void>> deleteSpool(String uid);

  /// Search spools on server
  Future<ApiResponse<List<Map<String, dynamic>>>> searchSpools({
    String? materialType,
    String? manufacturer,
    String? color,
    bool? isNearlyEmpty,
  });

  /// Bulk sync spools with server
  Future<ApiResponse<SyncResponse>> syncSpools(List<Map<String, dynamic>> localSpools);

  /// Get sync status from server
  Future<ApiResponse<Map<String, dynamic>>> getSyncStatus();

  /// Export spools from server
  Future<ApiResponse<String>> exportSpools({List<String>? spoolUids});

  /// Import spools to server
  Future<ApiResponse<ImportResponse>> importSpools(String data);
}

/// Sync response from server
class SyncResponse {
  final List<Map<String, dynamic>> updatedSpools;
  final List<Map<String, dynamic>> conflictSpools;
  final List<String> deletedSpoolUids;
  final Map<String, dynamic> metadata;

  const SyncResponse({
    required this.updatedSpools,
    required this.conflictSpools,
    required this.deletedSpoolUids,
    this.metadata = const {},
  });

  factory SyncResponse.fromJson(Map<String, dynamic> json) {
    return SyncResponse(
      updatedSpools: List<Map<String, dynamic>>.from(json['updatedSpools'] ?? []),
      conflictSpools: List<Map<String, dynamic>>.from(json['conflictSpools'] ?? []),
      deletedSpoolUids: List<String>.from(json['deletedSpoolUids'] ?? []),
      metadata: json['metadata'] ?? {},
    );
  }
}

/// Import response from server
class ImportResponse {
  final int totalProcessed;
  final int successful;
  final int failed;
  final List<Map<String, dynamic>> errors;

  const ImportResponse({
    required this.totalProcessed,
    required this.successful,
    required this.failed,
    this.errors = const [],
  });

  factory ImportResponse.fromJson(Map<String, dynamic> json) {
    return ImportResponse(
      totalProcessed: json['totalProcessed'] ?? 0,
      successful: json['successful'] ?? 0,
      failed: json['failed'] ?? 0,
      errors: List<Map<String, dynamic>>.from(json['errors'] ?? []),
    );
  }
}

/// HTTP client implementation of API service
class HttpApiService implements ApiService {
  BackendConfig? _config;
  AuthResult? _authResult;
  
  @override
  Future<void> initialize(BackendConfig config) async {
    _config = config;
    
    // Validate configuration
    final validationError = config.validate();
    if (validationError != null) {
      throw ArgumentError('Invalid backend configuration: $validationError');
    }
  }

  @override
  Future<bool> isAvailable() async {
    if (_config == null || !_config!.isEnabled) return false;
    
    try {
      final response = await ping();
      return response.success;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<ApiResponse<Map<String, dynamic>>> ping() async {
    try {
      // In a real implementation, this would make an HTTP request
      // For now, return mock response
      await Future.delayed(const Duration(milliseconds: 100));
      
      return ApiResponse.success({
        'message': 'pong',
        'timestamp': DateTime.now().toIso8601String(),
        'version': _config?.apiVersion ?? 'v1',
      }, statusCode: 200);
    } catch (e) {
      return ApiResponse.error('Ping failed: $e', statusCode: 500);
    }
  }

  @override
  Future<ApiResponse<Map<String, dynamic>>> getHealth() async {
    try {
      // In a real implementation, this would make an HTTP request to /health
      await Future.delayed(const Duration(milliseconds: 150));
      
      return ApiResponse.success({
        'status': 'healthy',
        'timestamp': DateTime.now().toIso8601String(),
        'uptime': '24h 30m',
        'database': 'connected',
        'version': _config?.apiVersion ?? 'v1',
      }, statusCode: 200);
    } catch (e) {
      return ApiResponse.error('Health check failed: $e', statusCode: 500);
    }
  }

  @override
  Future<ApiResponse<AuthResult>> authenticate(String? apiKey) async {
    try {
      // In a real implementation, this would authenticate with the server
      await Future.delayed(const Duration(milliseconds: 200));
      
      if (apiKey != null && apiKey.isNotEmpty) {
        final authResult = AuthResult(
          isAuthenticated: true,
          token: 'mock_token_${DateTime.now().millisecondsSinceEpoch}',
          expiresAt: DateTime.now().add(const Duration(hours: 24)),
          userInfo: {
            'id': 'user_123',
            'email': 'user@example.com',
            'permissions': ['read', 'write'],
          },
        );
        
        _authResult = authResult;
        return ApiResponse.success(authResult, statusCode: 200);
      } else {
        return ApiResponse.error('Invalid API key', statusCode: 401);
      }
    } catch (e) {
      return ApiResponse.error('Authentication failed: $e', statusCode: 500);
    }
  }

  @override
  Future<ApiResponse<T>> get<T>(String endpoint, {Map<String, String>? headers}) async {
    try {
      // In a real implementation, this would make an HTTP GET request
      await Future.delayed(const Duration(milliseconds: 200));
      throw UnimplementedError('HTTP GET not implemented in mock');
    } catch (e) {
      return ApiResponse.error('GET request failed: $e', statusCode: 500);
    }
  }

  @override
  Future<ApiResponse<T>> post<T>(String endpoint, {dynamic body, Map<String, String>? headers}) async {
    try {
      // In a real implementation, this would make an HTTP POST request
      await Future.delayed(const Duration(milliseconds: 300));
      throw UnimplementedError('HTTP POST not implemented in mock');
    } catch (e) {
      return ApiResponse.error('POST request failed: $e', statusCode: 500);
    }
  }

  @override
  Future<ApiResponse<T>> put<T>(String endpoint, {dynamic body, Map<String, String>? headers}) async {
    try {
      // In a real implementation, this would make an HTTP PUT request
      await Future.delayed(const Duration(milliseconds: 300));
      throw UnimplementedError('HTTP PUT not implemented in mock');
    } catch (e) {
      return ApiResponse.error('PUT request failed: $e', statusCode: 500);
    }
  }

  @override
  Future<ApiResponse<T>> delete<T>(String endpoint, {Map<String, String>? headers}) async {
    try {
      // In a real implementation, this would make an HTTP DELETE request
      await Future.delayed(const Duration(milliseconds: 200));
      throw UnimplementedError('HTTP DELETE not implemented in mock');
    } catch (e) {
      return ApiResponse.error('DELETE request failed: $e', statusCode: 500);
    }
  }

  @override
  Future<ApiResponse<Map<String, dynamic>>> uploadFile(String endpoint, String filePath, {Map<String, String>? headers}) async {
    try {
      // In a real implementation, this would upload a file
      await Future.delayed(const Duration(seconds: 2));
      throw UnimplementedError('File upload not implemented in mock');
    } catch (e) {
      return ApiResponse.error('File upload failed: $e', statusCode: 500);
    }
  }

  @override
  Future<ApiResponse<List<int>>> downloadFile(String endpoint, {Map<String, String>? headers}) async {
    try {
      // In a real implementation, this would download a file
      await Future.delayed(const Duration(seconds: 1));
      throw UnimplementedError('File download not implemented in mock');
    } catch (e) {
      return ApiResponse.error('File download failed: $e', statusCode: 500);
    }
  }

  @override
  Future<void> dispose() async {
    _config = null;
    _authResult = null;
  }
}

/// HTTP implementation of spool API service
class HttpSpoolApiService implements SpoolApiService {
  ApiService? _apiService;

  @override
  Future<void> initialize(ApiService apiService) async {
    _apiService = apiService;
  }

  @override
  Future<ApiResponse<List<Map<String, dynamic>>>> getAllSpools() async {
    try {
      // In a real implementation, this would call GET /spools
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Mock response
      return ApiResponse.success([
        {
          'uid': 'spool_001',
          'materialType': 'PLA',
          'manufacturer': 'BambuLab',
          'color': 'Blue',
          'netLength': 1000.0,
          'remainingLength': 750.0,
          'createdAt': DateTime.now().toIso8601String(),
        },
        {
          'uid': 'spool_002',
          'materialType': 'PETG',
          'manufacturer': 'BambuLab',
          'color': 'Red',
          'netLength': 1000.0,
          'remainingLength': 200.0,
          'createdAt': DateTime.now().subtract(const Duration(days: 7)).toIso8601String(),
        },
      ], statusCode: 200);
    } catch (e) {
      return ApiResponse.error('Failed to get spools: $e', statusCode: 500);
    }
  }

  @override
  Future<ApiResponse<Map<String, dynamic>?>> getSpoolById(String uid) async {
    try {
      // In a real implementation, this would call GET /spools/{uid}
      await Future.delayed(const Duration(milliseconds: 300));
      
      // Mock response - return null if not found
      if (uid == 'spool_001') {
        return ApiResponse.success({
          'uid': uid,
          'materialType': 'PLA',
          'manufacturer': 'BambuLab',
          'color': 'Blue',
          'netLength': 1000.0,
          'remainingLength': 750.0,
          'createdAt': DateTime.now().toIso8601String(),
        }, statusCode: 200);
      } else {
        return ApiResponse.success(null, statusCode: 404);
      }
    } catch (e) {
      return ApiResponse.error('Failed to get spool: $e', statusCode: 500);
    }
  }

  @override
  Future<ApiResponse<Map<String, dynamic>>> createSpool(Map<String, dynamic> spoolData) async {
    try {
      // In a real implementation, this would call POST /spools
      await Future.delayed(const Duration(milliseconds: 400));
      
      // Mock response - return created spool with ID
      final createdSpool = Map<String, dynamic>.from(spoolData);
      createdSpool['uid'] = 'spool_${DateTime.now().millisecondsSinceEpoch}';
      createdSpool['createdAt'] = DateTime.now().toIso8601String();
      
      return ApiResponse.success(createdSpool, statusCode: 201);
    } catch (e) {
      return ApiResponse.error('Failed to create spool: $e', statusCode: 500);
    }
  }

  @override
  Future<ApiResponse<Map<String, dynamic>>> updateSpool(String uid, Map<String, dynamic> spoolData) async {
    try {
      // In a real implementation, this would call PUT /spools/{uid}
      await Future.delayed(const Duration(milliseconds: 350));
      
      // Mock response - return updated spool
      final updatedSpool = Map<String, dynamic>.from(spoolData);
      updatedSpool['uid'] = uid;
      updatedSpool['updatedAt'] = DateTime.now().toIso8601String();
      
      return ApiResponse.success(updatedSpool, statusCode: 200);
    } catch (e) {
      return ApiResponse.error('Failed to update spool: $e', statusCode: 500);
    }
  }

  @override
  Future<ApiResponse<void>> deleteSpool(String uid) async {
    try {
      // In a real implementation, this would call DELETE /spools/{uid}
      await Future.delayed(const Duration(milliseconds: 250));
      
      return ApiResponse.success(null, statusCode: 204);
    } catch (e) {
      return ApiResponse.error('Failed to delete spool: $e', statusCode: 500);
    }
  }

  @override
  Future<ApiResponse<List<Map<String, dynamic>>>> searchSpools({
    String? materialType,
    String? manufacturer,
    String? color,
    bool? isNearlyEmpty,
  }) async {
    try {
      // In a real implementation, this would call GET /spools/search with query params
      await Future.delayed(const Duration(milliseconds: 400));
      
      // Mock filtered response
      return ApiResponse.success([
        {
          'uid': 'spool_filtered_001',
          'materialType': materialType ?? 'PLA',
          'manufacturer': manufacturer ?? 'BambuLab',
          'color': color ?? 'Blue',
          'netLength': 1000.0,
          'remainingLength': isNearlyEmpty == true ? 50.0 : 750.0,
          'createdAt': DateTime.now().toIso8601String(),
        },
      ], statusCode: 200);
    } catch (e) {
      return ApiResponse.error('Failed to search spools: $e', statusCode: 500);
    }
  }

  @override
  Future<ApiResponse<SyncResponse>> syncSpools(List<Map<String, dynamic>> localSpools) async {
    try {
      // In a real implementation, this would call POST /spools/sync
      await Future.delayed(const Duration(seconds: 2));
      
      // Mock sync response
      final syncResponse = SyncResponse(
        updatedSpools: localSpools,
        conflictSpools: [],
        deletedSpoolUids: [],
        metadata: {
          'syncTime': DateTime.now().toIso8601String(),
          'totalProcessed': localSpools.length,
        },
      );
      
      return ApiResponse.success(syncResponse, statusCode: 200);
    } catch (e) {
      return ApiResponse.error('Failed to sync spools: $e', statusCode: 500);
    }
  }

  @override
  Future<ApiResponse<Map<String, dynamic>>> getSyncStatus() async {
    try {
      // In a real implementation, this would call GET /spools/sync/status
      await Future.delayed(const Duration(milliseconds: 200));
      
      return ApiResponse.success({
        'lastSyncTime': DateTime.now().subtract(const Duration(minutes: 30)).toIso8601String(),
        'pendingChanges': 0,
        'conflictCount': 0,
        'isHealthy': true,
      }, statusCode: 200);
    } catch (e) {
      return ApiResponse.error('Failed to get sync status: $e', statusCode: 500);
    }
  }

  @override
  Future<ApiResponse<String>> exportSpools({List<String>? spoolUids}) async {
    try {
      // In a real implementation, this would call GET /spools/export
      await Future.delayed(const Duration(seconds: 1));
      
      // Mock export data
      final exportData = {
        'version': '1.0',
        'exportTime': DateTime.now().toIso8601String(),
        'spools': spoolUids ?? ['spool_001', 'spool_002'],
        'data': [
          {
            'uid': 'spool_001',
            'materialType': 'PLA',
            'color': 'Blue',
          }
        ],
      };
      
      return ApiResponse.success(exportData.toString(), statusCode: 200);
    } catch (e) {
      return ApiResponse.error('Failed to export spools: $e', statusCode: 500);
    }
  }

  @override
  Future<ApiResponse<ImportResponse>> importSpools(String data) async {
    try {
      // In a real implementation, this would call POST /spools/import
      await Future.delayed(const Duration(seconds: 3));
      
      // Mock import response
      final importResponse = ImportResponse(
        totalProcessed: 5,
        successful: 4,
        failed: 1,
        errors: [
          {
            'index': 2,
            'field': 'materialType',
            'error': 'Invalid material type',
          }
        ],
      );
      
      return ApiResponse.success(importResponse, statusCode: 200);
    } catch (e) {
      return ApiResponse.error('Failed to import spools: $e', statusCode: 500);
    }
  }
}