import 'package:app_clima/features/auth/application/auth_providers.dart';
import 'package:app_clima/features/favorites/application/favorites_repo.dart';
import 'package:app_clima/features/favorites/domain/favorite_city.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class FavoriteStarButton extends ConsumerWidget {
  final String name;
  final double lat;
  final double lon;

  const FavoriteStarButton({
    super.key,
    required this.name,
    required this.lat,
    required this.lon,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).valueOrNull;
    final fav = FavoriteCity(name, lat, lon);

    // Si no hay sesión: muestra estrella desactivada (o manda a login)
    if (user == null) {
      return IconButton(
        tooltip: 'Inicia sesión para guardar favoritos',
        icon: const Icon(Icons.star_border),
        onPressed: () => context.push('/login'),
      );
    }

    final isFavAsync = ref.watch(isFavoriteProvider(fav.id));

    final isFav = isFavAsync.maybeWhen(
      data: (v) => v,
      orElse: () => false,
    );

    return IconButton(
      tooltip: isFav ? 'Quitar de favoritos' : 'Agregar a favoritos',
      icon: Icon(isFav ? Icons.star : Icons.star_border),
      onPressed: () async {
        try {
          await ref.read(favoritesRepoProvider).toggle(fav);

          // ✅ fuerza refresh inmediato (porque isFavoriteProvider es FutureProvider)
          ref.invalidate(isFavoriteProvider(fav.id));
          ref.invalidate(favoritesStreamProvider);

          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(isFav ? 'Quitado de favoritos' : 'Agregado a favoritos'),
              ),
            );
          }
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: $e')),
            );
          }
        }
      },
    );
  }
}
