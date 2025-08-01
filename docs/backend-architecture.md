# Backend Integration Architecture

This document describes the modular backend integration architecture that allows the spool coder app to work both offline-only and with optional backend synchronization.

## Overview

The architecture is designed with the following principles:

1. **Local-First**: The app works fully offline by default
2. **Optional Backend**: Backend integration can be enabled/disabled at runtime
3. **Graceful Degradation**: If backend is unavailable, app falls back to local-only mode
4. **Transparent Sync**: Data synchronization happens transparently in the background
5. **Modular Design**: Easy to swap different backend implementations

## Architecture Components

### 1. Configuration Layer (`lib/core/config/`)

#### AppConfig
Central configuration class that controls backend behavior:

```dart
// Local-only mode (default)
const config = AppConfig.defaultLocal;

// Backend-enabled mode
final config = AppConfig.withBackend(
  baseUrl: 'https://api.spoolcoder.com',
  apiKey: 'your-api-key',
  enableAutoSync: true,
  syncInterval: Duration(minutes: 15),
);
```

#### Environment-Specific Configurations
```dart
// Development (local-only)
final config = ConfigFactory.forEnvironment(Environment.development);

// Production (with backend)
final config = ConfigFactory.forEnvironment(Environment.production);

// From environment variables
final config = ConfigFactory.fromEnvironment();
```

### 2. Data Source Abstraction (`lib/data/datasources/`)

#### SpoolDataSource Interface
Common interface for all data storage mechanisms:

```dart
abstract class SpoolDataSource {
  DataSourceType get type; // local, remote, or hybrid
  Future<void> saveSpool(Spool spool);
  Future<Spool?> getSpoolById(SpoolUid uid);
  Future<List<Spool>> getAllSpools();
  // ... other CRUD operations
}
```

#### Implementation Types

1. **LocalSpoolDataSource**: Device storage (SQLite, files, etc.)
2. **RemoteSpoolDataSource**: Backend API communication
3. **HybridSpoolDataSource**: Combines local + remote with sync

### 3. API Services (`lib/data/services/`)

#### ApiService
Low-level HTTP client for backend communication:

```dart
abstract class ApiService {
  Future<ApiResponse<T>> get<T>(String endpoint);
  Future<ApiResponse<T>> post<T>(String endpoint, {dynamic body});
  Future<bool> isAvailable();
  Future<ApiResponse<AuthResult>> authenticate(String apiKey);
}
```

#### SpoolApiService
High-level spool-specific API operations:

```dart
abstract class SpoolApiService {
  Future<ApiResponse<List<Map<String, dynamic>>>> getAllSpools();
  Future<ApiResponse<Map<String, dynamic>>> createSpool(Map<String, dynamic> data);
  Future<ApiResponse<SyncResponse>> syncSpools(List<Map<String, dynamic>> localSpools);
}
```

### 4. Synchronization Service (`lib/data/services/sync_service.dart`)

Handles bidirectional sync between local and remote data:

```dart
abstract class SyncService {
  Future<SyncResult> syncNow();
  Future<void> startAutoSync();
  Future<void> stopAutoSync();
  Stream<SyncStatus> get syncStatusStream;
  Future<void> resolveConflicts(List<ConflictResolution> resolutions);
}
```

#### Conflict Resolution Strategies
- `localWins`: Local changes take precedence
- `remoteWins`: Remote changes take precedence  
- `newestWins`: Most recent timestamp wins
- `userResolves`: Prompt user to resolve conflicts
- `mergeFields`: Merge non-conflicting fields

### 5. Dependency Injection (`lib/core/di/injector.dart`)

Configuration-driven service registration:

```dart
void setupLocator({AppConfig? config}) {
  final appConfig = config ?? AppConfig.defaultLocal;
  
  // Register configuration
  locator.registerSingleton<AppConfig>(appConfig);
  
  // Register data sources based on configuration
  if (appConfig.isBackendEnabled) {
    // Register API services, sync service, hybrid data source
  } else {
    // Register local-only data source
  }
  
  // Repository always uses the configured data source
  locator.registerLazySingleton<SpoolRepository>(
    () => SpoolRepositoryImpl(dataSource: locator<SpoolDataSource>()),
  );
}
```

## Usage Examples

### 1. Local-Only Operation

```dart
void main() async {
  // Configure for local-only
  const config = AppConfig.defaultLocal;
  setupLocator(config: config);
  
  // Use repository normally - all operations are local
  final repository = locator<SpoolRepository>();
  final spools = await repository.getAllSpools();
}
```

### 2. Backend-Enabled Operation

```dart
void main() async {
  // Configure with backend
  final config = AppConfig.withBackend(
    baseUrl: 'https://api.spoolcoder.com',
    apiKey: 'your-api-key',
    enableAutoSync: true,
  );
  setupLocator(config: config);
  
  // Use repository normally - operations sync with backend
  final repository = locator<SpoolRepository>();
  final syncService = locator<SyncService>();
  
  // Repository operations work the same
  await repository.saveSpool(spool);
  
  // Monitor sync status
  syncService.syncStatusStream.listen((status) {
    print('Sync status: ${status.pendingChanges} pending changes');
  });
}
```

### 3. Runtime Configuration Changes

```dart
// Start local-only
setupLocator(config: AppConfig.defaultLocal);

// Later, switch to backend mode
final backendConfig = AppConfig.withBackend(
  baseUrl: 'https://api.example.com',
  apiKey: 'api-key',
);
updateConfiguration(backendConfig);

// All services are now reconfigured for backend operation
```

### 4. Handling Backend Unavailability

```dart
// Even with backend configured, app works offline
final config = AppConfig.withBackend(
  baseUrl: 'https://api.spoolcoder.com',
  apiKey: 'your-api-key',
  enableOfflineMode: true, // This is the default
);

// When backend is down:
// - Reads come from local cache
// - Writes go to local storage
// - Sync service queues changes for later
// - App continues working normally
```

## Data Flow

```
User Action
    ↓
Repository (Domain Layer)
    ↓
SpoolDataSource (Data Layer)
    ↓
┌─ Local-Only Mode ─┐  ┌─ Backend Mode ─┐
│  LocalDataSource  │  │ HybridDataSource│
│        ↓          │  │     ↓        ↓  │
│   Local Storage   │  │Local Store  API │
└───────────────────┘  └─────────────────┘
                              ↓
                         Sync Service
                              ↓
                        Background Sync
```

## Benefits

1. **Flexibility**: Easy to switch between local and backend modes
2. **Reliability**: Always works offline, backend is enhancement
3. **Performance**: Local operations are fast, sync happens in background  
4. **Testing**: Easy to test with local-only configuration
5. **Deployment**: Can deploy without backend initially
6. **Scalability**: Can add backend features incrementally

## Migration Path

1. **Phase 1**: Local-only app (current state)
2. **Phase 2**: Add backend configuration and API services
3. **Phase 3**: Implement hybrid data source with basic sync
4. **Phase 4**: Add conflict resolution and advanced sync features
5. **Phase 5**: Add real-time features, push notifications, etc.

## Testing Strategy

- **Unit Tests**: Test each component in isolation
- **Integration Tests**: Test configuration and service wiring
- **End-to-End Tests**: Test complete user workflows
- **Network Tests**: Test behavior with/without network connectivity
- **Sync Tests**: Test conflict resolution and data consistency

## Security Considerations

- API keys are configurable and not hardcoded
- HTTPS required for all backend communication
- Local data can be encrypted at rest
- Authentication tokens have expiration
- Sync conflicts are logged for audit purposes

## Future Enhancements

- Real-time sync with WebSockets
- Offline-first sync with CRDTs
- Multi-user support with user authentication
- Cloud backup and restore
- Analytics and usage tracking
- Push notifications for sync events