import 'package:flutter/material.dart';
import 'package:spool_coder_app/core/constants/app_constants.dart';
import 'package:spool_coder_app/core/routes/app_router.dart';
import 'package:spool_coder_app/theme/theme.dart';

/// Root App widget with custom Spool Coder theme
class SpoolCoderApp extends StatelessWidget {
  const SpoolCoderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppConstants.appName,
      // Apply custom theme based on design concept
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme, // Future implementation
      themeMode: ThemeMode.light,
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
