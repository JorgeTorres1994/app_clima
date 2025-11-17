// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';

import 'bootstrap.dart';
import 'app/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1) Inicializa Firebase (lee google-services.json en Android)
  await Firebase.initializeApp();

  // 2) Bootstrap: Hive, cajas, etc.
  await bootstrap();

  // 3) Arranca la app con Riverpod
  runApp(
    const ProviderScope(
      child: WeatherApp(),
    ),
  );
}
