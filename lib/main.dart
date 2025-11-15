import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';

import 'bootstrap.dart';
import 'app/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1) Firebase (lee google-services.json en Android)
  await Firebase.initializeApp();

  // 2) Bootstrap: abre Hive, cajas, etc. (sin runApp aquí)
  await bootstrap();

  // 3) Arranca la app una sola vez dentro de ProviderScope
  runApp(const ProviderScope(child: WeatherApp()));
}
