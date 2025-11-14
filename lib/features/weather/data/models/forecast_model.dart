import '../../domain/entities/forecast.dart';


class ForecastModel {
final List<Hourly> hourly; final List<Daily> daily;
ForecastModel({required this.hourly, required this.daily});


factory ForecastModel.fromOpenWeather(Map<String, dynamic> j) {
final h = (j['hourly'] as List).take(48).map((e) => Hourly(
time: DateTime.fromMillisecondsSinceEpoch((e['dt'] as int) * 1000, isUtc: true),
temp: (e['temp'] as num).toDouble(),
icon: e['weather'][0]['icon'],
)).toList();
final d = (j['daily'] as List).take(7).map((e) => Daily(
date: DateTime.fromMillisecondsSinceEpoch((e['dt'] as int) * 1000, isUtc: true),
min: (e['temp']['min'] as num).toDouble(),
max: (e['temp']['max'] as num).toDouble(),
icon: e['weather'][0]['icon'],
)).toList();
return ForecastModel(hourly: h, daily: d);
}


Forecast toEntity() => Forecast(hourly: hourly, daily: daily);
}