import 'package:app_clima/features/weather/presentation/controllers/weather_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../application/favorites_repo.dart';
import '../../domain/favorite_city.dart';

class FavoritesPage extends ConsumerWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favs = ref.watch(favoritesStreamProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Favoritos')),
      body: favs.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (list) {
          if (list.isEmpty) {
            return const Center(child: Text('Aún no tienes favoritos.'));
          }
          return ListView.separated(
            itemCount: list.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (_, i) {
              final FavoriteCity c = list[i];
              return ListTile(
                leading: const Icon(Icons.place_outlined),
                title: Text(c.name),
                subtitle: Text('lat ${c.lat}, lon ${c.lon}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () async {
                    await ref.read(favoritesRepoProvider).toggle(c);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Eliminado de favoritos')),
                      );
                    }
                  },
                ),
                onTap: () {
                  // Establece ciudad y regresa al Home
                  ref.read(selectedCityProvider.notifier).state =
                      // Si tu CitySelection admite 'displayName', usa esa línea;
                      // si no existe, usa el constructor sin named param.
                      CitySelection(c.name, c.lat, c.lon, display: c.name);
                  // CitySelection(c.name, c.lat, c.lon);

                  ref.invalidate(currentWeatherByCityProvider);
                  ref.invalidate(forecastByCityProvider);
                  context.go('/'); // Home
                },
              );
            },
          );
        },
      ),
    );
  }
}
