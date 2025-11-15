import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'settings_state.dart';

const _kSettingsKey = 'app.settings';

class SettingsController extends StateNotifier<SettingsState> {
  final Box box;
  SettingsController(this.box) : super(_load(box));

  // Carga inicial desde Hive
  static SettingsState _load(Box box) {
    final raw = box.get(_kSettingsKey) as Map?;
    return SettingsState.fromMap(raw?.cast<String, dynamic>());
  }

  Future<void> _save(SettingsState s) async {
    await box.put(_kSettingsKey, s.toMap());
  }

  // Mutadores con persistencia
  Future<void> setUnit(TempUnit u) async {
    final s = state.copyWith(unit: u);
    state = s;
    await _save(s);
  }

  Future<void> setHourFormat(HourFormat h) async {
    final s = state.copyWith(hourFormat: h);
    state = s;
    await _save(s);
  }

  Future<void> setTheme(AppTheme t) async {
    final s = state.copyWith(theme: t);
    state = s;
    await _save(s);
  }

  Future<void> setLanguage(AppLanguage l) async {
    final s = state.copyWith(language: l);
    state = s;
    await _save(s);
  }
}
