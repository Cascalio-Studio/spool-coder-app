import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Import settings-related dependencies
import '../../data/datasources/settings_local_data_source.dart';
import '../../data/datasources/settings_local_data_source_impl.dart';
import '../../data/repositories/settings_repository_impl.dart';
import '../../domain/repositories/settings_repository.dart';
import '../../domain/use_cases/settings_use_case.dart';

// Import NFC-related dependencies
import '../../data/datasources/nfc_data_source.dart';
import '../../data/use_cases/nfc_scan_use_case_impl.dart';
import '../../domain/use_cases/nfc_scan_use_case.dart';

import '../providers/app_locale_provider.dart';
import '../providers/font_size_provider.dart';
import '../providers/theme_provider.dart';

/// Global service locator
final GetIt locator = GetIt.instance;

/// Register all services and repositories here
Future<void> setupLocator({dynamic config}) async {
  // Register SharedPreferences (needed for settings)
  final prefs = await SharedPreferences.getInstance();
  locator.registerSingleton<SharedPreferences>(prefs);
  
  // Register settings dependencies
  locator.registerLazySingleton<SettingsLocalDataSource>(
    () => SettingsLocalDataSourceImpl(locator<SharedPreferences>()),
  );
  
  locator.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(locator<SettingsLocalDataSource>()),
  );
  
  locator.registerLazySingleton<SettingsUseCase>(
    () => SettingsUseCase(locator<SettingsRepository>()),
  );
  
  // Register NFC dependencies with mock implementation for testing
  locator.registerLazySingleton<NfcDataSource>(
    () => MockNfcDataSource(),
  );
  
  locator.registerLazySingleton<NfcScanUseCase>(
    () => NfcScanUseCaseImpl(nfcDataSource: locator<NfcDataSource>()),
  );
  
  // Register app locale provider
  locator.registerSingleton<AppLocaleProvider>(AppLocaleProvider());
  
  // Register font size provider
  locator.registerSingleton<FontSizeProvider>(FontSizeProvider());
  
  // Register theme provider
  locator.registerSingleton<ThemeProvider>(ThemeProvider());
  
  // TODO: Register other services as needed
}
