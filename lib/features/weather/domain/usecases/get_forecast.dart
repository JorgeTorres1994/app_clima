import '../entities/forecast.dart';
import '../repos/weather_repo.dart';


class GetForecast {
final WeatherRepo repo;
GetForecast(this.repo);
Future<Forecast> call(double lat, double lon, {String units = 'metric', String lang = 'es'}) =>
repo.getForecast(lat, lon, units: units, lang: lang);
}