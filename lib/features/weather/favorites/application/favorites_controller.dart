import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../../favorites/domain/favorite_city.dart';

const _kFavKey = 'favorites.list';

class FavoritesController extends StateNotifier<List<FavoriteCity>> {
  final Box box;
  FavoritesController(this.box) : super(_load(box));

  static List<FavoriteCity> _load(Box b) {
    final raw = (b.get(_kFavKey) as List?) ?? const [];
    return raw.cast<Map>().map((e) => FavoriteCity.fromMap(e.cast<String, dynamic>())).toList();
  }

  Future<void> _save() async => box.put(_kFavKey, state.map((e) => e.toMap()).toList());

  bool contains(double lat, double lon) =>
      state.any((c) => (c.lat == lat && c.lon == lon));

  Future<void> toggle(FavoriteCity city) async {
    final exists = contains(city.lat, city.lon);
    state = exists ? state.where((c) => !(c.lat == city.lat && c.lon == city.lon)).toList()
                   : [...state, city];
    await _save();
  }
}
