// lib/features/weather/presentation/widgets/home/home_app_bar_actions.dart
import 'package:app_clima/features/favorites/application/location_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomeAppBarActions extends ConsumerWidget {
  const HomeAppBarActions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setCityState = ref.watch(setCurrentCityProvider);

    return Row(
      children: [
        IconButton(
          tooltip: 'Mi ubicación',
          onPressed: setCityState.isLoading
              ? null
              : () async {
                  try {
                    await ref.refresh(setCurrentCityProvider.future);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Ubicación establecida')),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'No se pudo obtener la ubicación del dispositivo: $e',
                          ),
                        ),
                      );
                    }
                  }
                },
          icon: setCityState.isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.my_location),
        ),
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () => context.push('/search'),
        ),
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () => context.push('/settings'),
        ),
      ],
    );
  }
}
