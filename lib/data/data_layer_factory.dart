import 'datasources/spool_data_source.dart';
import 'datasources/local_spool_data_source.dart';
import 'datasources/remote_spool_data_source.dart';
import 'datasources/profile_data_source.dart';
import 'datasources/rfid_data_source.dart';
import 'services/api_service.dart';
import 'repositories/spool_repository.dart';
import 'repositories/profile_repository_impl.dart';
import 'repositories/rfid_repositories_impl.dart';
import '../domain/repositories/spool_repository.dart' as domain;
import '../domain/repositories/profile_repository.dart';
import '../domain/repositories/rfid_repositories.dart';

/// Factory for creating data layer components with proper dependency injection
/// Part of the Data Layer: handles instantiation and configuration
class DataLayerFactory {
  /// Create a configured spool repository with appropriate data sources
  static domain.SpoolRepository createSpoolRepository({
    DataSourceType type = DataSourceType.local,
    ApiService? apiService,
    SpoolApiService? spoolApiService,
  }) {
    SpoolDataSource dataSource;
    
    switch (type) {
      case DataSourceType.local:
        dataSource = LocalSpoolDataSourceImpl();
        break;
        
      case DataSourceType.remote:
        if (apiService == null || spoolApiService == null) {
          throw ArgumentError('API services are required for remote data source');
        }
        final remoteDataSource = RemoteSpoolDataSourceImpl();
        // Initialize with services would need to be done
        dataSource = remoteDataSource;
        break;
        
      case DataSourceType.hybrid:
        final localDataSource = LocalSpoolDataSourceImpl();
        final remoteDataSource = RemoteSpoolDataSourceImpl();
        
        dataSource = DataSourceFactory.create(
          type: DataSourceType.hybrid,
          localDataSource: localDataSource,
          remoteDataSource: remoteDataSource,
        );
        break;
    }
    
    return SpoolRepositoryImpl(dataSource: dataSource);
  }

  /// Create a profile repository with local data source
  static SpoolProfileRepository createProfileRepository() {
    final dataSource = LocalProfileDataSource();
    return SpoolProfileRepositoryImpl(dataSource: dataSource);
  }

  /// Create RFID reader repository with mock implementation
  static RfidReaderRepository createRfidReaderRepository() {
    final dataSource = MockRfidReaderDataSource();
    return RfidReaderRepositoryImpl(dataSource: dataSource);
  }

  /// Create RFID data repository with local storage
  static RfidDataRepository createRfidDataRepository() {
    final dataStorage = LocalRfidDataStorage();
    return RfidDataRepositoryImpl(dataStorage: dataStorage);
  }

  /// Create RFID tag library repository with local implementation
  static RfidTagLibraryRepository createRfidTagLibraryRepository() {
    final dataSource = LocalRfidTagLibraryDataSource();
    return RfidTagLibraryRepositoryImpl(dataSource: dataSource);
  }

  /// Create API service with HTTP implementation
  static ApiService createApiService() {
    return HttpApiService();
  }

  /// Create spool API service with HTTP implementation
  static SpoolApiService createSpoolApiService() {
    return HttpSpoolApiService();
  }

  /// Create all repositories configured for local development
  static DataLayerRepositories createLocalRepositories() {
    return DataLayerRepositories(
      spoolRepository: createSpoolRepository(type: DataSourceType.local),
      profileRepository: createProfileRepository(),
      rfidReaderRepository: createRfidReaderRepository(),
      rfidDataRepository: createRfidDataRepository(),
      rfidTagLibraryRepository: createRfidTagLibraryRepository(),
    );
  }

  /// Create all repositories configured for production with backend
  static Future<DataLayerRepositories> createProductionRepositories({
    required String apiBaseUrl,
    String? apiKey,
  }) async {
    final apiService = createApiService();
    final spoolApiService = createSpoolApiService();
    
    // Initialize API service with configuration
    // This would use the actual backend configuration
    
    return DataLayerRepositories(
      spoolRepository: createSpoolRepository(
        type: DataSourceType.hybrid,
        apiService: apiService,
        spoolApiService: spoolApiService,
      ),
      profileRepository: createProfileRepository(), // Could be remote too
      rfidReaderRepository: createRfidReaderRepository(),
      rfidDataRepository: createRfidDataRepository(),
      rfidTagLibraryRepository: createRfidTagLibraryRepository(),
    );
  }

  /// Initialize all data sources
  static Future<void> initializeDataSources(DataLayerRepositories repositories) async {
    // Initialize all repositories that need setup
    final futures = <Future<void>>[];
    
    // Add initialization calls for each repository's data sources
    // This would be customized based on actual initialization needs
    
    await Future.wait(futures);
  }
}

/// Container for all data layer repositories
class DataLayerRepositories {
  final domain.SpoolRepository spoolRepository;
  final SpoolProfileRepository profileRepository;
  final RfidReaderRepository rfidReaderRepository;
  final RfidDataRepository rfidDataRepository;
  final RfidTagLibraryRepository rfidTagLibraryRepository;

  const DataLayerRepositories({
    required this.spoolRepository,
    required this.profileRepository,
    required this.rfidReaderRepository,
    required this.rfidDataRepository,
    required this.rfidTagLibraryRepository,
  });

  /// Dispose all repositories
  Future<void> dispose() async {
    // Dispose all repositories if they have dispose methods
    // This would be customized based on actual disposal needs
  }
}

/// Configuration for data layer
class DataLayerConfig {
  final DataSourceType defaultDataSourceType;
  final String? apiBaseUrl;
  final String? apiKey;
  final bool enableCaching;
  final bool enableSync;
  final Duration syncInterval;
  final String? localStoragePath;

  const DataLayerConfig({
    this.defaultDataSourceType = DataSourceType.local,
    this.apiBaseUrl,
    this.apiKey,
    this.enableCaching = true,
    this.enableSync = false,
    this.syncInterval = const Duration(minutes: 15),
    this.localStoragePath,
  });

  /// Create development configuration
  factory DataLayerConfig.development() {
    return const DataLayerConfig(
      defaultDataSourceType: DataSourceType.local,
      enableCaching: true,
      enableSync: false,
    );
  }

  /// Create production configuration
  factory DataLayerConfig.production({
    required String apiBaseUrl,
    String? apiKey,
  }) {
    return DataLayerConfig(
      defaultDataSourceType: DataSourceType.hybrid,
      apiBaseUrl: apiBaseUrl,
      apiKey: apiKey,
      enableCaching: true,
      enableSync: true,
      syncInterval: const Duration(minutes: 15),
    );
  }

  /// Validate configuration
  String? validate() {
    if (defaultDataSourceType == DataSourceType.remote || 
        defaultDataSourceType == DataSourceType.hybrid) {
      if (apiBaseUrl == null || apiBaseUrl!.isEmpty) {
        return 'API base URL is required for remote/hybrid data sources';
      }
    }
    
    if (enableSync && apiBaseUrl == null) {
      return 'API base URL is required when sync is enabled';
    }
    
    return null; // Valid
  }
}

/// Data layer initialization helper
class DataLayerInitializer {
  static DataLayerRepositories? _repositories;
  static DataLayerConfig? _config;

  /// Initialize data layer with configuration
  static Future<DataLayerRepositories> initialize(DataLayerConfig config) async {
    _config = config;
    
    // Validate configuration
    final validationError = config.validate();
    if (validationError != null) {
      throw ArgumentError('Invalid data layer configuration: $validationError');
    }

    // Create repositories based on configuration
    if (config.defaultDataSourceType == DataSourceType.local) {
      _repositories = DataLayerFactory.createLocalRepositories();
    } else {
      _repositories = await DataLayerFactory.createProductionRepositories(
        apiBaseUrl: config.apiBaseUrl!,
        apiKey: config.apiKey,
      );
    }

    // Initialize data sources
    await DataLayerFactory.initializeDataSources(_repositories!);

    return _repositories!;
  }

  /// Get initialized repositories
  static DataLayerRepositories get repositories {
    if (_repositories == null) {
      throw StateError('Data layer not initialized. Call initialize() first.');
    }
    return _repositories!;
  }

  /// Get current configuration
  static DataLayerConfig get config {
    if (_config == null) {
      throw StateError('Data layer not initialized. Call initialize() first.');
    }
    return _config!;
  }

  /// Dispose data layer
  static Future<void> dispose() async {
    if (_repositories != null) {
      await _repositories!.dispose();
      _repositories = null;
    }
    _config = null;
  }

  /// Check if data layer is initialized
  static bool get isInitialized => _repositories != null;
}