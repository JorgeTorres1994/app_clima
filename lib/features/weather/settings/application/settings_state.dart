import 'package:flutter/material.dart';

/// Enums de preferencia
enum TempUnit { c, f }
enum HourFormat { h12, h24 }
enum AppTheme { system, light, dark }
enum AppLanguage { es, en }

/// Estado inmutable de Ajustes
@immutable
class SettingsState {
  final TempUnit unit;
  final HourFormat hourFormat;
  final AppTheme theme;
  final AppLanguage language;

  const SettingsState({
    this.unit = TempUnit.c,
    this.hourFormat = HourFormat.h24,
    this.theme = AppTheme.system,
    this.language = AppLanguage.es,
  });

  SettingsState copyWith({
    TempUnit? unit,
    HourFormat? hourFormat,
    AppTheme? theme,
    AppLanguage? language,
  }) {
    return SettingsState(
      unit: unit ?? this.unit,
      hourFormat: hourFormat ?? this.hourFormat,
      theme: theme ?? this.theme,
      language: language ?? this.language,
    );
  }

  // ---- Serialización simple para Hive (Map<String,dynamic>) ----
  Map<String, dynamic> toMap() => {
        'unit': unit.name,             // 'c' | 'f'
        'hourFormat': hourFormat.name, // 'h12' | 'h24'
        'theme': theme.name,           // 'system' | 'light' | 'dark'
        'language': language.name,     // 'es' | 'en'
      };

  factory SettingsState.fromMap(Map<String, dynamic>? m) {
    if (m == null) return const SettingsState();

    TempUnit _unit(String v) => v == 'f' ? TempUnit.f : TempUnit.c;
    HourFormat _hour(String v) => v == 'h12' ? HourFormat.h12 : HourFormat.h24;
    AppTheme _theme(String v) =>
        v == 'light' ? AppTheme.light : v == 'dark' ? AppTheme.dark : AppTheme.system;
    AppLanguage _lang(String v) => v == 'en' ? AppLanguage.en : AppLanguage.es;

    return SettingsState(
      unit: _unit(m['unit'] ?? 'c'),
      hourFormat: _hour(m['hourFormat'] ?? 'h24'),
      theme: _theme(m['theme'] ?? 'system'),
      language: _lang(m['language'] ?? 'es'),
    );
  }
}
