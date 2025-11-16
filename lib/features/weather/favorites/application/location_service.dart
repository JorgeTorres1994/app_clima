import 'package:geolocator/geolocator.dart';
import 'package:dio/dio.dart';

class LocationService {
  final Dio _dio;
  LocationService(this._dio);

  /*Future<Position> currentPosition() async {
    bool enabled = await Geolocator.isLocationServiceEnabled();
    if (!enabled) throw Exception('Ubicación desactivada.');
    LocationPermission perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) perm = await Geolocator.requestPermission();
    if (perm == LocationPermission.denied || perm == LocationPermission.deniedForever) {
      throw Exception('Permiso de ubicación denegado.');
    }
    return Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
  }*/

  Future<Position> currentPosition() async {
    // 1) Servicios activos
    final enabled = await Geolocator.isLocationServiceEnabled();
    if (!enabled) throw Exception('La ubicación está desactivada.');

    // 2) Permisos
    var perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
    }
    if (perm == LocationPermission.denied ||
        perm == LocationPermission.deniedForever) {
      throw Exception('Permiso de ubicación denegado.');
    }

    // 3) Primero intenta la última conocida (rápida, no abre GNSS)
    final last = await Geolocator.getLastKnownPosition();
    if (last != null) return last;

    // 4) Si no hay, una sola lectura con baja precisión y límite de tiempo
    //    Esto evita que Geolocator inicie “position updates” prolongados/NMEA.
    return Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.low, // evita GNSS de alta carga
        timeLimit: Duration(seconds: 6), // corta si no llega
      ),
    );
  }

  /// Open-Meteo reverse geocoding
  /*Future<String> reverseName(
    double lat,
    double lon, {
    String lang = 'es',
  }) async {
    final r = await Dio().get(
      'https://geocoding-api.open-meteo.com/v1/reverse',
      queryParameters: {
        'latitude': lat,
        'longitude': lon,
        'language': lang,
        'count': 1,
        'format': 'json',
      },
    );
    final list = (r.data?['results'] as List?) ?? const [];
    if (list.isEmpty) return 'Ubicación';
    final m = list.first as Map<String, dynamic>;
    final name = (m['name'] ?? '').toString();
    final cc = (m['country_code'] ?? '').toString();
    return cc.isEmpty ? name : '$name, $cc';
  }*/

  /// Devuelve "Ciudad, CC" o null si no se pudo resolver en red.
  Future<String?> reverseName(
    double lat,
    double lon, {
    String lang = 'es',
  }) async {
    // Open-Meteo
    try {
      final r =
          await Dio(
            BaseOptions(
              connectTimeout: const Duration(seconds: 6),
              receiveTimeout: const Duration(seconds: 6),
              validateStatus: (code) => code != null && code < 500,
            ),
          ).get(
            'https://geocoding-api.open-meteo.com/v1/reverse',
            queryParameters: {
              'latitude': lat,
              'longitude': lon,
              'language': lang,
              'count': 1,
              'format': 'json',
            },
          );
      if (r.statusCode == 200) {
        final list = (r.data?['results'] as List?) ?? const [];
        if (list.isNotEmpty) {
          final m = list.first as Map<String, dynamic>;
          final nm = (m['name'] ?? '').toString();
          final cc = (m['country_code'] ?? '').toString();
          if (nm.isNotEmpty) return cc.isEmpty ? nm : '$nm, $cc';
        }
      }
    } catch (_) {}

    // Nominatim
    try {
      final r =
          await Dio(
            BaseOptions(
              connectTimeout: const Duration(seconds: 6),
              receiveTimeout: const Duration(seconds: 6),
              headers: {
                'User-Agent': 'Clima-Peru-App/1.0 (contacto: app@example.com)',
              },
              validateStatus: (code) => code != null && code < 500,
            ),
          ).get(
            'https://nominatim.openstreetmap.org/reverse',
            queryParameters: {
              'format': 'jsonv2',
              'lat': lat,
              'lon': lon,
              'accept-language': lang,
            },
          );
      if (r.statusCode == 200) {
        final addr = r.data?['address'] as Map<String, dynamic>?;
        String pick(List<String> ks) {
          for (final k in ks) {
            final v = (addr?[k] ?? '').toString();
            if (v.isNotEmpty) return v;
          }
          return '';
        }

        final city = pick([
          'city',
          'town',
          'village',
          'municipality',
          'county',
        ]);
        final cc = (addr?['country_code'] ?? '').toString().toUpperCase();
        if (city.isNotEmpty) return cc.isEmpty ? city : '$city, $cc';
      }
    } catch (_) {}

    return null; // <- que el provider haga fallback local
  }
}
