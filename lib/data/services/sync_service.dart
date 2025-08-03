import 'dart:async';
import '../datasources/spool_data_source.dart';
import '../../core/config/app_config.dart';
import '../../domain/entities/spool.dart';

/// Service for synchronizing data between local and remote sources
/// Part of the Data Layer: handles bidirectional sync operations
abstract class SyncService {
  /// Initialize sync service with configuration
  Future<void> initialize(AppConfig config);

  /// Start automatic synchronization
  Future<void> startAutoSync();

  /// Stop automatic synchronization
  Future<void> stopAutoSync();

  /// Perform manual sync
  Future<SyncResult> syncNow();

  /// Get current sync status
  Future<SyncStatus> getSyncStatus();

  /// Check if sync is needed
  Future<bool> needsSync();

  /// Stream of sync status updates
  Stream<SyncStatus> get syncStatusStream;

  /// Stream of sync results
  Stream<SyncResult> get syncResultStream;

  /// Force full sync (ignores timestamps)
  Future<SyncResult> forceFullSync();

  /// Resolve sync conflicts
  Future<void> resolveConflicts(List<BatchConflictResolution> resolutions);

  /// Get pending conflicts
  Future<List<SyncConflict>> getPendingConflicts();

  /// Dispose resources
  Future<void> dispose();
}

/// Sync conflict information
class SyncConflict {
  final String spoolUid;
  final Spool localVersion;
  final Spool remoteVersion;
  final DateTime conflictTime;
  final ConflictType type;

  const SyncConflict({
    required this.spoolUid,
    required this.localVersion,
    required this.remoteVersion,
    required this.conflictTime,
    required this.type,
  });
}

/// Types of sync conflicts
enum ConflictType {
  bothModified,    // Both local and remote were modified
  deletedLocally,  // Deleted locally but modified remotely
  deletedRemotely, // Deleted remotely but modified locally
  duplicate,       // Duplicate entries with different UIDs
}

/// Implementation of sync service
class SyncServiceImpl implements SyncService {
  final HybridSpoolDataSource _dataSource;
  
  AppConfig? _config;
  Timer? _syncTimer;
  bool _isAutoSyncEnabled = false;
  bool _isSyncInProgress = false;
  
  final StreamController<SyncStatus> _syncStatusController = StreamController<SyncStatus>.broadcast();
  final StreamController<SyncResult> _syncResultController = StreamController<SyncResult>.broadcast();
  final List<SyncConflict> _pendingConflicts = [];

  SyncServiceImpl(this._dataSource);

  @override
  Future<void> initialize(AppConfig config) async {
    _config = config;
    
    if (config.isBackendEnabled && config.enableAutoSync) {
      await startAutoSync();
    }
  }

  @override
  Future<void> startAutoSync() async {
    if (_config == null || !_config!.isBackendEnabled) return;
    
    await stopAutoSync(); // Stop existing timer
    
    _isAutoSyncEnabled = true;
    _syncTimer = Timer.periodic(_config!.syncInterval, (_) async {
      if (!_isSyncInProgress) {
        final result = await syncNow();
        _syncResultController.add(result);
      }
    });
    
    _updateSyncStatus();
  }

  @override
  Future<void> stopAutoSync() async {
    _syncTimer?.cancel();
    _syncTimer = null;
    _isAutoSyncEnabled = false;
    _updateSyncStatus();
  }

  @override
  Future<SyncResult> syncNow() async {
    if (_isSyncInProgress) {
      throw StateError('Sync already in progress');
    }
    
    _isSyncInProgress = true;
    _updateSyncStatus();
    
    try {
      final result = await _performSync();
      return result;
    } finally {
      _isSyncInProgress = false;
      _updateSyncStatus();
    }
  }

  @override
  Future<SyncStatus> getSyncStatus() async {
    final pendingChanges = await _countPendingChanges();
    final lastSyncResult = await _getLastSyncResult();
    
    return SyncStatus(
      lastSyncTime: lastSyncResult?.syncTime,
      isAutoSyncEnabled: _isAutoSyncEnabled,
      isSyncInProgress: _isSyncInProgress,
      pendingChanges: pendingChanges,
      lastSyncResult: lastSyncResult,
    );
  }

  @override
  Future<bool> needsSync() async {
    if (_config == null || !_config!.isBackendEnabled) return false;
    
    final pendingChanges = await _countPendingChanges();
    return pendingChanges > 0;
  }

  @override
  Stream<SyncStatus> get syncStatusStream => _syncStatusController.stream;

  @override
  Stream<SyncResult> get syncResultStream => _syncResultController.stream;

  @override
  Future<SyncResult> forceFullSync() async {
    if (_isSyncInProgress) {
      throw StateError('Sync already in progress');
    }
    
    _isSyncInProgress = true;
    _updateSyncStatus();
    
    try {
      final result = await _performFullSync();
      return result;
    } finally {
      _isSyncInProgress = false;
      _updateSyncStatus();
    }
  }

  @override
  Future<void> resolveConflicts(List<BatchConflictResolution> resolutions) async {
    for (final resolution in resolutions) {
      final conflictIndex = _pendingConflicts.indexWhere(
        (c) => c.spoolUid == resolution.spoolUid,
      );
      
      if (conflictIndex >= 0) {
        final conflict = _pendingConflicts[conflictIndex];
        await _resolveConflict(conflict, resolution.strategy);
        _pendingConflicts.removeAt(conflictIndex);
      }
    }
    
    _updateSyncStatus();
  }

  @override
  Future<List<SyncConflict>> getPendingConflicts() async {
    return List.from(_pendingConflicts);
  }

  @override
  Future<void> dispose() async {
    await stopAutoSync();
    await _syncStatusController.close();
    await _syncResultController.close();
    _pendingConflicts.clear();
  }

  /// Perform incremental sync
  Future<SyncResult> _performSync() async {
    final startTime = DateTime.now();
    final errors = <SyncError>[];
    int totalItems = 0;
    int syncedItems = 0;
    int conflictItems = 0;
    
    try {
      // Check if remote is available
      if (!await _dataSource.remoteDataSource.isAvailable()) {
        return SyncResult(
          totalItems: 0,
          syncedItems: 0,
          conflictItems: 0,
          errorItems: 1,
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
      
      // Get local spools that need sync
      final localSpools = await _dataSource.localDataSource.getAllSpools();
      totalItems = localSpools.length;
      
      // Get remote spools
      final remoteSpools = await _dataSource.remoteDataSource.getAllSpools();
      
      // Compare and sync
      final syncResults = await _compareAndSync(localSpools, remoteSpools);
      syncedItems = syncResults.syncedItems;
      conflictItems = syncResults.conflictItems;
      errors.addAll(syncResults.errors);
      
      return SyncResult(
        totalItems: totalItems,
        syncedItems: syncedItems,
        conflictItems: conflictItems,
        errorItems: errors.length,
        errors: errors,
        syncTime: startTime,
        syncDuration: DateTime.now().difference(startTime),
      );
    } catch (e) {
      return SyncResult(
        totalItems: totalItems,
        syncedItems: syncedItems,
        conflictItems: conflictItems,
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

  /// Perform full sync (ignores timestamps)
  Future<SyncResult> _performFullSync() async {
    // Similar to _performSync but ignores modification timestamps
    return await _performSync(); // Simplified for now
  }

  /// Compare local and remote spools and perform sync
  Future<_SyncResults> _compareAndSync(List<Spool> localSpools, List<Spool> remoteSpools) async {
    final errors = <SyncError>[];
    int syncedItems = 0;
    int conflictItems = 0;
    
    // Create maps for easier lookup
    final localMap = {for (var spool in localSpools) spool.uid.value: spool};
    final remoteMap = {for (var spool in remoteSpools) spool.uid.value: spool};
    
    // Find spools that exist only locally (need to upload)
    for (final localSpool in localSpools) {
      if (!remoteMap.containsKey(localSpool.uid.value)) {
        try {
          await _dataSource.remoteDataSource.saveSpool(localSpool);
          syncedItems++;
        } catch (e) {
          errors.add(SyncError(
            spoolUid: localSpool.uid.value,
            operation: 'upload',
            errorMessage: e.toString(),
            timestamp: DateTime.now(),
          ));
        }
      }
    }
    
    // Find spools that exist only remotely (need to download)
    for (final remoteSpool in remoteSpools) {
      if (!localMap.containsKey(remoteSpool.uid.value)) {
        try {
          await _dataSource.localDataSource.saveSpool(remoteSpool);
          syncedItems++;
        } catch (e) {
          errors.add(SyncError(
            spoolUid: remoteSpool.uid.value,
            operation: 'download',
            errorMessage: e.toString(),
            timestamp: DateTime.now(),
          ));
        }
      }
    }
    
    // Find spools that exist in both (check for conflicts)
    for (final localSpool in localSpools) {
      final remoteSpool = remoteMap[localSpool.uid.value];
      if (remoteSpool != null) {
        final conflict = _detectConflict(localSpool, remoteSpool);
        if (conflict != null) {
          _pendingConflicts.add(conflict);
          conflictItems++;
        } else {
          // No conflict, sync the newer version
          if (_isNewer(remoteSpool, localSpool)) {
            try {
              await _dataSource.localDataSource.updateSpool(remoteSpool);
              syncedItems++;
            } catch (e) {
              errors.add(SyncError(
                spoolUid: remoteSpool.uid.value,
                operation: 'update_local',
                errorMessage: e.toString(),
                timestamp: DateTime.now(),
              ));
            }
          } else if (_isNewer(localSpool, remoteSpool)) {
            try {
              await _dataSource.remoteDataSource.updateSpool(localSpool);
              syncedItems++;
            } catch (e) {
              errors.add(SyncError(
                spoolUid: localSpool.uid.value,
                operation: 'update_remote',
                errorMessage: e.toString(),
                timestamp: DateTime.now(),
              ));
            }
          }
        }
      }
    }
    
    return _SyncResults(
      syncedItems: syncedItems,
      conflictItems: conflictItems,
      errors: errors,
    );
  }

  /// Detect if there's a conflict between local and remote versions
  SyncConflict? _detectConflict(Spool local, Spool remote) {
    // Simple conflict detection based on modification times
    if (local.updatedAt != null && remote.updatedAt != null) {
      final localTime = local.updatedAt!;
      final remoteTime = remote.updatedAt!;
      
      // If both were modified recently and times are very close, it's a conflict
      final timeDiff = localTime.difference(remoteTime).abs();
      if (timeDiff < const Duration(minutes: 1) && 
          local.remainingLength.meters != remote.remainingLength.meters) {
        return SyncConflict(
          spoolUid: local.uid.value,
          localVersion: local,
          remoteVersion: remote,
          conflictTime: DateTime.now(),
          type: ConflictType.bothModified,
        );
      }
    }
    
    return null;
  }

  /// Check if one spool is newer than another
  bool _isNewer(Spool spool1, Spool spool2) {
    final time1 = spool1.updatedAt ?? spool1.createdAt;
    final time2 = spool2.updatedAt ?? spool2.createdAt;
    return time1.isAfter(time2);
  }

  /// Resolve a sync conflict
  Future<void> _resolveConflict(SyncConflict conflict, ConflictResolutionStrategy strategy) async {
    switch (strategy) {
      case ConflictResolutionStrategy.localWins:
        await _dataSource.remoteDataSource.updateSpool(conflict.localVersion);
        break;
      case ConflictResolutionStrategy.remoteWins:
        await _dataSource.localDataSource.updateSpool(conflict.remoteVersion);
        break;
      case ConflictResolutionStrategy.newestWins:
        if (_isNewer(conflict.localVersion, conflict.remoteVersion)) {
          await _dataSource.remoteDataSource.updateSpool(conflict.localVersion);
        } else {
          await _dataSource.localDataSource.updateSpool(conflict.remoteVersion);
        }
        break;
      case ConflictResolutionStrategy.merge:
        final merged = _mergeSpools(conflict.localVersion, conflict.remoteVersion);
        await _dataSource.localDataSource.updateSpool(merged);
        await _dataSource.remoteDataSource.updateSpool(merged);
        break;
    }
  }

  /// Merge two spool versions (simple merge strategy)
  Spool _mergeSpools(Spool local, Spool remote) {
    // Use the most recent data for each field
    return local.copyWith(
      remainingLength: _isNewer(local, remote) ? local.remainingLength : remote.remainingLength,
      notes: (local.notes?.isNotEmpty == true) ? local.notes : remote.notes,
      updatedAt: DateTime.now(),
    );
  }

  /// Update sync status and notify listeners
  void _updateSyncStatus() {
    getSyncStatus().then((status) {
      _syncStatusController.add(status);
    });
  }

  /// Count pending changes that need sync
  Future<int> _countPendingChanges() async {
    // In a real implementation, this would check modification timestamps
    // and compare with last sync time
    return 0; // Simplified for now
  }

  /// Get last sync result
  Future<SyncResult?> _getLastSyncResult() async {
    // In a real implementation, this would be stored persistently
    return null; // Simplified for now
  }
}

/// Helper class for sync results
class _SyncResults {
  final int syncedItems;
  final int conflictItems;
  final List<SyncError> errors;

  const _SyncResults({
    required this.syncedItems,
    required this.conflictItems,
    required this.errors,
  });
}

/// Conflict resolution for batch operations
class BatchConflictResolution {
  final String spoolUid;
  final ConflictResolutionStrategy strategy;

  const BatchConflictResolution({
    required this.spoolUid,
    required this.strategy,
  });
}

/// Conflict resolution strategies
enum ConflictResolutionStrategy {
  localWins,
  remoteWins,
  newestWins,
  merge,
}