import '../entities/weather.dart';
import '../entities/forecast.dart';


abstract class WeatherRepo {
Future<Weather> getCurrentByQuery(String query, {String units = 'metric', String lang = 'es'});
Future<Weather> getCurrentByCoords(double lat, double lon, {String units = 'metric', String lang = 'es'});
Future<Forecast> getForecast(double lat, double lon, {String units = 'metric', String lang = 'es'});
}