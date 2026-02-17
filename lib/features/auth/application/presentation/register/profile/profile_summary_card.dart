import 'package:app_clima/features/auth/application/auth_providers.dart';
import 'package:app_clima/features/auth/application/user_profile_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ProfileSummaryCard extends ConsumerWidget {
  const ProfileSummaryCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authUser = ref.watch(authStateProvider).valueOrNull;
    final cs = Theme.of(context).colorScheme;

    if (authUser == null) {
      return Card(
        child: ListTile(
          leading: const Icon(Icons.person_outline),
          title: const Text('Sesión no iniciada'),
          subtitle: const Text('Inicia sesión para sincronizar tus favoritos.'),
          trailing: FilledButton(
            onPressed: () => Navigator.of(context).pushNamed('/login'),
            child: const Text('Iniciar sesión'),
          ),
        ),
      );
    }

    final profileAsync = ref.watch(userProfileProvider);

    return profileAsync.when(
      loading: () => const _ProfileSkeleton(),
      error: (e, _) => Card(
        child: ListTile(
          leading: const Icon(Icons.error_outline),
          title: const Text('No se pudo cargar el perfil'),
          subtitle: Text('$e'),
        ),
      ),
      data: (profile) {
        final p = profile ?? UserProfile.fromAuth(authUser);

        final birthText = p.birthDate == null
            ? 'Sin cumpleaños'
            : DateFormat('dd/MM/yyyy').format(p.birthDate!);

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    radius: 22,
                    backgroundColor: cs.surfaceContainerHighest,
                    backgroundImage:
                        (p.photoUrl != null && p.photoUrl!.isNotEmpty)
                            ? NetworkImage(p.photoUrl!)
                            : null,
                    child: (p.photoUrl == null || p.photoUrl!.isEmpty)
                        ? Icon(Icons.person, color: cs.onSurfaceVariant)
                        : null,
                  ),
                  title: Text(p.fullName),
                  subtitle: Text(p.email.isEmpty ? '(sin email)' : p.email),
                  trailing: IconButton(
                    tooltip: 'Ver perfil',
                    onPressed: () {
                      // Opcional: ir a página Perfil
                      Navigator.of(context).pushNamed('/profile');
                    },
                    icon: const Icon(Icons.chevron_right),
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.cake_outlined, size: 18, color: cs.onSurfaceVariant),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        birthText,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: cs.onSurfaceVariant),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ProfileSkeleton extends StatelessWidget {
  const _ProfileSkeleton();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          radius: 22,
          child: const SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
        title: const Text('Cargando perfil...'),
        subtitle: const Text(''),
      ),
    );
  }
}
