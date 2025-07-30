import 'package:flutter/material.dart';
import 'presentation/screens/home_screen.dart';
import 'core/constants/app_constants.dart';

void main() {
  runApp(const SpoolCoderApp());
}

class SpoolCoderApp extends StatelessWidget {
  const SpoolCoderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
