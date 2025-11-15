// lib/features/weather/data/repos/weather_repo_impl.dart
import 'package:app_clima/features/weather/data/models/forecast_model.dart';
import 'package:app_clima/features/weather/domain/entities/forecast.dart';
import 'package:app_clima/features/weather/domain/entities/weather.dart';
import 'package:app_clima/features/weather/domain/repos/weather_repo.dart';

import '../datasources/weather_local_ds.dart';
import '../datasources/weather_remote_ds.dart';

class WeatherRepoImpl implements WeatherRepo {
  final WeatherRemoteDS remote;
  final WeatherLocalDS local;

  WeatherRepoImpl({required this.remote, required this.local});

  /// IMPORTANTE:
  /// Ahora `remote` expone `getCurrent()` que devuelve `Weather` ya mapeado
  /// (usa la ciudad seleccionada en `selectedCityProvider`).
  /// Para flujo "buscar por texto", la UI primero establece la ciudad seleccionada
  /// y luego llamamos a este método.

  @override
  Future<Weather> getCurrentByQuery(
    String q, {
    String units = 'metric',
    String lang = 'es',
  }) async {
    final key = 'current:q=$q:$units:$lang';
    try {
      final w = await remote.getCurrent();
      // Cacheamos como JSON (la entidad tiene toJson generado por Freezed/JsonSerializable)
      local.cache(key, w.toJson());
      return w;
    } catch (_) {
      final cached = local.read(key);
      if (cached != null) {
        return Weather.fromJson(Map<String, dynamic>.from(cached));
      }
      rethrow;
    }
  }

  @override
  Future<Weather> getCurrentByCoords(
    double lat,
    double lon, {
    String units = 'metric',
    String lang = 'es',
  }) async {
    // Nota: con el diseño actual, `remote.getCurrent()` lee la ciudad desde
    // `selectedCityProvider`. Si llamas por coords, asegúrate que la UI haya
    // actualizado ese provider antes. De lo contrario, puedes crear un método
    // `remote.getCurrentByCoords(lat, lon, displayName)` y usarlo aquí.
    final key = 'current:lat=$lat:lon=$lon:$units:$lang';
    try {
      final w = await remote.getCurrent();
      local.cache(key, w.toJson());
      return w;
    } catch (_) {
      final cached = local.read(key);
      if (cached != null) {
        return Weather.fromJson(Map<String, dynamic>.from(cached));
      }
      rethrow;
    }
  }

  @override
  Future<Forecast> getForecast(
    double lat,
    double lon, {
    String units = 'metric',
    String lang = 'es',
  }) async {
    final key = 'forecast:lat=$lat:lon=$lon:$units:$lang';
    try {
      // Remote devuelve: { hourly: [...], daily: [...] }
      final j = await remote.forecast(lat, lon, units: units, lang: lang);

      // Cachear tal cual el Map (para offline)
      local.cache(key, j);

      // ✅ Usa tu modelador que ya mapea ese shape a la entidad
      return ForecastModel.fromOpenWeather(j).toEntity();
    } catch (_) {
      final cached = local.read(key);
      if (cached != null) {
        return ForecastModel.fromOpenWeather(
          Map<String, dynamic>.from(cached),
        ).toEntity();
      }
      rethrow;
    }
  }
}
