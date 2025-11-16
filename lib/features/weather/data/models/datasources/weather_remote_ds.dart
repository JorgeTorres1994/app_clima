// lib/features/weather/data/datasources/weather_remote_ds.dart
import 'package:app_clima/features/weather/domain/entities/weather.dart';
import 'package:app_clima/features/weather/presentation/controllers/weather_providers.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WeatherRemoteDS {
  final Dio _dio; // baseUrl esperado: https://api.open-meteo.com/v1
  final Ref _ref;
  WeatherRemoteDS(this._dio, this._ref);

  /// Obtiene el clima actual para la ciudad seleccionada y lo mapea a [Weather].
  /*Future<Weather> getCurrent() async {
    final sel = _ref.read(selectedCityProvider)!;           // ciudad elegida
    final display = '${sel.name}, PE';                      // nombre bonito
    final data = await _fetchCurrentRaw(sel.lat, sel.lon);  // JSON real de Open-Meteo

    final cur = (data['current'] as Map<String, dynamic>);
    return Weather(
      locationName: display,
      lat: sel.lat,
      lon: sel.lon,
      temp: (cur['temperature_2m'] as num).toDouble(),
      feelsLike: (cur['apparent_temperature'] as num).toDouble(),
      condition: (cur['weather_text'] ?? '').toString(),
      icon: (cur['weather_icon'] ?? '').toString(),
      humidity: (cur['relative_humidity_2m'] as num).toDouble(),
      // Open-Meteo devuelve km/h por defecto en wind_speed_10m (con wind_speed_unit=kmh)
      windKph: (cur['wind_speed_10m'] as num).toDouble(),
      updatedAt: DateTime.parse(cur['time'] as String).toUtc(),
      utcOffsetSeconds: (data['utc_offset_seconds'] ?? 0) as int,
      timezone: (data['timezone'] ?? 'UTC') as String,
    );
  }*/

  // lib/features/weather/data/datasources/weather_remote_ds.dart
  Future<Weather> getCurrent() async {
    final sel = _ref.read(selectedCityProvider)!;

    final display = (sel.displayName?.isNotEmpty ?? false)
        ? sel.displayName!
        : sel.name;

    // Usa tu método real que llama a Open-Meteo
    final r = await _dio.get(
      '/forecast',
      queryParameters: {
        'latitude': sel.lat,
        'longitude': sel.lon,
        'current':
            'temperature_2m,apparent_temperature,relative_humidity_2m,wind_speed_10m',
        'timezone': 'auto',
      },
    );

    final cur = r.data['current'] as Map<String, dynamic>;
    return Weather(
      locationName: display, // 👈 nombre tal cual
      lat: sel.lat,
      lon: sel.lon,
      temp: (cur['temperature_2m'] as num).toDouble(),
      feelsLike: (cur['apparent_temperature'] as num).toDouble(),
      condition: '', // o mapea si tienes weather_code → texto
      icon: '01d', // idem
      humidity: (cur['relative_humidity_2m'] as num).toDouble(),
      windKph: ((cur['wind_speed_10m'] as num).toDouble()),
      updatedAt: DateTime.parse(cur['time'] as String).toUtc(),
      utcOffsetSeconds: (r.data['utc_offset_seconds'] as int?) ?? 0,
      timezone: (r.data['timezone'] as String?) ?? 'UTC',
    );
  }

  /// --- Helpers internos ---

  /// Llama a Open-Meteo /forecast y devuelve el JSON crudo necesario para `getCurrent()`.
  Future<Map<String, dynamic>> _fetchCurrentRaw(double lat, double lon) async {
    final r = await _dio.get(
      '/forecast',
      queryParameters: {
        'latitude': lat,
        'longitude': lon,
        'current':
            'temperature_2m,apparent_temperature,relative_humidity_2m,wind_speed_10m',
        'timezone': 'auto',
        // Si quieres forzar unidades: 'wind_speed_unit': 'kmh', 'temperature_unit': 'celsius'
      },
    );
    return (r.data as Map).cast<String, dynamic>();
  }

  // --- Si también buscas por nombre de ciudad (geocoding Open-Meteo) ---

  // Normaliza "Lima,PE" -> "Lima"
  String _cityOnly(String q) {
    final parts = q.split(RegExp(r'[,|-]')).map((s) => s.trim()).toList();
    return parts.isNotEmpty ? parts.first : q.trim();
  }

  // Geocoding; intenta primero con country=PE y si no, sin filtro
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
      final first = results.first as Map<String, dynamic>;
      return {
        'display': '${first['name']}, ${first['country_code']}',
        'lat': (first['latitude'] as num).toDouble(),
        'lon': (first['longitude'] as num).toDouble(),
      };
    }

    return await run(country: 'PE') ?? await run(country: null);
  }

  /// Busca por texto, resuelve coordenadas y retorna el JSON "current"
  /// (útil si quieres previsualizar sin tocar selectedCityProvider).
  Future<Map<String, dynamic>> currentByQuery(
    String q, {
    String lang = 'es',
  }) async {
    final g = await _geoSearch(q);
    if (g == null) {
      throw Exception('No se encontró la ciudad "${_cityOnly(q)}".');
    }
    return _fetchCurrentRaw(g['lat'] as double, g['lon'] as double);
  }

  /// Pronóstico (tu implementación previa funciona bien con la UI)
  Future<Map<String, dynamic>> forecast(
    double lat,
    double lon, {
    String units = 'metric',
    String lang = 'es',
  }) async {
    final r = await _dio.get(
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
