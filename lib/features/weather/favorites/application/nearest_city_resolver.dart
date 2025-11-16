import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/services.dart' show rootBundle;

class NearestCityResolver {
  NearestCityResolver._();
  static List<_City> _cities = const [];

  static Future<void> _ensureLoaded() async {
    if (_cities.isNotEmpty) return;
    final raw = await rootBundle.loadString('assets/data/peru_cities.json');
    final list = (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
    _cities = list.map((m) => _City(
      m['name'] as String,
      (m['lat'] as num).toDouble(),
      (m['lon'] as num).toDouble(),
    )).toList(growable: false);
  }

  /// Devuelve {name, lat, lon} de la ciudad más cercana
  static Future<Map<String, dynamic>> nearest(double lat, double lon) async {
    await _ensureLoaded();
    _City? best;
    var bestD = double.maxFinite;
    for (final c in _cities) {
      final d = _haversine(lat, lon, c.lat, c.lon);
      if (d < bestD) { bestD = d; best = c; }
    }
    if (best == null) return {'name': 'Ubicación, PE', 'lat': lat, 'lon': lon};
    return {'name': '${best.name}, PE', 'lat': best.lat, 'lon': best.lon};
  }

  static double _haversine(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371.0;
    final dLat = _deg2rad(lat2 - lat1);
    final dLon = _deg2rad(lon2 - lon1);
    final a = math.sin(dLat/2)*math.sin(dLat/2) +
              math.cos(_deg2rad(lat1))*math.cos(_deg2rad(lat2))*
              math.sin(dLon/2)*math.sin(dLon/2);
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1-a));
    return R * c;
  }

  static double _deg2rad(double d) => d * math.pi / 180.0;
}

class _City {
  final String name; final double lat; final double lon;
  const _City(this.name, this.lat, this.lon);
}
