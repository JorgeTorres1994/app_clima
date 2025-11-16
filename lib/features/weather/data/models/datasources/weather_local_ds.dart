import 'package:hive/hive.dart';

class WeatherLocalDS {
  final Box box;
  WeatherLocalDS(this.box);

  void cache(String key, Map<String, dynamic> json) {
    box.put(key, {'ts': DateTime.now().millisecondsSinceEpoch, 'data': json});
  }

  /// Lee sin validar
  Map<String, dynamic>? readRaw(String key) {
    final m = box.get(key) as Map?;
    return m?['data']?.cast<String, dynamic>();
  }

  /// Lee solo si no está expirado (ttl en minutos)
  Map<String, dynamic>? readFresh(String key, {int ttlMinutes = 10}) {
    final m = box.get(key) as Map?;
    if (m == null) return null;
    final ts = (m['ts'] as int?) ?? 0;
    final age = DateTime.now().millisecondsSinceEpoch - ts;
    if (age > ttlMinutes * 60 * 1000) return null;
    return (m['data'] as Map).cast<String, dynamic>();
  }

  Map<String, dynamic>? read(String key) =>
      box.get(key)?.cast<String, dynamic>();
}
