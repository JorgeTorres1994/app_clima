import 'package:app_clima/features/favorites/application/location_providers.dart';
import 'package:app_clima/features/weather/domain/entities/weather.dart';
import 'package:app_clima/features/weather/presentation/controllers/weather_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'city_map_preview.dart';
import 'city_map_skeleton.dart';

class CityMapPanel extends ConsumerWidget {
  final AsyncValue<Weather> weatherAsync;
  const CityMapPanel({super.key, required this.weatherAsync});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sel = ref.watch(selectedCityProvider);

    return weatherAsync.when(
      loading: () => const CityMapSkeleton(),
      error: (_, __) => const SizedBox.shrink(), // si falla, no estorba
      data: (w) {
        final lat = sel?.lat ?? w.lat;
        final lon = sel?.lon ?? w.lon;

        // Si tu Weather no tiene lat/lon, deja solo sel?.lat/lon y listo.
        if (lat == null || lon == null) return const SizedBox.shrink();

        final title = (w.locationName.isNotEmpty)
            ? w.locationName
            : (sel?.displayName ?? sel?.name ?? '—');

        return CityMapPreview(
          title: title,
          lat: lat,
          lon: lon,
          condition: w.condition,
          tempC: w.temp,
        );
      },
    );
  }
}
