// lib/features/weather/presentation/widgets/home/forecast_panel.dart
import 'package:app_clima/features/weather/domain/entities/forecast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../shared/app_error_box.dart';
import 'forecast_section.dart';
import 'forecast_skeleton.dart';

class ForecastPanel extends StatelessWidget {
  final AsyncValue<Forecast> forecastAsync;
  const ForecastPanel({super.key, required this.forecastAsync});

  @override
  Widget build(BuildContext context) {
    return forecastAsync.when(
      loading: () => const ForecastSkeleton(),
      error: (e, _) => AppErrorBox('Ups: $e'),
      data: (f) => ForecastSection(f: f),
    );
  }
}
