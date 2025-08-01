import 'package:flutter/material.dart';
import '../di/injector.dart';
import '../config/app_config.dart';

/// Initializes app before runApp
Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load configuration from environment or use defaults
  final config = ConfigFactory.fromEnvironment();
  
  // Set up dependency injection with configuration
  setupLocator(config: config);

  // Global error handling
  FlutterError.onError = (details) {
    // TODO: Replace with proper logging
    debugPrint('Flutter error: ${details.exceptionAsString()}');
  };
  
  // Log configuration for debugging
  debugPrint('App initialized with backend ${config.isBackendEnabled ? 'enabled' : 'disabled'}');
  if (config.isBackendEnabled) {
    debugPrint('Backend URL: ${config.backend.baseUrl}');
    debugPrint('Auto-sync: ${config.enableAutoSync}');
  }
}
