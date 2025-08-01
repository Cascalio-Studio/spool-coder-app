import 'package:get_it/get_it.dart';
// Import platform interfaces and implementations
import 'package:spool_coder_app/platform/nfc/nfc_platform.dart';
import 'package:spool_coder_app/platform/storage/storage_platform.dart';
import 'package:spool_coder_app/platform/network/network_platform.dart';
import 'package:spool_coder_app/platform/permissions/permissions_platform.dart';
import 'package:spool_coder_app/platform/device/device_platform.dart';

// Import backend and data layer services
import '../config/app_config.dart';
import '../../data/services/api_service.dart';
import '../../data/services/sync_service.dart';
import '../../data/datasources/spool_data_source.dart';
import '../../data/datasources/local_spool_data_source.dart';
import '../../data/datasources/remote_spool_data_source.dart';
import '../../data/repositories/spool_repository.dart';
import '../../domain/repositories/spool_repository.dart' as domain;

/// Global service locator
final GetIt locator = GetIt.instance;

/// Register all services and repositories here
void setupLocator({AppConfig? config}) {
  final appConfig = config ?? AppConfig.defaultLocal;
  
  // Register app configuration
  locator.registerSingleton<AppConfig>(appConfig);
  
  // Register platform implementations
  locator.registerLazySingleton<NfcPlatformInterface>(
    () => NfcPlatformImpl(),
  );
  
  locator.registerLazySingleton<StoragePlatformInterface>(
    () => StoragePlatformImpl(),
  );
  
  locator.registerLazySingleton<NetworkPlatformInterface>(
    () => NetworkPlatformImpl(),
  );
  
  locator.registerLazySingleton<PermissionsPlatformInterface>(
    () => PermissionsPlatformImpl(),
  );
  
  locator.registerLazySingleton<DevicePlatformInterface>(
    () => DevicePlatformImpl(),
  );
  
  // Register API services (only if backend is enabled)
  if (appConfig.isBackendEnabled) {
    locator.registerLazySingleton<ApiService>(
      () {
        final apiService = HttpApiService();
        apiService.initialize(appConfig.backend);
        return apiService;
      },
    );
    
    locator.registerLazySingleton<SpoolApiService>(
      () {
        final spoolApiService = HttpSpoolApiService();
        spoolApiService.initialize(locator<ApiService>());
        return spoolApiService;
      },
    );
  }
  
  // Register data sources
  locator.registerLazySingleton<LocalSpoolDataSource>(
    () {
      final dataSource = LocalSpoolDataSourceImpl();
      dataSource.initialize();
      return dataSource;
    },
  );
  
  if (appConfig.isBackendEnabled) {
    locator.registerLazySingleton<RemoteSpoolDataSource>(
      () {
        final dataSource = RemoteSpoolDataSourceImpl();
        dataSource.initializeWithServices(
          locator<ApiService>(),
          locator<SpoolApiService>(),
        );
        return dataSource;
      },
    );
    
    // Register hybrid data source when backend is enabled
    locator.registerLazySingleton<SpoolDataSource>(
      () => DataSourceFactory.create(
        type: DataSourceType.hybrid,
        localDataSource: locator<LocalSpoolDataSource>(),
        remoteDataSource: locator<RemoteSpoolDataSource>(),
      ),
    );
    
    // Register sync service for backend-enabled configurations
    locator.registerLazySingleton<SyncService>(
      () {
        final hybridDataSource = locator<SpoolDataSource>() as HybridSpoolDataSource;
        final syncService = SyncServiceImpl(hybridDataSource);
        syncService.initialize(appConfig);
        return syncService;
      },
    );
  } else {
    // Register local-only data source when backend is disabled
    locator.registerLazySingleton<SpoolDataSource>(
      () => locator<LocalSpoolDataSource>(),
    );
  }
  
  // Register repository implementation
  locator.registerLazySingleton<domain.SpoolRepository>(
    () => SpoolRepositoryImpl(
      dataSource: locator<SpoolDataSource>(),
    ),
  );
  
  // TODO: Register other core services (e.g., logging)
}

/// Update configuration at runtime
void updateConfiguration(AppConfig newConfig) {
  // Unregister existing instances
  if (locator.isRegistered<AppConfig>()) {
    locator.unregister<AppConfig>();
  }
  
  // Clear dependent services that need reconfiguration
  _clearBackendServices();
  
  // Re-register with new configuration
  setupLocator(config: newConfig);
}

/// Clear backend-related services for reconfiguration
void _clearBackendServices() {
  final servicesToClear = [
    ApiService,
    SpoolApiService,
    RemoteSpoolDataSource,
    SyncService,
    SpoolDataSource,
    domain.SpoolRepository,
  ];
  
  for (final serviceType in servicesToClear) {
    if (locator.isRegistered(instance: serviceType)) {
      locator.unregister(instance: serviceType);
    }
  }
}
