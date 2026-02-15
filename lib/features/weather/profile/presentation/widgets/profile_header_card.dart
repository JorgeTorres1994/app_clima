import 'dart:typed_data';

import 'package:app_clima/features/auth/application/user_profile_providers.dart';
import 'package:flutter/material.dart';

class ProfileHeaderCard extends StatelessWidget {
  final UserProfile profile;
  final String? authFallbackPhotoUrl;
  final Uint8List? pendingPhotoBytes;
  final VoidCallback onChangePhoto;

  const ProfileHeaderCard({
    super.key,
    required this.profile,
    required this.authFallbackPhotoUrl,
    required this.pendingPhotoBytes,
    required this.onChangePhoto,
  });

  String _fmtDate(DateTime? d) {
    if (d == null) return '—';
    final dd = d.day.toString().padLeft(2, '0');
    final mm = d.month.toString().padLeft(2, '0');
    return '$dd/$mm/${d.year}';
  }

  String _birthdayText() {
    final s = profile.birthDateDisplay.trim();
    if (s.isNotEmpty) return s;
    return _fmtDate(profile.birthDate); // fallback por si viniera solo DateTime
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    ImageProvider? avatarProvider;

    // ✅ Preview local (sin guardar)
    if (pendingPhotoBytes != null && pendingPhotoBytes!.isNotEmpty) {
      avatarProvider = MemoryImage(pendingPhotoBytes!);
    } else {
      final photo = (profile.photoUrl?.isNotEmpty == true)
          ? profile.photoUrl
          : authFallbackPhotoUrl;

      if (photo != null && photo.isNotEmpty) {
        avatarProvider = NetworkImage(photo);
      }
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: cs.surfaceContainerHighest,
              backgroundImage: avatarProvider,
              child: avatarProvider == null
                  ? Icon(Icons.person, color: cs.onSurfaceVariant)
                  : null,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    profile.fullName.isEmpty
                        ? 'Completa tu perfil'
                        : profile.fullName,
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    profile.email,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.cake_outlined,
                        size: 18,
                        color: cs.onSurfaceVariant,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Cumpleaños: ${_birthdayText()}',
                          maxLines: 2, // ✅ permite 2 líneas
                          overflow:
                              TextOverflow.fade, // ✅ más elegante que "..."
                          softWrap: true,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: cs.onSurfaceVariant),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            FilledButton.tonalIcon(
              onPressed: onChangePhoto,
              icon: const Icon(Icons.photo_camera_outlined, size: 18),
              label: const Text('Foto'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
