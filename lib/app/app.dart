import 'package:flutter/material.dart';
import 'router.dart';
import 'theme.dart';


class WeatherApp extends StatelessWidget {
const WeatherApp({super.key});
@override
Widget build(BuildContext context) {
final router = createRouter();
return MaterialApp.router(
title: 'Clima',
theme: lightTheme,
darkTheme: darkTheme,
themeMode: ThemeMode.system,
routerConfig: router,
debugShowCheckedModeBanner: false,
);
}
}