import '../../domain/entities/weather.dart';


class WeatherModel {
final String name; final double lat; final double lon; final double temp;
final double feels; final String cond; final String icon; final double hum; final double wind;
WeatherModel({
required this.name, required this.lat, required this.lon, required this.temp,
required this.feels, required this.cond, required this.icon, required this.hum, required this.wind,
});


factory WeatherModel.fromOpenWeather(Map<String, dynamic> j) {
return WeatherModel(
name: j['name'] ?? '-',
lat: (j['coord']['lat'] as num).toDouble(),
lon: (j['coord']['lon'] as num).toDouble(),
temp: (j['main']['temp'] as num).toDouble(),
feels: (j['main']['feels_like'] as num).toDouble(),
cond: j['weather'][0]['description'],
icon: j['weather'][0]['icon'],
hum: (j['main']['humidity'] as num).toDouble(),
wind: (j['wind']['speed'] as num).toDouble(),
);
}


Weather toEntity() => Weather(
locationName: name, lat: lat, lon: lon, temp: temp, feelsLike: feels,
condition: cond, icon: icon, humidity: hum, windKph: wind * 3.6,
updatedAt: DateTime.now(),
);
}