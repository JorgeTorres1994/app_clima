// lib/features/favorites/application/favorites_repo.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/favorite_city.dart'; // Debe exponer: name, lat, lon, id

/// ---------------------------
/// Repositorio de favoritos
/// ---------------------------
class FavoritesRepo {
  final FirebaseFirestore _db;
  final FirebaseAuth _auth;
  FavoritesRepo(this._db, this._auth);

  CollectionReference<Map<String, dynamic>> _col() {
    final uid = _auth.currentUser?.uid;

    if (uid == null) {
      // Ahora tu app NO permite usar favoritos sin login,
      // pero devolvemos una colección "dummy" por seguridad.
      return _db.collection('_no_user_').doc('x').collection('_favorites_');
    }

    // El doc users/{uid} ya lo crea AuthRepo al registrarse.
    return _db.collection('users').doc(uid).collection('favorites');
  }

  /// Stream en vivo de todos los favoritos del usuario.
  Stream<List<FavoriteCity>> streamAll() {
    return _col().snapshots().map((snap) {
      return snap.docs.map((d) {
        final m = d.data();
        return FavoriteCity(
          m['name'] as String,
          (m['lat'] as num).toDouble(),
          (m['lon'] as num).toDouble(),
        );
      }).toList();
    });
  }

  /// Añade o elimina un favorito (toggle) usando el id estable (lat/lon).
  Future<void> toggle(FavoriteCity city) async {
    final doc = _col().doc(city.id);
    final exists = (await doc.get()).exists;
    if (exists) {
      await doc.delete();
    } else {
      await doc.set({
        'name': city.name,
        'lat': city.lat,
        'lon': city.lon,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  /// ¿Es favorito? (por objeto)
  Future<bool> isFav(FavoriteCity city) async {
    final snap = await _col().doc(city.id).get();
    return snap.exists;
  }

  /// ¿Es favorito? (por id estable) -> útil para Riverpod .family con clave String
  Future<bool> isFavById(String id) async {
    final snap = await _col().doc(id).get();
    return snap.exists;
  }

  /// Agregar favorito (set)
  Future<void> add(FavoriteCity city) async {
    await _col().doc(city.id).set({
      'name': city.name,
      'lat': city.lat,
      'lon': city.lon,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  /// Eliminar favorito (delete)
  Future<void> remove(FavoriteCity city) async {
    await _col().doc(city.id).delete();
  }

  /// Eliminar por id (útil para .family)
  Future<void> removeById(String id) async {
    await _col().doc(id).delete();
  }
}

/// ---------------------------
/// Providers
/// ---------------------------

/// Repo listo para usar
final favoritesRepoProvider = Provider<FavoritesRepo>((ref) {
  return FavoritesRepo(FirebaseFirestore.instance, FirebaseAuth.instance);
});

/// Stream con la lista de favoritos del usuario actual
final favoritesStreamProvider = StreamProvider<List<FavoriteCity>>((ref) {
  return ref.watch(favoritesRepoProvider).streamAll();
});

/// Consulta única: ¿la ciudad con este id es favorita?
/// Usar una **clave String estable** evita spinners infinitos.
final isFavoriteProvider = FutureProvider.family<bool, String>((ref, favId) {
  return ref.watch(favoritesRepoProvider).isFavById(favId);
});
