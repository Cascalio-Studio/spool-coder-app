import 'package:flutter/material.dart';

void main() {
  runApp(const SpoolCoderApp());
}

class SpoolCoderApp extends StatelessWidget {
  const SpoolCoderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spool Coder App',
      home: const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Text(
            'Spool Coder App',
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
