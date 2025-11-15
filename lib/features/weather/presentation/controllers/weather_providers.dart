import 'package:app_clima/features/weather/data/models/datasources/weather_local_ds.dart';
import 'package:app_clima/features/weather/data/models/datasources/weather_remote_ds.dart';
import 'package:app_clima/features/weather/data/models/repos/weather_repo_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../weather/domain/repos/weather_repo.dart';
import '../../../weather/domain/usecases/get_current_weather.dart';
import '../../../weather/domain/usecases/get_forecast.dart';

import '../../../../bootstrap.dart'; // para dioProvider, hiveBoxProvider
import '../../domain/entities/weather.dart';
import '../../domain/entities/forecast.dart';

final remoteDSProvider = Provider<WeatherRemoteDS>((ref) {
  final dio = ref.watch(dioProvider);
  return WeatherRemoteDS(dio, ref);
});

final localDSProvider = Provider<WeatherLocalDS>((ref) {
  final box = ref.watch(hiveBoxProvider);
  return WeatherLocalDS(box);
});

final weatherRepoProvider = Provider<WeatherRepo>((ref) {
  return WeatherRepoImpl(
    remote: ref.watch(remoteDSProvider),
    local: ref.watch(localDSProvider),
  );
});

final getCurrentWeatherProvider = Provider<GetCurrentWeather>((ref) {
  return GetCurrentWeather(ref.watch(weatherRepoProvider));
});

final getForecastProvider = Provider<GetForecast>((ref) {
  return GetForecast(ref.watch(weatherRepoProvider));
});

/// Estado actual por ciudad seleccionada (lat/lon)
class CitySelection {
  final String name;
  final double lat;
  final double lon;
  final String displayName; // ej. "Cusco, PE"
  CitySelection(this.name, this.lat, this.lon, {String? display})
    : displayName = display ?? name;
}

final selectedCityProvider = StateProvider<CitySelection?>((_) => CitySelection(
  'Lima', -12.0464, -77.0428, display: 'Lima, PE',
));

/// Clima actual (Async) en base a ciudad seleccionada (o Lima por defecto)
final currentWeatherByCityProvider = FutureProvider<Weather>((ref) async {
  final usecase = ref.watch(getCurrentWeatherProvider);
  final selected = ref.watch(selectedCityProvider);
  if (selected != null) {
    return usecase.byCoords(
      selected.lat,
      selected.lon,
      units: 'metric',
      lang: 'es',
    );
  }
  // Fallback: Lima
  return usecase.byQuery('Lima', units: 'metric', lang: 'es');
});

/// Forecast (Async) en base a ciudad
final forecastByCityProvider = FutureProvider<Forecast>((ref) async {
  final usecase = ref.watch(getForecastProvider);
  final selected = ref.watch(selectedCityProvider);
  if (selected != null) {
    return usecase(selected.lat, selected.lon, units: 'metric', lang: 'es');
  }
  // Lima fallback (coords aprox)
  return usecase(-12.0464, -77.0428, units: 'metric', lang: 'es');
});
