import 'dart:async';

import 'package:app_clima/features/auth/application/auth_providers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserProfile {
  final String uid;
  final String email;
  final String firstName;
  final String lastName;
  final String displayName;

  /// ✅ Nuevo (sin hora)
  final String birthDateYmd; // "1994-09-05"
  final String birthDateDisplay; // "5 de septiembre de 1994"

  /// ✅ Derivado para usar en DatePicker/UI (opcional)
  final DateTime? birthDate;

  final String? photoUrl;

  const UserProfile({
    required this.uid,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.displayName,
    required this.birthDateYmd,
    required this.birthDateDisplay,
    required this.birthDate,
    required this.photoUrl,
  });

  String get fullName {
    final n = ('${firstName.trim()} ${lastName.trim()}').trim();
    if (n.isNotEmpty) return n;
    return displayName.trim().isNotEmpty ? displayName.trim() : 'Sin nombre';
  }

  /// ✅ Parser central (usa birthDateYmd y fallback al Timestamp viejo)
  static DateTime? parseBirthDate(Map<String, dynamic> data) {
    final ymd = data['birthDateYmd'];
    if (ymd is String && ymd.contains('-')) {
      final parts = ymd.split('-');
      if (parts.length == 3) {
        final y = int.tryParse(parts[0]);
        final m = int.tryParse(parts[1]);
        final d = int.tryParse(parts[2]);
        if (y != null && m != null && d != null) return DateTime(y, m, d);
      }
    }

    final ts = data['birthDate'];
    if (ts is Timestamp) {
      final dt = ts.toDate().toLocal();
      return DateTime(dt.year, dt.month, dt.day);
    }

    return null;
  }

  factory UserProfile.fromDoc(
    String uid,
    Map<String, dynamic> data, {
    required String emailFallback,
    required String displayNameFallback,
  }) {
    final birth = parseBirthDate(data);

    final ymd = (data['birthDateYmd'] as String?)?.trim() ?? '';
    final display = (data['birthDateDisplay'] as String?)?.trim() ?? '';

    return UserProfile(
      uid: uid,
      email: (data['email'] as String?)?.trim().isNotEmpty == true
          ? (data['email'] as String).trim()
          : emailFallback,
      firstName: (data['firstName'] as String?) ?? '',
      lastName: (data['lastName'] as String?) ?? '',
      displayName: (data['displayName'] as String?) ?? displayNameFallback,
      birthDateYmd: ymd,
      birthDateDisplay: display,
      birthDate: birth,
      photoUrl: (data['photoUrl'] as String?)?.trim(),
    );
  }

  factory UserProfile.fromAuth(User user) => UserProfile(
    uid: user.uid,
    email: user.email ?? '',
    firstName: '',
    lastName: '',
    displayName: user.displayName ?? '',
    birthDateYmd: '',
    birthDateDisplay: '',
    birthDate: null,
    photoUrl: user.photoURL,
  );
}

/// Stream del doc users/{uid}
final userProfileProvider = StreamProvider<UserProfile?>((ref) {
  final authUser = ref.watch(authStateProvider).valueOrNull;
  final db = ref.watch(firestoreProvider);

  if (authUser == null) {
    return Stream<UserProfile?>.value(null);
  }

  final docRef = db.collection('users').doc(authUser.uid);

  return docRef.snapshots().map((snap) {
    if (!snap.exists || snap.data() == null) {
      return UserProfile.fromAuth(authUser);
    }
    return UserProfile.fromDoc(
      authUser.uid,
      snap.data()!,
      emailFallback: authUser.email ?? '',
      displayNameFallback: authUser.displayName ?? '',
    );
  });
});
