import 'package:test/test.dart';
import '../../lib/core/config/app_config.dart';
import '../../lib/core/di/injector.dart';
import '../../lib/data/services/api_service.dart';
import '../../lib/data/services/sync_service.dart';
import '../../lib/data/datasources/spool_data_source.dart';
import '../../lib/domain/repositories/spool_repository.dart';

/// Integration test demonstrating the backend architecture
/// Tests the complete flow from configuration to data access
void main() {
  group('Backend Integration', () {
    setUp(() {
      // Clear any existing registrations
      locator.reset();
    });

    test('should configure app for local-only operation', () async {
      // Configure for local-only
      const config = AppConfig.defaultLocal;
      setupLocator(config: config);
      
      // Verify configuration
      final appConfig = locator<AppConfig>();
      expect(appConfig.isBackendEnabled, false);
      expect(appConfig.canWorkOffline, true);
      
      // Verify data source is local-only
      final dataSource = locator<SpoolDataSource>();
      expect(dataSource.type, DataSourceType.local);
      
      // Verify repository works with local data source
      final repository = locator<SpoolRepository>();
      expect(repository, isNotNull);
      
      // Test basic operations work
      final allSpools = await repository.getAllSpools();
      expect(allSpools, isEmpty); // Should start empty
    });

    test('should configure app for backend operation', () async {
      // Configure with backend enabled
      final config = AppConfig.withBackend(
        baseUrl: 'https://api.example.com',
        apiKey: 'test-key',
        enableAutoSync: true,
      );
      setupLocator(config: config);
      
      // Verify configuration
      final appConfig = locator<AppConfig>();
      expect(appConfig.isBackendEnabled, true);
      expect(appConfig.enableAutoSync, true);
      
      // Verify backend services are registered
      expect(locator.isRegistered<ApiService>(), true);
      expect(locator.isRegistered<SyncService>(), true);
      
      // Verify data source is hybrid
      final dataSource = locator<SpoolDataSource>();
      expect(dataSource.type, DataSourceType.hybrid);
      
      // Verify repository works with hybrid data source
      final repository = locator<SpoolRepository>();
      expect(repository, isNotNull);
    });

    test('should support runtime configuration changes', () async {
      // Start with local-only
      const localConfig = AppConfig.defaultLocal;
      setupLocator(config: localConfig);
      
      var appConfig = locator<AppConfig>();
      expect(appConfig.isBackendEnabled, false);
      
      // Switch to backend-enabled
      final backendConfig = AppConfig.withBackend(
        baseUrl: 'https://api.example.com',
        apiKey: 'test-key',
      );
      updateConfiguration(backendConfig);
      
      appConfig = locator<AppConfig>();
      expect(appConfig.isBackendEnabled, true);
      
      // Verify services were reconfigured
      expect(locator.isRegistered<ApiService>(), true);
      expect(locator.isRegistered<SyncService>(), true);
      
      final dataSource = locator<SpoolDataSource>();
      expect(dataSource.type, DataSourceType.hybrid);
    });

    test('should handle backend unavailability gracefully', () async {
      // Configure with backend but it's unavailable
      final config = AppConfig.withBackend(
        baseUrl: 'https://unreachable.example.com',
        apiKey: 'test-key',
      );
      setupLocator(config: config);
      
      final dataSource = locator<SpoolDataSource>() as HybridSpoolDataSource;
      
      // Hybrid data source should still work (falls back to local)
      expect(await dataSource.isAvailable(), true); // Local is always available
      
      // Repository operations should work even if backend is down
      final repository = locator<SpoolRepository>();
      final allSpools = await repository.getAllSpools();
      expect(allSpools, isEmpty); // Should return local data
    });

    test('should demonstrate data flow architecture', () async {
      // Set up backend configuration
      final config = AppConfig.withBackend(
        baseUrl: 'https://api.example.com',
        apiKey: 'test-key',
      );
      setupLocator(config: config);
      
      // Get services from DI container
      final repository = locator<SpoolRepository>();
      final dataSource = locator<SpoolDataSource>() as HybridSpoolDataSource;
      final apiService = locator<ApiService>();
      final syncService = locator<SyncService>();
      
      // Verify service dependencies
      expect(repository, isNotNull);
      expect(dataSource.localDataSource, isNotNull);
      expect(dataSource.remoteDataSource, isNotNull);
      expect(apiService, isNotNull);
      expect(syncService, isNotNull);
      
      // Test that services can communicate
      expect(await apiService.isAvailable(), true);
      expect(await dataSource.isAvailable(), true);
      
      // Test sync status
      final syncStatus = await syncService.getSyncStatus();
      expect(syncStatus.isAutoSyncEnabled, true);
    });
  });

  group('Configuration Factory', () {
    test('should create environment-specific configurations', () {
      final devConfig = ConfigFactory.forEnvironment(Environment.development);
      final prodConfig = ConfigFactory.forEnvironment(Environment.production);
      
      // Development should be local-only
      expect(devConfig.isBackendEnabled, false);
      expect(devConfig.enableAutoSync, false);
      
      // Production should have backend
      expect(prodConfig.isBackendEnabled, true);
      expect(prodConfig.enableAutoSync, true);
      expect(prodConfig.backend.baseUrl, 'https://api.spoolcoder.com');
    });

    test('should load configuration from environment', () {
      // This would test environment variable loading
      // In a real test, you'd set up test environment variables
      final config = ConfigFactory.fromEnvironment();
      
      // With no environment variables, should default to local
      expect(config.isBackendEnabled, false);
    });
  });
}