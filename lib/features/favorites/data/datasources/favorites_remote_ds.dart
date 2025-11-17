import 'package:cloud_firestore/cloud_firestore.dart';

class FavoritesRemoteDS {
  final FirebaseFirestore db;
  FavoritesRemoteDS(this.db);

  CollectionReference<Map<String, dynamic>> _col(String uid) =>
      db.collection('users').doc(uid).collection('favorites');

  Future<void> add(String uid, Map<String, dynamic> city) =>
      _col(uid).doc(city['id'].toString()).set(city);
  Future<void> remove(String uid, String id) => _col(uid).doc(id).delete();
  Stream<List<Map<String, dynamic>>> list(String uid) =>
      _col(uid).snapshots().map((s) => s.docs.map((d) => d.data()).toList());
}
