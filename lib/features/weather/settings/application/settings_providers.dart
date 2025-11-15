import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'settings_controller.dart';
import 'settings_state.dart';

final _boxProvider = Provider<Box>((ref) => Hive.box('cache'));

final settingsProvider =
    StateNotifierProvider<SettingsController, SettingsState>((ref) {
  final box = ref.watch(_boxProvider);
  return SettingsController(box);
});

// ThemeMode reactivo
final themeModeProvider = Provider<ThemeMode>((ref) {
  final theme = ref.watch(settingsProvider.select((s) => s.theme));
  switch (theme) {
    case AppTheme.light: return ThemeMode.light;
    case AppTheme.dark:  return ThemeMode.dark;
    case AppTheme.system:
    default:             return ThemeMode.system;
  }
});

// Locale reactivo
final localeProvider = Provider<Locale?>((ref) {
  final lang = ref.watch(settingsProvider.select((s) => s.language));
  switch (lang) {
    case AppLanguage.en: return const Locale('en');
    case AppLanguage.es: return const Locale('es');
  }
});
