import 'package:app_clima/features/auth/application/auth_providers.dart';
import 'package:app_clima/features/auth/application/user_profile_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProfileActionButton extends ConsumerWidget {
  const ProfileActionButton({super.key});

  String _initialsFrom(String fullName) {
    final name = fullName.trim();
    if (name.isEmpty) return 'U';

    final parts = name
        .split(RegExp(r'\s+'))
        .where((e) => e.isNotEmpty)
        .toList();
    return parts.take(2).map((e) => e.characters.first.toUpperCase()).join();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final user = ref.watch(authStateProvider).valueOrNull;

    // ✅ Sin sesión: ícono que lleva a login
    if (user == null) {
      return IconButton(
        tooltip: 'Iniciar sesión',
        icon: const Icon(Icons.person_outline),
        onPressed: () => context.push('/login'),
      );
    }

    final profileAsync = ref.watch(userProfileProvider);

    Widget buildAvatar({
      required String? photoUrl,
      required String initials,
      required VoidCallback onTap,
      bool showLoading = false,
    }) {
      return Padding(
        padding: const EdgeInsets.only(right: 10),
        child: InkWell(
          borderRadius: BorderRadius.circular(999),
          onTap: onTap,
          child: SizedBox(
            width: 52, // ✅ Tamaño real en AppBar
            height: 52,
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircleAvatar(
                    radius: 22, // ✅ 44px diámetro
                    backgroundColor: cs.surfaceContainerHighest,
                    foregroundColor: cs.onSurface,
                    backgroundImage: (photoUrl != null && photoUrl.isNotEmpty)
                        ? NetworkImage(photoUrl)
                        : null,
                    child: (photoUrl == null || photoUrl.isEmpty)
                        ? Text(
                            initials,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          )
                        : null,
                  ),
                  if (showLoading)
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return profileAsync.when(
      loading: () => buildAvatar(
        photoUrl: user.photoURL,
        initials: _initialsFrom(user.displayName ?? ''),
        onTap: () => context.push('/profile'),
        showLoading: true,
      ),
      error: (_, __) => buildAvatar(
        photoUrl: user.photoURL,
        initials: _initialsFrom(user.displayName ?? ''),
        onTap: () => context.push('/profile'),
      ),
      data: (p) {
        final profile = p ?? UserProfile.fromAuth(user);

        final photo = (profile.photoUrl?.isNotEmpty == true)
            ? profile.photoUrl
            : user.photoURL;

        final initials = _initialsFrom(profile.fullName);

        return buildAvatar(
          photoUrl: photo,
          initials: initials,
          onTap: () => context.push('/profile'),
        );
      },
    );
  }
}
