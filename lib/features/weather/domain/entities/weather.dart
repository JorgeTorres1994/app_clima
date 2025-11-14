import 'package:freezed_annotation/freezed_annotation.dart';

part 'weather.freezed.dart';
part 'weather.g.dart';

@freezed
class Weather with _$Weather {
  const factory Weather({
    required String locationName,
    required double lat,
    required double lon,
    required double temp,
    required double feelsLike,
    required String condition,
    required String icon,
    required double humidity,
    required double windKph,
    required DateTime updatedAt,
  }) = _Weather;

  factory Weather.fromJson(Map<String, dynamic> json) => _$WeatherFromJson(json);
}
