import 'package:app_clima/features/auth/application/auth_providers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ClearFavoritesButton extends ConsumerWidget {
  const ClearFavoritesButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FilledButton.tonal(
      onPressed: () async {
        final uid = ref.read(authRepoProvider).uid;
        if (uid == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No hay sesión')),
          );
          return;
        }
        final fs = FirebaseFirestore.instance;
        final col = fs.collection('users').doc(uid).collection('favorites');

        // Borrado por lotes (hasta 500 por batch)
        const page = 300;
        while (true) {
          final snap = await col.limit(page).get();
          if (snap.docs.isEmpty) break;
          final batch = fs.batch();
          for (final d in snap.docs) {
            batch.delete(d.reference);
          }
          await batch.commit();
          if (snap.docs.length < page) break;
        }

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Favoritos eliminados')),
          );
        }
      },
      child: const Text('Borrar favoritos (debug)'),
    );
  }
}
