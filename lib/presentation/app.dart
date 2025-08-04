import 'package:flutter/material.dart';
import 'package:spool_coder_app/core/constants/app_constants.dart';
import 'package:spool_coder_app/core/routes/app_router.dart';
import 'package:spool_coder_app/theme/theme.dart';
import 'package:spool_coder_app/core/di/injector.dart';
import 'package:spool_coder_app/core/providers/app_locale_provider.dart';
import 'package:spool_coder_app/l10n/app_localizations.dart';

/// Root App widget with custom Spool Coder theme and localization support
class SpoolCoderApp extends StatefulWidget {
  const SpoolCoderApp({super.key});

  @override
  State<SpoolCoderApp> createState() => _SpoolCoderAppState();
}

class _SpoolCoderAppState extends State<SpoolCoderApp> {
  late AppLocaleProvider _localeProvider;

  @override
  void initState() {
    super.initState();
    _localeProvider = locator<AppLocaleProvider>();
    _localeProvider.addListener(_onSettingsChanged);
  }

  @override
  void dispose() {
    _localeProvider.removeListener(_onSettingsChanged);
    super.dispose();
  }

  void _onSettingsChanged() {
    setState(() {
      // Rebuild when settings change
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppConstants.appName,
      // Apply custom theme based on design concept and user settings
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _localeProvider.currentThemeMode,
      // Localization support
      locale: _localeProvider.currentLocale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
