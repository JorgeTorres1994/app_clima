import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'bootstrap.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Lee config desde google-services.json (Android)
  await Firebase.initializeApp();
  await bootstrap();
}
