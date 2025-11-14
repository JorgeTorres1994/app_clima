import '../entities/weather.dart';
import '../repos/weather_repo.dart';


class GetCurrentWeather {
final WeatherRepo repo;
GetCurrentWeather(this.repo);
Future<Weather> byQuery(String q, {String units = 'metric', String lang = 'es'}) =>
repo.getCurrentByQuery(q, units: units, lang: lang);
Future<Weather> byCoords(double lat, double lon, {String units = 'metric', String lang = 'es'}) =>
repo.getCurrentByCoords(lat, lon, units: units, lang: lang);
}