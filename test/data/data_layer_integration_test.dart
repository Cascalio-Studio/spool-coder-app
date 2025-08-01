import 'package:test/test.dart';
import '../../lib/data/data_layer_factory.dart';
import '../../lib/data/datasources/spool_data_source.dart';

void main() {
  group('Data Layer Integration Tests', () {
    late DataLayerRepositories repositories;

    setUpAll(() async {
      // Initialize data layer with development configuration
      final config = DataLayerConfig.development();
      repositories = await DataLayerInitializer.initialize(config);
    });

    tearDownAll(() async {
      await DataLayerInitializer.dispose();
    });

    test('Can create repositories with factory', () {
      expect(repositories.spoolRepository, isNotNull);
      expect(repositories.profileRepository, isNotNull);
      expect(repositories.rfidReaderRepository, isNotNull);
      expect(repositories.rfidDataRepository, isNotNull);
      expect(repositories.rfidTagLibraryRepository, isNotNull);
    });

    test('Data layer initialization works correctly', () {
      expect(DataLayerInitializer.isInitialized, isTrue);
      expect(DataLayerInitializer.config, isNotNull);
      expect(DataLayerInitializer.repositories, equals(repositories));
    });

    test('Development configuration is valid', () {
      final config = DataLayerConfig.development();
      expect(config.validate(), isNull);
      expect(config.defaultDataSourceType, equals(DataSourceType.local));
      expect(config.enableCaching, isTrue);
      expect(config.enableSync, isFalse);
    });

    test('Production configuration validation works', () {
      final validConfig = DataLayerConfig.production(
        apiBaseUrl: 'https://api.example.com',
        apiKey: 'test-key',
      );
      expect(validConfig.validate(), isNull);

      final invalidConfig = DataLayerConfig.production(
        apiBaseUrl: '', // Invalid empty URL
      );
      expect(invalidConfig.validate(), isNotNull);
    });

    test('Repository creation with different data source types', () {
      // Test local repository creation
      final localRepo = DataLayerFactory.createSpoolRepository(
        type: DataSourceType.local,
      );
      expect(localRepo, isNotNull);

      // Test profile repository creation
      final profileRepo = DataLayerFactory.createProfileRepository();
      expect(profileRepo, isNotNull);

      // Test RFID repositories creation
      final rfidReaderRepo = DataLayerFactory.createRfidReaderRepository();
      expect(rfidReaderRepo, isNotNull);

      final rfidDataRepo = DataLayerFactory.createRfidDataRepository();
      expect(rfidDataRepo, isNotNull);

      final rfidLibraryRepo = DataLayerFactory.createRfidTagLibraryRepository();
      expect(rfidLibraryRepo, isNotNull);
    });

    test('API service creation works', () {
      final apiService = DataLayerFactory.createApiService();
      expect(apiService, isNotNull);

      final spoolApiService = DataLayerFactory.createSpoolApiService();
      expect(spoolApiService, isNotNull);
    });

    test('Local repositories container works', () {
      final localRepos = DataLayerFactory.createLocalRepositories();
      expect(localRepos, isNotNull);
      expect(localRepos.spoolRepository, isNotNull);
      expect(localRepos.profileRepository, isNotNull);
      expect(localRepos.rfidReaderRepository, isNotNull);
      expect(localRepos.rfidDataRepository, isNotNull);
      expect(localRepos.rfidTagLibraryRepository, isNotNull);
    });

    test('Configuration validation catches invalid configurations', () {
      // Test missing API URL for remote type
      final config = DataLayerConfig(
        defaultDataSourceType: DataSourceType.remote,
        // apiBaseUrl: null, // Missing required URL
      );
      expect(config.validate(), isNotNull);

      // Test missing API URL when sync is enabled
      final syncConfig = DataLayerConfig(
        enableSync: true,
        // apiBaseUrl: null, // Missing required URL
      );
      expect(syncConfig.validate(), isNotNull);
    });

    test('Data layer can be reinitialized', () async {
      // Dispose current initialization
      await DataLayerInitializer.dispose();
      expect(DataLayerInitializer.isInitialized, isFalse);

      // Reinitialize with different configuration
      final newConfig = DataLayerConfig.development();
      final newRepositories = await DataLayerInitializer.initialize(newConfig);
      
      expect(DataLayerInitializer.isInitialized, isTrue);
      expect(newRepositories, isNotNull);
      
      // Set up for tearDown
      repositories = newRepositories;
    });

    test('DataSourceType enum works correctly', () {
      expect(DataSourceType.local, isNotNull);
      expect(DataSourceType.remote, isNotNull);
      expect(DataSourceType.hybrid, isNotNull);
      
      expect(DataSourceType.values.length, equals(3));
    });
  });

  group('Configuration Tests', () {
    test('Development configuration has correct defaults', () {
      final config = DataLayerConfig.development();
      
      expect(config.defaultDataSourceType, equals(DataSourceType.local));
      expect(config.apiBaseUrl, isNull);
      expect(config.apiKey, isNull);
      expect(config.enableCaching, isTrue);
      expect(config.enableSync, isFalse);
      expect(config.localStoragePath, isNull);
    });

    test('Production configuration has correct settings', () {
      final config = DataLayerConfig.production(
        apiBaseUrl: 'https://api.bambulab.com',
        apiKey: 'test-api-key',
      );
      
      expect(config.defaultDataSourceType, equals(DataSourceType.hybrid));
      expect(config.apiBaseUrl, equals('https://api.bambulab.com'));
      expect(config.apiKey, equals('test-api-key'));
      expect(config.enableCaching, isTrue);
      expect(config.enableSync, isTrue);
      expect(config.syncInterval, equals(Duration(minutes: 15)));
    });

    test('Custom configuration works', () {
      final config = DataLayerConfig(
        defaultDataSourceType: DataSourceType.hybrid,
        apiBaseUrl: 'https://custom.api.com',
        enableCaching: false,
        enableSync: true,
        syncInterval: Duration(minutes: 30),
        localStoragePath: '/custom/path',
      );
      
      expect(config.defaultDataSourceType, equals(DataSourceType.hybrid));
      expect(config.apiBaseUrl, equals('https://custom.api.com'));
      expect(config.enableCaching, isFalse);
      expect(config.enableSync, isTrue);
      expect(config.syncInterval, equals(Duration(minutes: 30)));
      expect(config.localStoragePath, equals('/custom/path'));
    });
  });
}

// Mock DataSourceType enum for testing
enum DataSourceType {
  local,
  remote,
  hybrid,
}