import 'package:get_it/get_it.dart';

/// Global service locator
final GetIt locator = GetIt.instance;

/// Register all services and repositories here
void setupLocator() {
  // Example:
  // locator.registerLazySingleton<SpoolService>(() => SpoolServiceImpl());
}
