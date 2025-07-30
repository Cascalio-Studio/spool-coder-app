import 'package:flutter/material.dart';

/// Home screen - main entry point for the app
/// Part of the Presentation Layer: handles UI and user interactions
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Spool Coder'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Spool Coder App',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text('Ready to scan and program filament spools'),
          ],
        ),
      ),
    );
  }
}