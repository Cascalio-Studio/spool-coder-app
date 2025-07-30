import 'package:flutter/material.dart';
import 'package:spool_coder_app/core/constants/app_constants.dart';
import 'package:spool_coder_app/core/routes/app_router.dart';

/// Root App widget
class SpoolCoderApp extends StatelessWidget {
  const SpoolCoderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppConstants.appName,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
