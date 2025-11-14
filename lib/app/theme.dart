import 'package:flutter/material.dart';


final lightTheme = ThemeData(
useMaterial3: true,
colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4FACFE)),
brightness: Brightness.light,
);


final darkTheme = ThemeData(
useMaterial3: true,
colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4FACFE), brightness: Brightness.dark),
brightness: Brightness.dark,
);