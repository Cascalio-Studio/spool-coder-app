# Backend Integration Guide

This guide explains how to configure and use the backend integration features in the Spool Coder app.

## Overview

The app is designed to work **local-first** with optional backend integration. You can:

- Run completely offline (default mode)
- Enable backend sync while maintaining offline capability
- Switch between modes at runtime
- Handle backend outages gracefully with automatic fallback

## Quick Start

### Local-Only Mode (Default)

```dart
import 'package:spool_coder_app/core/config/app_config.dart';
import 'package:spool_coder_app/core/di/injector.dart';

void main() async {
  // Default configuration - works entirely offline
  const config = AppConfig.defaultLocal;
  setupLocator(config: config);
  
  // Your app code - all operations are local
  final repository = locator<SpoolRepository>();
  await repository.saveSpool(mySpool);
}
```

### Backend-Enabled Mode

```dart
void main() async {
  // Enable backend with your API configuration
  final config = AppConfig.withBackend(
    baseUrl: 'https://your-api.com',
    apiKey: 'your-api-key',
    enableAutoSync: true,
    syncInterval: Duration(minutes: 15),
  );
  setupLocator(config: config);
  
  // Same repository interface, now with backend sync
  final repository = locator<SpoolRepository>();
  final syncService = locator<SyncService>();
  
  // Operations automatically sync with backend
  await repository.saveSpool(mySpool);
  
  // Monitor sync status
  syncService.syncStatusStream.listen((status) {
    print('Pending changes: ${status.pendingChanges}');
  });
}
```

## Configuration Options

### Environment-Based Configuration

```dart
// Load configuration from environment variables
final config = ConfigFactory.fromEnvironment();

// Or use predefined environments
final config = ConfigFactory.forEnvironment(Environment.production);
```

### Environment Variables

Set these environment variables to configure backend:

```bash
export ENABLE_BACKEND=true
export BACKEND_URL=https://api.spoolcoder.com
export API_KEY=your-secret-api-key
```

### Runtime Configuration Changes

```dart
// Start local-only
setupLocator(config: AppConfig.defaultLocal);

// Later, switch to backend mode
final backendConfig = AppConfig.withBackend(
  baseUrl: 'https://api.spoolcoder.com',
  apiKey: 'your-key',
);
updateConfiguration(backendConfig);

// All services are automatically reconfigured
```

## Backend API Requirements

To integrate with a custom backend, implement these endpoints:

### Authentication
- `POST /api/v1/auth` - Authenticate with API key

### Spool Management
- `GET /api/v1/spools` - Get all spools
- `GET /api/v1/spools/{id}` - Get spool by ID
- `POST /api/v1/spools` - Create new spool
- `PUT /api/v1/spools/{id}` - Update spool
- `DELETE /api/v1/spools/{id}` - Delete spool
- `GET /api/v1/spools/search` - Search spools

### Synchronization
- `POST /api/v1/spools/sync` - Bidirectional sync
- `GET /api/v1/spools/sync/status` - Get sync status

### Data Management
- `GET /api/v1/spools/export` - Export data
- `POST /api/v1/spools/import` - Import data

### Health Check
- `GET /api/v1/health` - API health status
- `GET /api/v1/ping` - Simple connectivity test

## Data Flow

```
User Action
    ↓
Repository Interface (Domain)
    ↓
┌─────────────────┐    ┌─────────────────┐
│   Local Mode    │    │  Backend Mode   │
│                 │    │                 │
│ LocalDataSource │    │ HybridDataSource│
│       ↓         │    │    ↓        ↓   │
│ Local Storage   │    │Local     Remote │
└─────────────────┘    │Storage     API  │
                       │              ↓   │
                       │         Background│
                       │            Sync  │
                       └─────────────────┘
```

## Sync Behavior

### Hybrid Mode Operations

| Operation | Behavior |
|-----------|----------|
| Save | Saves to local first, then syncs to remote |
| Read | Reads from local cache (fast) |
| Search | Searches local data |
| Sync | Bidirectional sync with conflict resolution |

### Conflict Resolution

When the same spool is modified both locally and remotely:

```dart
enum ConflictResolution {
  localWins,     // Local changes win
  remoteWins,    // Remote changes win
  newestWins,    // Most recent timestamp wins
  userResolves,  // Prompt user to choose
  mergeFields,   // Merge non-conflicting fields
}
```

Configure conflict resolution:

```dart
final dataSource = DataSourceFactory.create(
  type: DataSourceType.hybrid,
  localDataSource: localDS,
  remoteDataSource: remoteDS,
  conflictResolution: ConflictResolution.newestWins,
);
```

## Error Handling

The architecture handles various error scenarios gracefully:

### Backend Unavailable
- Operations continue using local storage
- Changes are queued for later sync
- Automatic retry with exponential backoff

### Network Intermittent
- Transparent fallback to local operations
- Automatic sync when connection restored
- No user intervention required

### API Errors
- Failed requests don't affect local data
- Detailed error reporting for debugging
- Graceful degradation to offline mode

## Monitoring and Observability

### Sync Status Monitoring

```dart
final syncService = locator<SyncService>();

// Listen to sync status changes
syncService.syncStatusStream.listen((status) {
  if (status.needsSync) {
    print('${status.pendingChanges} changes need sync');
  }
  
  if (status.isSyncInProgress) {
    print('Sync in progress...');
  }
});

// Listen to sync results
syncService.syncResultStream.listen((result) {
  if (result.hasErrors) {
    print('Sync errors: ${result.errors.length}');
  }
  
  if (result.hasConflicts) {
    print('Conflicts: ${result.conflictItems}');
  }
});
```

### Backend Health Monitoring

```dart
final apiService = locator<ApiService>();

// Check backend availability
final isAvailable = await apiService.isAvailable();

// Get detailed health status
final healthResponse = await apiService.getHealth();
if (healthResponse.success) {
  final health = healthResponse.data!;
  print('Server status: ${health['status']}');
  print('Response time: ${health['responseTime']}ms');
}
```

## Testing

### Local Development
```dart
// Use local-only configuration for fast development
const config = AppConfig.defaultLocal;
setupLocator(config: config);
```

### Integration Testing
```dart
// Test with mock backend
final config = AppConfig.withBackend(
  baseUrl: 'http://localhost:3000',
  apiKey: 'test-key',
);
setupLocator(config: config);
```

### Production Testing
```dart
// Test against staging backend
final config = ConfigFactory.forEnvironment(Environment.staging);
setupLocator(config: config);
```

## Security Considerations

- API keys are never hardcoded
- All backend communication uses HTTPS
- Local data can be encrypted at rest
- Authentication tokens have expiration
- Sync operations are logged for audit

## Performance Optimization

- Local operations are always fast (no network)
- Background sync doesn't block UI
- Efficient incremental sync (only changed data)
- Configurable sync intervals
- Automatic batch operations for efficiency

## Deployment Options

### Phase 1: Local-Only
Deploy with default configuration - no backend required.

### Phase 2: Gradual Rollout
Enable backend for subset of users via feature flags.

### Phase 3: Full Backend
Enable backend for all users with fallback to local.

### Phase 4: Cloud-First
Optimize for cloud-first usage while maintaining offline capability.

## Troubleshooting

### Common Issues

**"Backend not available"**
- Check network connectivity
- Verify API endpoint URL
- Confirm API key is valid

**"Sync conflicts"**
- Review conflict resolution strategy
- Check for concurrent modifications
- Consider adjusting sync frequency

**"Local storage full"**
- Implement periodic cleanup
- Use export/import for data archival
- Monitor storage usage

### Debug Logging

Enable debug logging to troubleshoot issues:

```dart
// Enable debug logging in development
debugPrint('Backend configuration: ${config.backend.baseUrl}');
debugPrint('Sync status: ${await syncService.getSyncStatus()}');
```

## Migration Guide

### From Local-Only to Backend-Enabled

1. **Prepare Backend**: Set up API endpoints
2. **Update Configuration**: Add backend configuration
3. **Test Integration**: Verify sync functionality
4. **Deploy Gradually**: Roll out to subset of users
5. **Monitor**: Watch for sync issues and errors
6. **Full Rollout**: Enable for all users

### Data Migration

```dart
// Export existing local data
final localData = await repository.exportSpoolData();

// Configure backend
updateConfiguration(backendConfig);

// Import data to backend
await repository.importSpoolData(localData);

// Verify sync
final syncResult = await syncService.syncNow();
```

## Best Practices

1. **Always support offline mode** - Users expect the app to work anywhere
2. **Sync in background** - Don't block user interactions
3. **Handle conflicts gracefully** - Provide clear resolution options
4. **Monitor sync health** - Alert on persistent sync failures
5. **Test offline scenarios** - Verify graceful degradation
6. **Use incremental sync** - Only sync changed data
7. **Implement retry logic** - Handle temporary network issues
8. **Secure API communication** - Use HTTPS and proper authentication
9. **Log sync operations** - For debugging and audit purposes
10. **Provide sync status UI** - Keep users informed of sync state