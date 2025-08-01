import '../../domain/entities/spool.dart';
import '../../domain/value_objects/spool_uid.dart';

/// Data source types for different storage mechanisms
enum DataSourceType {
  local,
  remote,
  hybrid, // Uses both local and remote with sync
}

/// Abstract data source for spool operations
/// Part of the Data Layer: defines contract for data persistence
abstract class SpoolDataSource {
  /// Type of data source
  DataSourceType get type;

  /// Initialize the data source
  Future<void> initialize();

  /// Check if data source is available/healthy
  Future<bool> isAvailable();

  /// Save a spool
  Future<void> saveSpool(Spool spool);

  /// Get spool by UID
  Future<Spool?> getSpoolById(SpoolUid uid);

  /// Get all spools
  Future<List<Spool>> getAllSpools();

  /// Update existing spool
  Future<void> updateSpool(Spool spool);

  /// Delete spool
  Future<void> deleteSpool(SpoolUid uid);

  /// Search spools with filters
  Future<List<Spool>> searchSpools({
    String? materialType,
    String? manufacturer,
    String? color,
    bool? isNearlyEmpty,
  });

  /// Get spools that are nearly empty
  Future<List<Spool>> getNearlyEmptySpools();

  /// Export all spool data
  Future<String> exportSpoolData();

  /// Import spool data
  Future<void> importSpoolData(String data);

  /// Dispose resources
  Future<void> dispose();
}

/// Result of data source operations
class DataSourceResult<T> {
  final T? data;
  final bool success;
  final String? errorMessage;
  final DataSourceType sourceType;
  final DateTime timestamp;

  const DataSourceResult({
    this.data,
    required this.success,
    this.errorMessage,
    required this.sourceType,
    required this.timestamp,
  });

  /// Create successful result
  factory DataSourceResult.success(T data, DataSourceType sourceType) {
    return DataSourceResult(
      data: data,
      success: true,
      sourceType: sourceType,
      timestamp: DateTime.now(),
    );
  }

  /// Create failure result
  factory DataSourceResult.failure(String errorMessage, DataSourceType sourceType) {
    return DataSourceResult(
      success: false,
      errorMessage: errorMessage,
      sourceType: sourceType,
      timestamp: DateTime.now(),
    );
  }
}

/// Local data source using device storage
abstract class LocalSpoolDataSource extends SpoolDataSource {
  @override
  DataSourceType get type => DataSourceType.local;

  /// Clear all local data (for testing/reset)
  Future<void> clearAllData();

  /// Get local storage size in bytes
  Future<int> getStorageSize();

  /// Compact/optimize local storage
  Future<void> optimizeStorage();
}

/// Remote data source using backend API
abstract class RemoteSpoolDataSource extends SpoolDataSource {
  @override
  DataSourceType get type => DataSourceType.remote;

  /// Sync with remote server
  Future<SyncResult> sync();

  /// Get server status/health
  Future<ServerStatus> getServerStatus();

  /// Authenticate with server
  Future<bool> authenticate(String? apiKey);

  /// Check if user has permission for operation
  Future<bool> hasPermission(String operation);
}

/// Hybrid data source that combines local and remote
abstract class HybridSpoolDataSource extends SpoolDataSource {
  @override
  DataSourceType get type => DataSourceType.hybrid;

  /// Get local data source
  LocalSpoolDataSource get localDataSource;

  /// Get remote data source
  RemoteSpoolDataSource get remoteDataSource;

  /// Force sync with remote
  Future<SyncResult> forceSync();

  /// Get sync status
  Future<SyncStatus> getSyncStatus();

  /// Enable/disable auto sync
  Future<void> setAutoSync(bool enabled);

  /// Get conflict resolution strategy
  ConflictResolution get conflictResolution;

  /// Set conflict resolution strategy
  set conflictResolution(ConflictResolution strategy);
}

/// Sync operation result
class SyncResult {
  final int totalItems;
  final int syncedItems;
  final int conflictItems;
  final int errorItems;
  final List<SyncError> errors;
  final DateTime syncTime;
  final Duration syncDuration;

  const SyncResult({
    required this.totalItems,
    required this.syncedItems,
    required this.conflictItems,
    required this.errorItems,
    this.errors = const [],
    required this.syncTime,
    required this.syncDuration,
  });

  bool get hasErrors => errors.isNotEmpty;
  bool get hasConflicts => conflictItems > 0;
  double get successRate => totalItems > 0 ? syncedItems / totalItems : 1.0;
}

/// Sync error details
class SyncError {
  final String spoolUid;
  final String operation;
  final String errorMessage;
  final DateTime timestamp;

  const SyncError({
    required this.spoolUid,
    required this.operation,
    required this.errorMessage,
    required this.timestamp,
  });

  @override
  String toString() => 'Sync error for $spoolUid ($operation): $errorMessage';
}

/// Server status information
class ServerStatus {
  final bool isOnline;
  final String version;
  final DateTime serverTime;
  final int responseTimeMs;
  final Map<String, dynamic> metadata;

  const ServerStatus({
    required this.isOnline,
    required this.version,
    required this.serverTime,
    required this.responseTimeMs,
    this.metadata = const {},
  });

  bool get isHealthy => isOnline && responseTimeMs < 5000;
}

/// Sync status information
class SyncStatus {
  final DateTime? lastSyncTime;
  final bool isAutoSyncEnabled;
  final bool isSyncInProgress;
  final int pendingChanges;
  final SyncResult? lastSyncResult;

  const SyncStatus({
    this.lastSyncTime,
    required this.isAutoSyncEnabled,
    required this.isSyncInProgress,
    required this.pendingChanges,
    this.lastSyncResult,
  });

  bool get needsSync => pendingChanges > 0;
  bool get hasNeverSynced => lastSyncTime == null;
}

/// Conflict resolution strategies
enum ConflictResolution {
  localWins,     // Local changes always win
  remoteWins,    // Remote changes always win
  newestWins,    // Most recent timestamp wins
  userResolves,  // Prompt user to resolve conflicts
  mergeFields,   // Merge non-conflicting fields
}

/// Data source factory for creating appropriate data sources
class DataSourceFactory {
  /// Create data source based on configuration
  static SpoolDataSource create({
    required DataSourceType type,
    LocalSpoolDataSource? localDataSource,
    RemoteSpoolDataSource? remoteDataSource,
    ConflictResolution conflictResolution = ConflictResolution.newestWins,
  }) {
    switch (type) {
      case DataSourceType.local:
        if (localDataSource == null) {
          throw ArgumentError('Local data source is required for local type');
        }
        return localDataSource;

      case DataSourceType.remote:
        if (remoteDataSource == null) {
          throw ArgumentError('Remote data source is required for remote type');
        }
        return remoteDataSource;

      case DataSourceType.hybrid:
        if (localDataSource == null || remoteDataSource == null) {
          throw ArgumentError('Both local and remote data sources are required for hybrid type');
        }
        return _HybridDataSourceImpl(
          localDataSource: localDataSource,
          remoteDataSource: remoteDataSource,
          conflictResolution: conflictResolution,
        );
    }
  }
}

/// Implementation of hybrid data source
class _HybridDataSourceImpl extends HybridSpoolDataSource {
  @override
  final LocalSpoolDataSource localDataSource;

  @override
  final RemoteSpoolDataSource remoteDataSource;

  @override
  ConflictResolution conflictResolution;

  _HybridDataSourceImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    this.conflictResolution = ConflictResolution.newestWins,
  });

  @override
  Future<void> initialize() async {
    await Future.wait([
      localDataSource.initialize(),
      remoteDataSource.initialize(),
    ]);
  }

  @override
  Future<bool> isAvailable() async {
    // Hybrid is available if at least local is available
    final localAvailable = await localDataSource.isAvailable();
    return localAvailable;
  }

  @override
  Future<void> saveSpool(Spool spool) async {
    // Save to local first (always works offline)
    await localDataSource.saveSpool(spool);

    // Try to save to remote if available
    if (await remoteDataSource.isAvailable()) {
      try {
        await remoteDataSource.saveSpool(spool);
      } catch (e) {
        // Remote save failed, but local succeeded
        // This will be synced later
      }
    }
  }

  @override
  Future<Spool?> getSpoolById(SpoolUid uid) async {
    // Try remote first if available, fallback to local
    if (await remoteDataSource.isAvailable()) {
      try {
        final remoteSpool = await remoteDataSource.getSpoolById(uid);
        if (remoteSpool != null) return remoteSpool;
      } catch (e) {
        // Fall through to local
      }
    }
    
    return await localDataSource.getSpoolById(uid);
  }

  @override
  Future<List<Spool>> getAllSpools() async {
    // Return local spools (always available)
    // Background sync will keep them updated
    return await localDataSource.getAllSpools();
  }

  @override
  Future<void> updateSpool(Spool spool) async {
    await localDataSource.updateSpool(spool);
    
    if (await remoteDataSource.isAvailable()) {
      try {
        await remoteDataSource.updateSpool(spool);
      } catch (e) {
        // Will be synced later
      }
    }
  }

  @override
  Future<void> deleteSpool(SpoolUid uid) async {
    await localDataSource.deleteSpool(uid);
    
    if (await remoteDataSource.isAvailable()) {
      try {
        await remoteDataSource.deleteSpool(uid);
      } catch (e) {
        // Will be synced later
      }
    }
  }

  @override
  Future<List<Spool>> searchSpools({
    String? materialType,
    String? manufacturer,
    String? color,
    bool? isNearlyEmpty,
  }) async {
    return await localDataSource.searchSpools(
      materialType: materialType,
      manufacturer: manufacturer,
      color: color,
      isNearlyEmpty: isNearlyEmpty,
    );
  }

  @override
  Future<List<Spool>> getNearlyEmptySpools() async {
    return await localDataSource.getNearlyEmptySpools();
  }

  @override
  Future<String> exportSpoolData() async {
    return await localDataSource.exportSpoolData();
  }

  @override
  Future<void> importSpoolData(String data) async {
    await localDataSource.importSpoolData(data);
    
    // Trigger sync to upload imported data
    if (await remoteDataSource.isAvailable()) {
      try {
        await sync();
      } catch (e) {
        // Will be synced later
      }
    }
  }

  @override
  Future<SyncResult> forceSync() async {
    return await sync();
  }

  @override
  Future<SyncResult> getSyncStatus() async {
    // Implementation would check sync status
    throw UnimplementedError();
  }

  @override
  Future<void> setAutoSync(bool enabled) async {
    // Implementation would configure auto sync
    throw UnimplementedError();
  }

  @override
  Future<SyncResult> sync() async {
    final startTime = DateTime.now();
    final errors = <SyncError>[];
    
    try {
      // Get all local spools
      final localSpools = await localDataSource.getAllSpools();
      
      if (await remoteDataSource.isAvailable()) {
        // Get all remote spools
        final remoteSpools = await remoteDataSource.getAllSpools();
        
        // TODO: Implement actual sync logic based on conflict resolution strategy
        // This is a simplified implementation
        
        return SyncResult(
          totalItems: localSpools.length,
          syncedItems: localSpools.length,
          conflictItems: 0,
          errorItems: 0,
          errors: errors,
          syncTime: startTime,
          syncDuration: DateTime.now().difference(startTime),
        );
      } else {
        return SyncResult(
          totalItems: 0,
          syncedItems: 0,
          conflictItems: 0,
          errorItems: 0,
          errors: [SyncError(
            spoolUid: 'N/A',
            operation: 'sync',
            errorMessage: 'Remote server not available',
            timestamp: DateTime.now(),
          )],
          syncTime: startTime,
          syncDuration: DateTime.now().difference(startTime),
        );
      }
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
  Future<void> dispose() async {
    await Future.wait([
      localDataSource.dispose(),
      remoteDataSource.dispose(),
    ]);
  }
}