// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WeatherImpl _$$WeatherImplFromJson(Map<String, dynamic> json) =>
    _$WeatherImpl(
      locationName: json['locationName'] as String,
      lat: (json['lat'] as num).toDouble(),
      lon: (json['lon'] as num).toDouble(),
      temp: (json['temp'] as num).toDouble(),
      feelsLike: (json['feelsLike'] as num).toDouble(),
      condition: json['condition'] as String,
      icon: json['icon'] as String,
      humidity: (json['humidity'] as num).toDouble(),
      windKph: (json['windKph'] as num).toDouble(),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      utcOffsetSeconds: (json['utcOffsetSeconds'] as num?)?.toInt() ?? 0,
      timezone: json['timezone'] as String? ?? 'UTC',
    );

Map<String, dynamic> _$$WeatherImplToJson(_$WeatherImpl instance) =>
    <String, dynamic>{
      'locationName': instance.locationName,
      'lat': instance.lat,
      'lon': instance.lon,
      'temp': instance.temp,
      'feelsLike': instance.feelsLike,
      'condition': instance.condition,
      'icon': instance.icon,
      'humidity': instance.humidity,
      'windKph': instance.windKph,
      'updatedAt': instance.updatedAt.toIso8601String(),
      'utcOffsetSeconds': instance.utcOffsetSeconds,
      'timezone': instance.timezone,
    };
