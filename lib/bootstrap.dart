import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:dio/dio.dart';
import 'app/app.dart';

final dioProvider = Provider<Dio>((_) {
  return Dio(BaseOptions(
    baseUrl: 'https://api.open-meteo.com/v1', // <- directo a Open-Meteo
    connectTimeout: const Duration(seconds: 7),
    receiveTimeout: const Duration(seconds: 7),
  ));
});

final hiveBoxProvider = Provider<Box>((_) => Hive.box('cache'));

Future<void> bootstrap() async {
  await Hive.initFlutter();
  await Hive.openBox('cache');
  runApp(const ProviderScope(child: WeatherApp()));
}
