// lib/features/weather/data/datasources/weather_remote_ds.dart
import 'package:dio/dio.dart';

class WeatherRemoteDS {
  final Dio dio; // baseUrl: https://api.open-meteo.com/v1
  WeatherRemoteDS(this.dio);

  // --- NUEVO: sanitiza "Lima,PE" -> "Lima"
  String _cityOnly(String q) {
    final parts = q.split(RegExp(r'[,|-]')).map((s) => s.trim()).toList();
    return parts.isNotEmpty ? parts.first : q.trim();
  }

  // Geocoding Open-Meteo; intenta primero con país=PE, si no hay resultado, sin filtro
  Future<Map<String, dynamic>?> _geoSearch(String q) async {
    final name = _cityOnly(q);

    Future<Map<String, dynamic>?> run({String? country}) async {
      final r = await Dio().get(
        'https://geocoding-api.open-meteo.com/v1/search',
        queryParameters: {
          'name': name,
          'count': 1,
          'language': 'es',
          'format': 'json',
          if (country != null) 'country': country,
        },
      );
      final results = r.data?['results'] as List<dynamic>?;
      if (results == null || results.isEmpty) return null;
      final first = results.first;
      return {
        'display': '${first['name']}, ${first['country_code']}',
        'lat': (first['latitude'] as num).toDouble(),
        'lon': (first['longitude'] as num).toDouble(),
      };
    }

    // 1) Perú; 2) sin filtro si no encuentra
    return await run(country: 'PE') ?? await run(country: null);
  }

  Future<Map<String, dynamic>> currentByQuery(
    String q, {
    String units = 'metric',
    String lang = 'es',
  }) async {
    final g = await _geoSearch(q);
    if (g == null)
      throw Exception('No se encontró la ciudad "${_cityOnly(q)}".');
    return currentByCoords(
      g['lat'],
      g['lon'],
      units: units,
      lang: lang,
      overrideName: g['display'],
    );
  }

  Future<Map<String, dynamic>> currentByCoords(
    double lat,
    double lon, {
    String units = 'metric',
    String lang = 'es',
    String? overrideName,
  }) async {
    final r = await dio.get(
      '/forecast',
      queryParameters: {
        'latitude': lat,
        'longitude': lon,
        'current': 'temperature_2m,relative_humidity_2m,wind_speed_10m',
        'timezone': 'auto',
      },
    );
    final cur = r.data['current'];
    final name = overrideName ?? (r.data['timezone'] ?? 'Local');

    final tempC = (cur['temperature_2m'] as num).toDouble();
    final temp = (units == 'metric') ? tempC : (tempC * 9 / 5 + 32);

    return {
      'name': name,
      'coord': {'lat': lat, 'lon': lon},
      'main': {
        'temp': temp,
        'feels_like': temp,
        'humidity': (cur['relative_humidity_2m'] as num).toDouble(),
      },
      'weather': [
        {'description': '', 'icon': '01d'},
      ],
      'wind': {'speed': ((cur['wind_speed_10m'] ?? 0) as num).toDouble() / 3.6},
    };
  }

  Future<Map<String, dynamic>> forecast(
    double lat,
    double lon, {
    String units = 'metric',
    String lang = 'es',
  }) async {
    final r = await dio.get(
      '/forecast',
      queryParameters: {
        'latitude': lat,
        'longitude': lon,
        'hourly': 'temperature_2m',
        'daily': 'temperature_2m_max,temperature_2m_min',
        'forecast_days': 7,
        'timezone': 'auto',
      },
    );

    final hourly = (r.data['hourly']['time'] as List).asMap().entries.map((e) {
      final i = e.key;
      return {
        'dt': DateTime.parse(e.value as String).millisecondsSinceEpoch ~/ 1000,
        'temp': (r.data['hourly']['temperature_2m'][i] as num).toDouble(),
        'weather': [
          {'icon': '01d'},
        ],
      };
    }).toList();

    final daily = (r.data['daily']['time'] as List).asMap().entries.map((e) {
      final i = e.key;
      return {
        'dt': DateTime.parse(e.value as String).millisecondsSinceEpoch ~/ 1000,
        'temp': {
          'min': (r.data['daily']['temperature_2m_min'][i] as num).toDouble(),
          'max': (r.data['daily']['temperature_2m_max'][i] as num).toDouble(),
        },
        'weather': [
          {'icon': '01d'},
        ],
      };
    }).toList();

    return {'hourly': hourly, 'daily': daily};
  }
}
