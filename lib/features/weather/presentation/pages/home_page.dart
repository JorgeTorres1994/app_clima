import 'package:app_clima/features/weather/presentation/controllers/weather_providers.dart';
import 'package:app_clima/features/weather/presentation/widgets/home/current_weather_panel.dart';
import 'package:app_clima/features/weather/presentation/widgets/home/forecast_panel.dart';
import 'package:app_clima/features/weather/presentation/widgets/home/home_app_bar_actions.dart';
import 'package:app_clima/features/weather/presentation/widgets/home/city_map_panel.dart'; // ✅ NUEVO
import 'package:app_clima/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;

    final weatherAsync = ref.watch(currentWeatherByCityProvider);
    final forecastAsync = ref.watch(forecastByCityProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(t.home_title),
        actions: const [
          HomeAppBarActions(),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(currentWeatherByCityProvider);
          ref.invalidate(forecastByCityProvider);
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            CurrentWeatherPanel(weatherAsync: weatherAsync),
            const SizedBox(height: 16),

            // ✅ MAPA (preview)
            CityMapPanel(weatherAsync: weatherAsync),

            const SizedBox(height: 24),
            ForecastPanel(forecastAsync: forecastAsync),
          ],
        ),
      ),
    );
  }
}
