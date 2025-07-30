import 'package:flutter/material.dart';
import 'package:spool_coder_app/core/init/bootstrap.dart';
import 'package:spool_coder_app/presentation/app.dart';

Future<void> main() async {
  await bootstrap();
  runApp(const SpoolCoderApp());
}
