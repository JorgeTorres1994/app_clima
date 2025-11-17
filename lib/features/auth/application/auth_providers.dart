import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthRepo {
  final FirebaseAuth _auth;
  final FirebaseFirestore _db;

  AuthRepo(this._auth, this._db);

  Stream<User?> authStateChanges() => _auth.authStateChanges();

  User? get user => _auth.currentUser;
  String? get uid => _auth.currentUser?.uid;

  /// 🔹 Crea / actualiza el doc users/{uid} con datos básicos
  Future<void> _upsertUserProfile(
    User user, {
    String? displayNameOverride,
  }) async {
    final docRef = _db.collection('users').doc(user.uid);

    await docRef.set({
      'email': user.email,
      'displayName': displayNameOverride ?? user.displayName,
      'updatedAt': FieldValue.serverTimestamp(),
      // si ya existe, Firestore conserva el createdAt anterior
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  /// LOGIN
  Future<UserCredential> signInWithEmail(String email, String password) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = cred.user;
    if (user != null) {
      await _upsertUserProfile(user);
    }

    return cred;
  }

  /// REGISTRO
  Future<UserCredential> registerWithEmail({
    required String email,
    required String password,
    String? displayName,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = cred.user;
    if (user != null) {
      if (displayName != null && displayName.isNotEmpty) {
        await user.updateDisplayName(displayName);
      }

      await _upsertUserProfile(user, displayNameOverride: displayName);
    }

    return cred;
  }

  Future<void> signOut() => _auth.signOut();
}

/// Provider del repo
final authRepoProvider = Provider<AuthRepo>((ref) {
  return AuthRepo(FirebaseAuth.instance, FirebaseFirestore.instance);
});

/// Usuario reactivo
final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authRepoProvider).authStateChanges();
});
