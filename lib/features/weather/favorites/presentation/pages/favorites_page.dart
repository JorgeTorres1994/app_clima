import 'package:flutter/material.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Placeholder elegante hasta conectar Firestore
    return Scaffold(
      appBar: AppBar(title: const Text('Favoritos')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.star_border, size: 56, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 8),
            const Text('Aún no tienes ciudades favoritas'),
            const SizedBox(height: 4),
            const Text('Busca una ciudad y toca ⭐ para guardarla', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
