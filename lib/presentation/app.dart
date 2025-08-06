import 'package:flutter/material.dart';
import 'package:spool_coder_app/core/constants/app_constants.dart';
import 'package:spool_coder_app/core/routes/app_router.dart';
import 'package:spool_coder_app/core/di/injector.dart';
import 'package:spool_coder_app/core/providers/app_locale_provider.dart';
import 'package:spool_coder_app/core/providers/font_size_provider.dart';
import 'package:spool_coder_app/core/providers/theme_provider.dart';
import 'package:spool_coder_app/l10n/app_localizations.dart';

/// Root App widget with custom Spool Coder theme and localization support
class SpoolCoderApp extends StatefulWidget {
  const SpoolCoderApp({super.key});

  @override
  State<SpoolCoderApp> createState() => _SpoolCoderAppState();
}

class _SpoolCoderAppState extends State<SpoolCoderApp> {
  late AppLocaleProvider _localeProvider;
  late FontSizeProvider _fontSizeProvider;
  late ThemeProvider _themeProvider;

  @override
  void initState() {
    super.initState();
    _localeProvider = locator<AppLocaleProvider>();
    _fontSizeProvider = locator<FontSizeProvider>();
    _themeProvider = locator<ThemeProvider>();
    _localeProvider.addListener(_onSettingsChanged);
    _fontSizeProvider.addListener(_onSettingsChanged);
    _themeProvider.addListener(_onSettingsChanged);
  }

  @override
  void dispose() {
    _localeProvider.removeListener(_onSettingsChanged);
    _fontSizeProvider.removeListener(_onSettingsChanged);
    _themeProvider.removeListener(_onSettingsChanged);
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
      theme: _themeProvider.getThemeData(context),
      darkTheme: _themeProvider.getThemeData(context),
      themeMode: _localeProvider.currentThemeMode,
      // Apply font size scaling
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(_fontSizeProvider.textScaleFactor),
          ),
          child: child!,
        );
      },
      // Localization support
      locale: _localeProvider.currentLocale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
