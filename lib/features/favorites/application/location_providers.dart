import 'package:app_clima/bootstrap.dart';
import 'package:app_clima/features/weather/presentation/controllers/weather_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'location_service.dart';
import 'nearest_city_resolver.dart';

final locationServiceProvider = Provider<LocationService>((ref) {
  final dio = ref.read(dioProvider);
  return LocationService(dio);
});

/// Acción: setear ciudad actual por GPS (con fallback local)
/*final setCurrentCityProvider = FutureProvider<void>((ref) async {
  final svc = ref.read(locationServiceProvider);
  final pos = await svc.currentPosition();

  // intenta nombrar por red
  final nameNet = await svc.reverseName(pos.latitude, pos.longitude);

  // si no hay, nombrar por dataset local (nearest)
  String display;
  if (nameNet != null && nameNet.trim().isNotEmpty) {
    display = nameNet;
  } else {
    final near = await NearestCityResolver.nearest(pos.latitude, pos.longitude);
    display = near['name'] as String;
  }

  ref.read(selectedCityProvider.notifier).state =
      CitySelection(display, pos.latitude, pos.longitude, display: display);

  // refresca data
  ref.invalidate(currentWeatherByCityProvider);
  ref.invalidate(forecastByCityProvider);
});*/

// lib/features/location/application/location_providers.dart
final setCurrentCityProvider = FutureProvider<void>((ref) async {
  final svc = ref.read(locationServiceProvider);
  final pos = await svc.currentPosition();

  final nameNet = await svc.reverseName(
    pos.latitude,
    pos.longitude,
    lang: 'es',
  );

  // Si NO termina en ", PE" (o es nulo), forzamos ciudad peruana más cercana.
  /*bool outOfPeru =
      nameNet == null || !nameNet.trim().toUpperCase().endsWith(', PE');*/
  final raw = nameNet?.trim() ?? '';
  final outOfPeru = raw.isEmpty || !raw.toUpperCase().endsWith(', PE');

  String display;
  double lat = pos.latitude;
  double lon = pos.longitude;

  if (outOfPeru) {
    final near = await NearestCityResolver.nearest(pos.latitude, pos.longitude);
    display = near['name'] as String; // "Cusco, PE"
    lat = near['lat'] as double;
    lon = near['lon'] as double;
  } else {
    display = raw; // p.ej. "Iquitos, PE"
  }

  ref.read(selectedCityProvider.notifier).state = CitySelection(
    display,
    lat,
    lon,
    display: display,
  );

  ref.invalidate(currentWeatherByCityProvider);
  ref.invalidate(forecastByCityProvider);
});
