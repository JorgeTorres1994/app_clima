import 'package:app_clima/features/favorites/domain/favorite_city.dart';
import 'package:flutter/material.dart';

class FavoriteCityCard extends StatelessWidget {
  final FavoriteCity city;
  final VoidCallback onOpen;
  final Future<void> Function() onDelete;

  const FavoriteCityCard({
    super.key,
    required this.city,
    required this.onOpen,
    required this.onDelete,
  });

  String _coords(FavoriteCity c) {
    String f(double v) => v.toStringAsFixed(4);
    return 'lat ${f(c.lat)}, lon ${f(c.lon)}';
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Dismissible(
      key: ValueKey(city.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) async {
        // Confirmación rápida (evita borrar por accidente)
        return await showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('Eliminar favorito'),
                content: Text('¿Quitar "${city.name}" de tus favoritos?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx, false),
                    child: const Text('Cancelar'),
                  ),
                  FilledButton(
                    onPressed: () => Navigator.pop(ctx, true),
                    child: const Text('Eliminar'),
                  ),
                ],
              ),
            ) ??
            false;
      },
      onDismissed: (_) async => onDelete(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: cs.errorContainer,
        ),
        child: Icon(Icons.delete_outline, color: cs.onErrorContainer),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onOpen,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: cs.outlineVariant),
            color: cs.surface,
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: cs.surfaceContainerHighest.withOpacity(.6),
                ),
                child: Icon(Icons.place_outlined, color: cs.onSurfaceVariant),
              ),
              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      city.name,
                      style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w800),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _coords(city),
                      style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),
              IconButton(
                tooltip: 'Eliminar',
                onPressed: () async {
                  final ok = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Eliminar favorito'),
                          content: Text('¿Quitar "${city.name}" de tus favoritos?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx, false),
                              child: const Text('Cancelar'),
                            ),
                            FilledButton(
                              onPressed: () => Navigator.pop(ctx, true),
                              child: const Text('Eliminar'),
                            ),
                          ],
                        ),
                      ) ??
                      false;

                  if (ok) await onDelete();
                },
                icon: const Icon(Icons.delete_outline),
              ),
              Icon(Icons.chevron_right, color: cs.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}
