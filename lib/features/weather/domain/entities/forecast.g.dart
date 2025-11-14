// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forecast.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HourlyImpl _$$HourlyImplFromJson(Map<String, dynamic> json) => _$HourlyImpl(
  time: DateTime.parse(json['time'] as String),
  temp: (json['temp'] as num).toDouble(),
  icon: json['icon'] as String,
);

Map<String, dynamic> _$$HourlyImplToJson(_$HourlyImpl instance) =>
    <String, dynamic>{
      'time': instance.time.toIso8601String(),
      'temp': instance.temp,
      'icon': instance.icon,
    };

_$DailyImpl _$$DailyImplFromJson(Map<String, dynamic> json) => _$DailyImpl(
  date: DateTime.parse(json['date'] as String),
  min: (json['min'] as num).toDouble(),
  max: (json['max'] as num).toDouble(),
  icon: json['icon'] as String,
);

Map<String, dynamic> _$$DailyImplToJson(_$DailyImpl instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'min': instance.min,
      'max': instance.max,
      'icon': instance.icon,
    };

_$ForecastImpl _$$ForecastImplFromJson(Map<String, dynamic> json) =>
    _$ForecastImpl(
      hourly: (json['hourly'] as List<dynamic>)
          .map((e) => Hourly.fromJson(e as Map<String, dynamic>))
          .toList(),
      daily: (json['daily'] as List<dynamic>)
          .map((e) => Daily.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$ForecastImplToJson(_$ForecastImpl instance) =>
    <String, dynamic>{'hourly': instance.hourly, 'daily': instance.daily};
