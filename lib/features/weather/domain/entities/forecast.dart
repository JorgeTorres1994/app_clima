import 'package:freezed_annotation/freezed_annotation.dart';

part 'forecast.freezed.dart';
part 'forecast.g.dart';

@freezed
class Hourly with _$Hourly {
  const factory Hourly({
    required DateTime time,
    required double temp,
    required String icon,
  }) = _Hourly;

  factory Hourly.fromJson(Map<String, dynamic> json) => _$HourlyFromJson(json);
}

@freezed
class Daily with _$Daily {
  const factory Daily({
    required DateTime date,
    required double min,
    required double max,
    required String icon,
  }) = _Daily;

  factory Daily.fromJson(Map<String, dynamic> json) => _$DailyFromJson(json);
}

@freezed
class Forecast with _$Forecast {
  const factory Forecast({
    required List<Hourly> hourly,
    required List<Daily> daily,
  }) = _Forecast;

  factory Forecast.fromJson(Map<String, dynamic> json) => _$ForecastFromJson(json);
}
