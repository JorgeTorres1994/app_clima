// lib/features/weather/presentation/widgets/home/current_weather_card.dart
import 'package:app_clima/features/favorites/application/favorites_repo.dart';
import 'package:app_clima/features/favorites/domain/favorite_city.dart';
import 'package:app_clima/features/weather/domain/entities/weather.dart';
import 'package:app_clima/features/weather/presentation/controllers/weather_providers.dart';
import 'package:app_clima/features/weather/presentation/utils/weather_ui.dart';
import 'package:app_clima/features/weather/settings/application/settings_providers.dart';
import 'package:app_clima/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../shared/metric.dart';

class CurrentWeatherCard extends ConsumerWidget {
  final Weather w;
  const CurrentWeatherCard({super.key, required this.w});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;

    final sel = ref.watch(selectedCityProvider);
    final cityTitle = (w.locationName.isNotEmpty)
        ? w.locationName
        : (sel?.displayName ?? sel?.name ?? '—');

    final FavoriteCity? favCity = (sel == null)
        ? null
        : FavoriteCity(sel.displayName ?? sel.name, sel.lat, sel.lon);
    final String? favId = favCity?.id;

    final isFavAsync = (favId == null)
        ? const AsyncValue<bool>.data(false)
        : ref.watch(isFavoriteProvider(favId));

    final hourFmt = ref.watch(settingsProvider.select((s) => s.hourFormat));
    final localNow = DateTime.now().toUtc().add(
      Duration(seconds: w.utcOffsetSeconds),
    );
    final timeStr = (hourFmt == HourFormat.h)
        ? DateFormat('HH:mm').format(localNow)
        : DateFormat('h:mm a').format(localNow);

    final tempC = w.temp;
    final tempF = cToF(tempC);

    return Container(
      decoration: BoxDecoration(
        gradient: gradientForCondition(w.condition),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(20),
      child: DefaultTextStyle(
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: Colors.white,
            ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    cityTitle,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Colors.white,
                        ),
                    textAlign: TextAlign.left,
                  ),
                ),
                isFavAsync.when(
                  loading: () => const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  ),
                  error: (e, _) => IconButton(
                    tooltip: 'Reintentar',
                    icon: const Icon(Icons.refresh, color: Colors.white),
                    onPressed: () {
                      if (favId != null) ref.invalidate(isFavoriteProvider(favId));
                    },
                  ),
                  data: (isFav) => IconButton(
                    visualDensity: VisualDensity.compact,
                    tooltip:
                        isFav ? 'Quitar de favoritos' : 'Agregar a favoritos',
                    icon: Icon(
                      isFav ? Icons.star : Icons.star_border,
                      color: Colors.white,
                    ),
                    onPressed: (favCity == null || favId == null)
                        ? null
                        : () async {
                            try {
                              await ref.read(favoritesRepoProvider).toggle(favCity);
                              ref.invalidate(isFavoriteProvider(favId));
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      isFav
                                          ? 'Eliminado de favoritos'
                                          : 'Añadido a favoritos',
                                    ),
                                  ),
                                );
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error al guardar: $e')),
                                );
                              }
                            }
                          },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${tempC.toStringAsFixed(0)}°C  |  ${tempF.toStringAsFixed(0)}°F',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.displayMedium!.copyWith(
                    color: Colors.white,
                    letterSpacing: -1,
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 12),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 24,
              runSpacing: 8,
              children: [
                Metric(label: t.home_wind, value: '${w.windKph.toStringAsFixed(0)} km/h'),
                Metric(label: t.home_humidity, value: '${w.humidity.toStringAsFixed(0)}%'),
                Metric(label: t.home_updated_short, value: timeStr),
              ],
            ),
            const SizedBox(height: 8),
            if (w.condition.isNotEmpty)
              Chip(
                label: Text(w.condition),
                backgroundColor: Colors.white.withOpacity(.18),
                side: BorderSide.none,
                labelStyle: const TextStyle(color: Colors.white),
                visualDensity: VisualDensity.compact,
              ),
          ],
        ),
      ),
    );
  }
}
