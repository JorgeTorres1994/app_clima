import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../../favorites/domain/favorite_city.dart';
import 'favorites_controller.dart';

final _boxProvider = Provider<Box>((_) => Hive.box('cache'));

final favoritesProvider =
    StateNotifierProvider<FavoritesController, List<FavoriteCity>>((ref) {
  final box = ref.watch(_boxProvider);
  return FavoritesController(box);
});
