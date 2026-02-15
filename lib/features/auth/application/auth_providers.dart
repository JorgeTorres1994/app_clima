import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthRepo {
  final FirebaseAuth _auth;
  final FirebaseFirestore _db;
  final FirebaseStorage _storage;

  AuthRepo(this._auth, this._db, this._storage);

  Stream<User?> authStateChanges() => _auth.authStateChanges();

  User? get user => _auth.currentUser;
  String? get uid => _auth.currentUser?.uid;

  // ----------------------------
  // Helpers (birthday formatting)
  // ----------------------------

  /// "2005-02-14"
  String _toYmd(DateTime d) {
    final y = d.year.toString().padLeft(4, '0');
    final m = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '$y-$m-$day';
  }

  /// "14 de febrero de 2005"
  String _birthDateDisplayEs(DateTime d) {
    const months = [
      'enero',
      'febrero',
      'marzo',
      'abril',
      'mayo',
      'junio',
      'julio',
      'agosto',
      'septiembre',
      'octubre',
      'noviembre',
      'diciembre',
    ];
    return '${d.day} de ${months[d.month - 1]} de ${d.year}';
  }

  // ----------------------------
  // Core profile upsert
  // ----------------------------

  /// ✅ Crea/actualiza users/{uid}
  /// - createdAt: solo se crea si el doc NO existe
  /// - updatedAt: siempre se actualiza
  Future<void> _upsertUserProfile(
    User user, {
    String? displayNameOverride,
  }) async {
    final docRef = _db.collection('users').doc(user.uid);

    await _db.runTransaction((tx) async {
      final snap = await tx.get(docRef);

      final dataToMerge = <String, dynamic>{
        'email': user.email,
        'displayName': displayNameOverride ?? user.displayName,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (!snap.exists) {
        dataToMerge['createdAt'] = FieldValue.serverTimestamp();
      }

      tx.set(docRef, dataToMerge, SetOptions(merge: true));
    });
  }

  // ----------------------------
  // Photo upload (ONLY photo)
  // ----------------------------

  /// ✅ Sube/actualiza foto de perfil (sin tocar nombre/cumpleaños)
  /// Devuelve la URL pública
  Future<String> uploadProfilePhoto({required Uint8List photoBytes}) async {
    final current = _auth.currentUser;
    if (current == null) throw Exception('No hay usuario autenticado');
    if (photoBytes.isEmpty) throw Exception('La imagen está vacía');

    final ref = _storage.ref().child('users/${current.uid}/avatar.jpg');

    final metadata = SettableMetadata(
      contentType: 'image/jpeg',
      cacheControl: 'public,max-age=86400',
    );

    await ref.putData(photoBytes, metadata);
    final url = await ref.getDownloadURL();

    // Guardar en Auth
    await current.updatePhotoURL(url);

    // Guardar en Firestore
    final docRef = _db.collection('users').doc(current.uid);
    await docRef.set({
      'photoUrl': url,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    return url;
  }

  // ----------------------------
  // Extras profile upsert (register or later)
  // ----------------------------

  /// ✅ Guarda extras del perfil (nombre, apellidos, cumpleaños, foto opcional)
  /// - Cumpleaños se guarda como:
  ///   - birthDateYmd: "YYYY-MM-DD" (sin hora)
  ///   - birthDateDisplay: "14 de febrero de 2005" (bonito, sin hora)
  /// - Sube foto a Storage si se envían bytes.
  Future<void> upsertUserProfileExtras({
    required String firstName,
    required String lastName,
    required DateTime birthDate,
    Uint8List? photoBytes,
  }) async {
    final current = _auth.currentUser;
    if (current == null) throw Exception('No hay usuario autenticado');

    String? photoUrl;

    // 1) Subir foto (opcional)
    if (photoBytes != null && photoBytes.isNotEmpty) {
      photoUrl = await uploadProfilePhoto(photoBytes: photoBytes);
    }

    // 2) Guardar en Firestore (sin hora para cumpleaños)
    final docRef = _db.collection('users').doc(current.uid);

    await docRef.set({
      'firstName': firstName.trim(),
      'lastName': lastName.trim(),
      'birthDateYmd': _toYmd(birthDate),
      'birthDateDisplay': _birthDateDisplayEs(birthDate),
      if (photoUrl != null) 'photoUrl': photoUrl,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  /// ✅ Actualiza nombre/apellidos/cumpleaños (sin foto)
  Future<void> updateUserProfileExtras({
    required String firstName,
    required String lastName,
    required DateTime birthDate,
  }) async {
    final current = _auth.currentUser;
    if (current == null) throw Exception('No hay usuario autenticado');

    final docRef = _db.collection('users').doc(current.uid);

    final f = firstName.trim();
    final l = lastName.trim();
    final fullName = ('$f $l').trim();

    await docRef.set({
      'firstName': f,
      'lastName': l,
      'displayName': fullName,
      'birthDateYmd': _toYmd(birthDate),
      'birthDateDisplay': _birthDateDisplayEs(birthDate),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    if (fullName.isNotEmpty) {
      await current.updateDisplayName(fullName);
    }
  }

  // ----------------------------
  // Auth: login/register/signout
  // ----------------------------

  /// LOGIN
  Future<UserCredential> signInWithEmail(String email, String password) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final u = cred.user;
    if (u != null) {
      await _upsertUserProfile(u);
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

    final u = cred.user;
    if (u != null) {
      final dn = displayName?.trim();
      if (dn != null && dn.isNotEmpty) {
        await u.updateDisplayName(dn);
      }
      await _upsertUserProfile(u, displayNameOverride: dn);
    }

    return cred;
  }

  Future<void> signOut() => _auth.signOut();
}

/// Providers base
final firebaseAuthProvider = Provider<FirebaseAuth>(
  (ref) => FirebaseAuth.instance,
);

final firestoreProvider = Provider<FirebaseFirestore>(
  (ref) => FirebaseFirestore.instance,
);

final firebaseStorageProvider = Provider<FirebaseStorage>(
  (ref) => FirebaseStorage.instance,
);

/// Provider del repo
final authRepoProvider = Provider<AuthRepo>((ref) {
  return AuthRepo(
    ref.watch(firebaseAuthProvider),
    ref.watch(firestoreProvider),
    ref.watch(firebaseStorageProvider),
  );
});

/// Usuario reactivo
final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authRepoProvider).authStateChanges();
});

/// Usuario actual (sync)
final currentUserProvider = Provider<User?>((ref) {
  return ref.watch(authRepoProvider).user;
});
