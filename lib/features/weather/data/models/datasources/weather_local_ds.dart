import 'package:hive/hive.dart';


class WeatherLocalDS {
final Box box;
WeatherLocalDS(this.box);


Future<void> cache(String key, Map<String, dynamic> value) async => box.put(key, value);
Map<String, dynamic>? read(String key) => box.get(key)?.cast<String, dynamic>();
}