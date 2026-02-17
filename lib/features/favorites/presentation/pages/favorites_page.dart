import 'package:app_clima/features/weather/presentation/controllers/weather_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../application/favorites_repo.dart';
import '../widgets/favorite_city_card.dart';
import '../widgets/favorites_empty_state.dart';
import '../widgets/favorites_header.dart';

class FavoritesPage extends ConsumerWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favsAsync = ref.watch(favoritesStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoritos'),
      ),
      body: favsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (list) {
          if (list.isEmpty) {
            return const FavoritesEmptyState();
          }

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            children: [
              FavoritesHeader(count: list.length),
              const SizedBox(height: 12),

              ...list.map((c) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: FavoriteCityCard(
                    city: c,
                    onOpen: () {
                      ref.read(selectedCityProvider.notifier).state =
                          CitySelection(c.name, c.lat, c.lon, display: c.name);

                      ref.invalidate(currentWeatherByCityProvider);
                      ref.invalidate(forecastByCityProvider);
                      context.go('/'); // Home
                    },
                    onDelete: () async {
                      await ref.read(favoritesRepoProvider).toggle(c);
                      ref.invalidate(favoritesStreamProvider);

                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${c.name} eliminado de favoritos'),
                          ),
                        );
                      }
                    },
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }
}
