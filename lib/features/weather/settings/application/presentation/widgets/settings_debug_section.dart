import 'package:app_clima/features/auth/application/auth_providers.dart';
import 'package:app_clima/features/favorites/presentation/widgets/clear_favorites_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsDebugSection extends ConsumerWidget {
  const SettingsDebugSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).valueOrNull;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeader(icon: Icons.bug_report, title: 'Depuración'),
        if (user != null)
          Card(
            child: ListTile(
              leading: const Icon(Icons.verified_user),
              title: Text('UID: ${user.uid}'),
              subtitle: Text('Email: ${user.email ?? "(sin email)"}'),
            ),
          ),
        const SizedBox(height: 12),
        const ClearFavoritesButton(),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  const _SectionHeader({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme.onSurfaceVariant;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: c),
          const SizedBox(width: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(color: c),
          ),
        ],
      ),
    );
  }
}
