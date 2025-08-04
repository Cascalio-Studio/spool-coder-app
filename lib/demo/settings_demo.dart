import 'package:flutter/material.dart';
import 'package:spool_coder_app/core/init/bootstrap.dart';
import 'package:spool_coder_app/features/settings/settings.dart';
import 'package:spool_coder_app/theme/theme.dart';

/// Demo app to showcase the settings screen implementation
class SettingsDemo extends StatelessWidget {
  const SettingsDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Settings Demo',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: const SettingsScreen(),
    );
  }
}

/// Run this demo to see the settings screen in action
void main() async {
  await bootstrap(); // Initialize dependencies
  runApp(const SettingsDemo());
}
