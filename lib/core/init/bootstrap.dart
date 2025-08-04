import 'package:flutter/material.dart';
import '../di/injector.dart';

/// Initializes app before runApp
Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set up dependency injection
  await setupLocator();

  // Global error handling
  FlutterError.onError = (details) {
    // TODO: Replace with proper logging
    debugPrint('Flutter error: ${details.exceptionAsString()}');
  };
  
  debugPrint('App initialized successfully');
}
