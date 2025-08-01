import 'package:flutter/material.dart';
import 'package:spool_coder_app/theme/theme.dart';
import 'package:spool_coder_app/presentation/screens/home_screen.dart';

/// Demo app to showcase the home screen implementation
class HomeScreenDemo extends StatelessWidget {
  const HomeScreenDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spool Coder - Home Screen Demo',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}

/// Run this demo to see the home screen in action
void main() {
  runApp(const HomeScreenDemo());
}
