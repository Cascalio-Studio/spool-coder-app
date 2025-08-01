import 'package:test/test.dart';
import '../../../lib/data/services/api_service.dart';
import '../../../lib/core/config/app_config.dart';

void main() {
  group('HttpApiService', () {
    late HttpApiService apiService;
    late BackendConfig config;

    setUp(() {
      apiService = HttpApiService();
      config = const BackendConfig.enabled(
        baseUrl: 'https://api.example.com',
        apiKey: 'test-key',
      );
    });

    tearDown(() async {
      await apiService.dispose();
    });

    test('should initialize with valid configuration', () async {
      await apiService.initialize(config);
      expect(await apiService.isAvailable(), true);
    });

    test('should fail to initialize with invalid configuration', () async {
      const invalidConfig = BackendConfig.enabled(baseUrl: 'invalid-url');
      
      expect(
        () => apiService.initialize(invalidConfig),
        throwsArgumentError,
      );
    });

    test('should respond to ping when available', () async {
      await apiService.initialize(config);
      
      final response = await apiService.ping();
      expect(response.success, true);
      expect(response.data?['message'], 'pong');
      expect(response.statusCode, 200);
    });

    test('should check health status', () async {
      await apiService.initialize(config);
      
      final response = await apiService.getHealth();
      expect(response.success, true);
      expect(response.data?['status'], 'healthy');
      expect(response.statusCode, 200);
    });

    test('should authenticate with valid API key', () async {
      await apiService.initialize(config);
      
      final response = await apiService.authenticate('valid-key');
      expect(response.success, true);
      expect(response.data?.isAuthenticated, true);
      expect(response.data?.token, isNotNull);
    });

    test('should fail authentication with invalid API key', () async {
      await apiService.initialize(config);
      
      final response = await apiService.authenticate('');
      expect(response.success, false);
      expect(response.statusCode, 401);
    });
  });

  group('HttpSpoolApiService', () {
    late HttpSpoolApiService spoolApiService;
    late HttpApiService apiService;

    setUp(() async {
      apiService = HttpApiService();
      spoolApiService = HttpSpoolApiService();
      
      const config = BackendConfig.enabled(
        baseUrl: 'https://api.example.com',
        apiKey: 'test-key',
      );
      
      await apiService.initialize(config);
      await spoolApiService.initialize(apiService);
    });

    tearDown(() async {
      await apiService.dispose();
    });

    test('should get all spools', () async {
      final response = await spoolApiService.getAllSpools();
      
      expect(response.success, true);
      expect(response.data, isA<List<Map<String, dynamic>>>());
      expect(response.statusCode, 200);
    });

    test('should get spool by ID', () async {
      final response = await spoolApiService.getSpoolById('spool_001');
      
      expect(response.success, true);
      expect(response.data?['uid'], 'spool_001');
      expect(response.statusCode, 200);
    });

    test('should return null for non-existent spool', () async {
      final response = await spoolApiService.getSpoolById('non_existent');
      
      expect(response.success, true);
      expect(response.data, null);
      expect(response.statusCode, 404);
    });

    test('should create new spool', () async {
      final spoolData = {
        'materialType': 'PLA',
        'manufacturer': 'BambuLab',
        'color': 'Blue',
        'netLength': 1000.0,
        'remainingLength': 1000.0,
      };
      
      final response = await spoolApiService.createSpool(spoolData);
      
      expect(response.success, true);
      expect(response.data?['uid'], isNotNull);
      expect(response.data?['materialType'], 'PLA');
      expect(response.statusCode, 201);
    });

    test('should update existing spool', () async {
      final spoolData = {
        'materialType': 'PLA',
        'remainingLength': 500.0,
      };
      
      final response = await spoolApiService.updateSpool('spool_001', spoolData);
      
      expect(response.success, true);
      expect(response.data?['uid'], 'spool_001');
      expect(response.data?['updatedAt'], isNotNull);
      expect(response.statusCode, 200);
    });

    test('should delete spool', () async {
      final response = await spoolApiService.deleteSpool('spool_001');
      
      expect(response.success, true);
      expect(response.statusCode, 204);
    });

    test('should search spools with filters', () async {
      final response = await spoolApiService.searchSpools(
        materialType: 'PLA',
        manufacturer: 'BambuLab',
        isNearlyEmpty: true,
      );
      
      expect(response.success, true);
      expect(response.data, isA<List<Map<String, dynamic>>>());
      expect(response.statusCode, 200);
    });

    test('should sync spools', () async {
      final localSpools = [
        {
          'uid': 'local_001',
          'materialType': 'PLA',
          'color': 'Red',
        }
      ];
      
      final response = await spoolApiService.syncSpools(localSpools);
      
      expect(response.success, true);
      expect(response.data?.updatedSpools, isA<List>());
      expect(response.statusCode, 200);
    });

    test('should get sync status', () async {
      final response = await spoolApiService.getSyncStatus();
      
      expect(response.success, true);
      expect(response.data?['isHealthy'], true);
      expect(response.statusCode, 200);
    });

    test('should export spools', () async {
      final response = await spoolApiService.exportSpools();
      
      expect(response.success, true);
      expect(response.data, isA<String>());
      expect(response.statusCode, 200);
    });

    test('should import spools', () async {
      const importData = '{"spools": []}';
      
      final response = await spoolApiService.importSpools(importData);
      
      expect(response.success, true);
      expect(response.data?.totalProcessed, isA<int>());
      expect(response.statusCode, 200);
    });
  });
}