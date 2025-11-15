import 'package:freezed_annotation/freezed_annotation.dart';

part 'weather.freezed.dart';
part 'weather.g.dart';

@freezed
class Weather with _$Weather {
  const factory Weather({
    required String locationName, // lo podemos sobreescribir con copyWith
    required double lat,
    required double lon,
    required double temp,
    required double feelsLike,
    required String condition,
    required String icon,
    required double humidity,
    required double windKph,
    required DateTime updatedAt,

    // Nuevos campos
    @Default(0) int utcOffsetSeconds,
    @Default('UTC') String timezone,
  }) = _Weather;

  // fromJson para persistencia simple (si usas Hive/REST local). OJO:
  // Si tu API viene anidada (ej. "current": {...}) no pongas ese JSON directo aquí.
  factory Weather.fromJson(Map<String, dynamic> json) =>
      _$WeatherFromJson(json);
}

/// Mapper auxiliar para convertir la respuesta del API (Open-Meteo u otra)
/// a nuestra entidad Weather. Úsalo en el repositorio/datasource.
extension WeatherMapper on Map<String, dynamic> {
  Weather toWeather({
    required String displayName, // ej. "Cusco, PE"
    required double lat,
    required double lon,
  }) {
    final current = this['current'] as Map<String, dynamic>? ?? {};
    return Weather(
      locationName: displayName,
      lat: lat,
      lon: lon,
      temp: (current['temperature_2m'] as num).toDouble(),
      feelsLike: (current['apparent_temperature'] as num).toDouble(),
      condition: (current['weather_text'] ?? '') as String,
      icon: (current['weather_icon'] ?? '') as String,
      humidity: (current['relative_humidity_2m'] as num).toDouble(),
      windKph: (current['wind_speed_10m'] as num).toDouble(),
      updatedAt: DateTime.parse(
        (current['time'] ?? this['time']) as String,
      ).toUtc(),
      utcOffsetSeconds: (this['utc_offset_seconds'] ?? 0) as int,
      timezone: (this['timezone'] ?? 'UTC') as String,
    );
  }
}
