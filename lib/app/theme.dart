import 'package:flutter/material.dart';

ThemeData _base(Brightness b) {
  final seed = const Color(0xFF0EA5E9); // Sky-500
  final cs = ColorScheme.fromSeed(seedColor: seed, brightness: b);

  return ThemeData(
    useMaterial3: true,
    colorScheme: cs,
    visualDensity: VisualDensity.standard,
    cardTheme: CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: EdgeInsets.zero,
    ),
    listTileTheme: const ListTileThemeData(
      contentPadding: EdgeInsets.symmetric(horizontal: 12),
      dense: false,
    ),
  );
}

final lightTheme = _base(Brightness.light);
final darkTheme  = _base(Brightness.dark);
