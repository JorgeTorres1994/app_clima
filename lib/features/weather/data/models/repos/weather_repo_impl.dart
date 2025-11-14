import 'package:app_clima/features/weather/data/models/forecast_model.dart';
import 'package:app_clima/features/weather/data/models/weather_model.dart';
import 'package:app_clima/features/weather/domain/entities/forecast.dart';
import 'package:app_clima/features/weather/domain/entities/weather.dart';
import 'package:app_clima/features/weather/domain/repos/weather_repo.dart';
import '../datasources/weather_local_ds.dart';
import '../datasources/weather_remote_ds.dart';

class WeatherRepoImpl implements WeatherRepo {
  final WeatherRemoteDS remote;
  final WeatherLocalDS local;
  WeatherRepoImpl({required this.remote, required this.local});

  @override
  Future<Weather> getCurrentByQuery(
    String q, {
    String units = 'metric',
    String lang = 'es',
  }) async {
    final key = 'current:q=$q:$units:$lang';
    try {
      final j = await remote.currentByQuery(q, units: units, lang: lang);
      local.cache(key, j);
      return WeatherModel.fromOpenWeather(j).toEntity();
    } catch (_) {
      final cached = local.read(key);
      if (cached != null)
        return WeatherModel.fromOpenWeather(cached).toEntity();
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
    final key = 'current:lat=$lat:lon=$lon:$units:$lang';
    try {
      final j = await remote.currentByCoords(
        lat,
        lon,
        units: units,
        lang: lang,
      );
      local.cache(key, j);
      return WeatherModel.fromOpenWeather(j).toEntity();
    } catch (_) {
      final cached = local.read(key);
      if (cached != null)
        return WeatherModel.fromOpenWeather(cached).toEntity();
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
      final j = await remote.forecast(lat, lon, units: units, lang: lang);
      local.cache(key, j);
      return ForecastModel.fromOpenWeather(j).toEntity();
    } catch (_) {
      final cached = local.read(key);
      if (cached != null)
        return ForecastModel.fromOpenWeather(cached).toEntity();
      rethrow;
    }
  }
}
