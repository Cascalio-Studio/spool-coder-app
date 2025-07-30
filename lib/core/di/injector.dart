import 'package:get_it/get_it.dart';
// Import NFC platform interface and implementation
import 'package:spool_coder_app/platform/nfc/nfc_platform.dart';

/// Global service locator
final GetIt locator = GetIt.instance;

/// Register all services and repositories here
void setupLocator() {
  // Register NFC platform implementation
  locator.registerLazySingleton<NfcPlatformInterface>(
    () => NfcPlatformImpl(),
  );
  // TODO: Register other core services (e.g., storage, logging)
}
