// lib/features/weather/presentation/widgets/home/current_weather_panel.dart
import 'package:app_clima/features/weather/domain/entities/weather.dart';
import 'package:app_clima/features/weather/presentation/widgets/home/current_weather_card.dart';
import 'package:app_clima/features/weather/presentation/widgets/home/current_weather_skeleton.dart';
import 'package:app_clima/features/weather/presentation/widgets/shared/app_error_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CurrentWeatherPanel extends StatelessWidget {
  final AsyncValue<Weather> weatherAsync;
  const CurrentWeatherPanel({super.key, required this.weatherAsync});

  @override
  Widget build(BuildContext context) {
    return weatherAsync.when(
      loading: () => const CurrentWeatherSkeleton(),
      error: (e, _) => AppErrorBox('Ups: $e'),
      data: (w) => CurrentWeatherCard(w: w),
    );
  }
}
