import 'package:get_it/get_it.dart';
// Import platform interfaces and implementations
import 'package:spool_coder_app/platform/nfc/nfc_platform.dart';
import 'package:spool_coder_app/platform/storage/storage_platform.dart';
import 'package:spool_coder_app/platform/network/network_platform.dart';
import 'package:spool_coder_app/platform/permissions/permissions_platform.dart';
import 'package:spool_coder_app/platform/device/device_platform.dart';

/// Global service locator
final GetIt locator = GetIt.instance;

/// Register all services and repositories here
void setupLocator() {
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
  
  // TODO: Register other core services (e.g., logging)
}
