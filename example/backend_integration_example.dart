// Example demonstrating the backend integration architecture
// Shows how to configure and use the app with/without backend

import 'package:spool_coder_app/core/config/app_config.dart';
import 'package:spool_coder_app/core/di/injector.dart';
import 'package:spool_coder_app/domain/repositories/spool_repository.dart';
import 'package:spool_coder_app/domain/entities/spool.dart';
import 'package:spool_coder_app/domain/value_objects/spool_uid.dart';
import 'package:spool_coder_app/domain/value_objects/material_type.dart';
import 'package:spool_coder_app/domain/value_objects/spool_color.dart';
import 'package:spool_coder_app/domain/value_objects/filament_length.dart';
import 'package:spool_coder_app/data/services/sync_service.dart';

void main() async {
  // Example 1: Local-only operation (default)
  await demonstrateLocalOnly();
  
  print('\n' + '='*50 + '\n');
  
  // Example 2: Backend-enabled operation
  await demonstrateBackendEnabled();
  
  print('\n' + '='*50 + '\n');
  
  // Example 3: Runtime configuration switching
  await demonstrateRuntimeSwitching();
}

/// Demonstrates local-only operation
Future<void> demonstrateLocalOnly() async {
  print('🏠 LOCAL-ONLY OPERATION EXAMPLE');
  print('================================');
  
  // Configure for local-only operation
  const config = AppConfig.defaultLocal;
  setupLocator(config: config);
  
  print('✅ App configured for local-only operation');
  print('   - Backend: ${config.isBackendEnabled ? "Enabled" : "Disabled"}');
  print('   - Offline mode: ${config.canWorkOffline ? "Enabled" : "Disabled"}');
  
  // Use repository normally - all operations are local
  final repository = locator<SpoolRepository>();
  
  // Create a sample spool
  final spool = Spool(
    uid: SpoolUid('LOCAL_001'),
    materialType: MaterialType.pla,
    manufacturer: 'BambuLab',
    color: SpoolColor.named('Blue'),
    netLength: FilamentLength.meters(1000.0),
    remainingLength: FilamentLength.meters(750.0),
    createdAt: DateTime.now(),
  );
  
  // Save the spool (goes to local storage)
  await repository.saveSpool(spool);
  print('💾 Spool saved locally: ${spool.uid.value}');
  
  // Retrieve all spools
  final allSpools = await repository.getAllSpools();
  print('📋 Retrieved ${allSpools.length} spools from local storage');
  
  // Search for spools
  final plaSpools = await repository.searchSpools(materialType: 'PLA');
  print('🔍 Found ${plaSpools.length} PLA spools');
  
  print('✨ Local operations completed successfully!');
}

/// Demonstrates backend-enabled operation
Future<void> demonstrateBackendEnabled() async {
  print('🌐 BACKEND-ENABLED OPERATION EXAMPLE');
  print('====================================');
  
  // Clear previous configuration
  locator.reset();
  
  // Configure with backend enabled
  final config = AppConfig.withBackend(
    baseUrl: 'https://api.spoolcoder.com',
    apiKey: 'demo-api-key-12345',
    enableAutoSync: true,
    syncInterval: const Duration(minutes: 5),
  );
  setupLocator(config: config);
  
  print('✅ App configured for backend operation');
  print('   - Backend: ${config.isBackendEnabled ? "Enabled" : "Disabled"}');
  print('   - Base URL: ${config.backend.baseUrl}');
  print('   - Auto-sync: ${config.enableAutoSync ? "Enabled" : "Disabled"}');
  print('   - Sync interval: ${config.syncInterval.inMinutes} minutes');
  
  // Get services
  final repository = locator<SpoolRepository>();
  final syncService = locator<SyncService>();
  
  // Create a sample spool
  final spool = Spool(
    uid: SpoolUid('BACKEND_001'),
    materialType: MaterialType.petg,
    manufacturer: 'BambuLab',
    color: SpoolColor.named('Red'),
    netLength: FilamentLength.meters(1000.0),
    remainingLength: FilamentLength.meters(200.0), // Nearly empty
    createdAt: DateTime.now(),
  );
  
  // Save the spool (goes to hybrid storage - local + remote)
  await repository.saveSpool(spool);
  print('💾 Spool saved to hybrid storage: ${spool.uid.value}');
  
  // Check sync status
  final syncStatus = await syncService.getSyncStatus();
  print('🔄 Sync status:');
  print('   - Auto-sync enabled: ${syncStatus.isAutoSyncEnabled}');
  print('   - Sync in progress: ${syncStatus.isSyncInProgress}');
  print('   - Pending changes: ${syncStatus.pendingChanges}');
  
  // Perform manual sync
  try {
    print('🚀 Starting manual sync...');
    final syncResult = await syncService.syncNow();
    print('✅ Sync completed:');
    print('   - Total items: ${syncResult.totalItems}');
    print('   - Synced items: ${syncResult.syncedItems}');
    print('   - Conflicts: ${syncResult.conflictItems}');
    print('   - Errors: ${syncResult.errorItems}');
    print('   - Duration: ${syncResult.syncDuration.inMilliseconds}ms');
  } catch (e) {
    print('❌ Sync failed: $e');
  }
  
  // Repository operations work the same regardless of backend
  final nearlyEmpty = await repository.getNearlyEmptySpools();
  print('⚠️  Found ${nearlyEmpty.length} nearly empty spools');
  
  print('✨ Backend operations completed successfully!');
}

/// Demonstrates runtime configuration switching
Future<void> demonstrateRuntimeSwitching() async {
  print('🔄 RUNTIME CONFIGURATION SWITCHING EXAMPLE');
  print('==========================================');
  
  // Start with local-only
  print('📱 Starting with local-only configuration...');
  const localConfig = AppConfig.defaultLocal;
  setupLocator(config: localConfig);
  
  var appConfig = locator<AppConfig>();
  print('   Current mode: ${appConfig.isBackendEnabled ? "Backend" : "Local-only"}');
  
  // Use repository in local mode
  var repository = locator<SpoolRepository>();
  await repository.saveSpool(Spool(
    uid: SpoolUid('SWITCH_TEST_001'),
    materialType: MaterialType.abs,
    manufacturer: 'Generic',
    color: SpoolColor.named('Black'),
    netLength: FilamentLength.meters(500.0),
    remainingLength: FilamentLength.meters(500.0),
    createdAt: DateTime.now(),
  ));
  
  var spoolCount = (await repository.getAllSpools()).length;
  print('   Spools in local storage: $spoolCount');
  
  // Switch to backend-enabled configuration
  print('\n🌐 Switching to backend-enabled configuration...');
  final backendConfig = AppConfig.withBackend(
    baseUrl: 'https://api.spoolcoder.com',
    apiKey: 'runtime-switch-key',
    enableAutoSync: false, // Disable auto-sync for demo
  );
  updateConfiguration(backendConfig);
  
  appConfig = locator<AppConfig>();
  print('   Current mode: ${appConfig.isBackendEnabled ? "Backend" : "Local-only"}');
  
  // Repository is automatically reconfigured
  repository = locator<SpoolRepository>();
  
  // Add another spool in backend mode
  await repository.saveSpool(Spool(
    uid: SpoolUid('SWITCH_TEST_002'),
    materialType: MaterialType.tpu,
    manufacturer: 'Flexible Filaments Inc',
    color: SpoolColor.named('Clear'),
    netLength: FilamentLength.meters(250.0),
    remainingLength: FilamentLength.meters(250.0),
    createdAt: DateTime.now(),
  ));
  
  spoolCount = (await repository.getAllSpools()).length;
  print('   Spools in hybrid storage: $spoolCount');
  
  // Switch back to local-only
  print('\n🏠 Switching back to local-only configuration...');
  updateConfiguration(AppConfig.defaultLocal);
  
  appConfig = locator<AppConfig>();
  print('   Current mode: ${appConfig.isBackendEnabled ? "Backend" : "Local-only"}');
  
  repository = locator<SpoolRepository>();
  spoolCount = (await repository.getAllSpools()).length;
  print('   Spools in local storage: $spoolCount');
  
  print('✨ Configuration switching completed successfully!');
}

/// Helper function to create sample spools
Spool createSampleSpool(String id, MaterialType material, String color, {double remaining = 500.0}) {
  return Spool(
    uid: SpoolUid(id),
    materialType: material,
    manufacturer: 'Sample Manufacturer',
    color: SpoolColor.named(color),
    netLength: FilamentLength.meters(1000.0),
    remainingLength: FilamentLength.meters(remaining),
    filamentDiameter: 1.75,
    spoolWeight: 250.0,
    createdAt: DateTime.now(),
  );
}