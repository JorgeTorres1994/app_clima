import 'package:app_clima/features/auth/application/auth_providers.dart';
import 'package:app_clima/features/favorites/presentation/widgets/clear_favorites_button.dart';
import 'package:app_clima/features/weather/settings/application/settings_providers.dart';
import 'package:app_clima/features/weather/settings/application/settings_state.dart';
import 'package:app_clima/l10n/app_localizations.dart';
import 'package:flutter/material.dart' hide HourFormat;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(settingsProvider);
    final c = ref.read(settingsProvider.notifier);
    final cs = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context)!; // alias corto
    final user = ref.watch(authStateProvider).valueOrNull;

    String preview() {
      final temp = s.unit == TempUnit.c ? '18°C | 64°F' : '64°F | 18°C';
      final hour = s.hourFormat == HourFormat.h24 ? '16:45' : '4:45 PM';
      final themeText = {
        AppTheme.system: t.theme_system,
        AppTheme.light: t.theme_light,
        AppTheme.dark: t.theme_dark,
      }[s.theme];
      final langText = {
        AppLanguage.es: t.lang_es,
        AppLanguage.en: t.lang_en,
      }[s.language];
      return '${t.settings_preview}: $temp • ${t.settings_hour_label}: $hour • ${t.settings_theme_label}: $themeText • ${t.settings_language_label}: $langText';
    }

    return Scaffold(
      appBar: AppBar(title: Text(t.settings_title)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Vista previa
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: cs.primaryContainer,
                    child: Icon(Icons.tune, color: cs.onPrimaryContainer),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          t.settings_preview,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          preview(),
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: cs.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Unidades
          _SectionHeader(
            icon: Icons.thermostat,
            title: t.settings_units_section,
          ),
          Card(
            child: ListTile(
              title: Text(t.settings_units_label),
              subtitle: Text(t.settings_units_sub),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              trailing: SegmentedButton<TempUnit>(
                segments: [
                  ButtonSegment(value: TempUnit.c, label: Text('°C')),
                  ButtonSegment(value: TempUnit.f, label: Text('°F')),
                ],
                selected: {s.unit},
                onSelectionChanged: (v) => c.setUnit(v.first),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Formato de hora
          _SectionHeader(
            icon: Icons.access_time,
            title: t.settings_hour_section,
          ),
          Card(
            child: ListTile(
              title: Text(t.settings_hour_label),
              subtitle: Text(t.settings_hour_sub),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              trailing: SegmentedButton<HourFormat>(
                segments: [
                  ButtonSegment(
                    value: HourFormat.h12,
                    label: const Text('12h'),
                  ),
                  ButtonSegment(
                    value: HourFormat.h24,
                    label: const Text('24h'),
                  ),
                ],
                selected: {s.hourFormat},
                onSelectionChanged: (v) => c.setHourFormat(v.first),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Tema
          _SectionHeader(
            icon: Icons.palette_outlined,
            title: t.settings_appearance_section,
          ),
          Card(
            child: ListTile(
              title: Text(t.settings_theme_label),
              subtitle: Text(t.settings_theme_sub),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              trailing: DropdownButton<AppTheme>(
                value: s.theme,
                onChanged: (v) => c.setTheme(v ?? AppTheme.system),
                items: [
                  DropdownMenuItem(
                    value: AppTheme.system,
                    child: Text(t.theme_system),
                  ),
                  DropdownMenuItem(
                    value: AppTheme.light,
                    child: Text(t.theme_light),
                  ),
                  DropdownMenuItem(
                    value: AppTheme.dark,
                    child: Text(t.theme_dark),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Idioma
          _SectionHeader(
            icon: Icons.language,
            title: t.settings_language_section,
          ),
          Card(
            child: ListTile(
              title: Text(t.settings_language_label),
              subtitle: Text(t.settings_language_sub),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              trailing: DropdownButton<AppLanguage>(
                value: s.language,
                onChanged: (v) => c.setLanguage(v ?? AppLanguage.es),
                items: [
                  DropdownMenuItem(
                    value: AppLanguage.es,
                    child: Text(t.lang_es),
                  ),
                  DropdownMenuItem(
                    value: AppLanguage.en,
                    child: Text(t.lang_en),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Nota
          /*Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              'Los cambios se guardan automáticamente.',
              style: TextStyle(color: cs.onSurfaceVariant),
            ),
          ),*/
          // Nota
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              'Los cambios se guardan automáticamente.',
              style: TextStyle(color: cs.onSurfaceVariant),
            ),
          ),

          const SizedBox(height: 12),

          // 👇 Banner de depuración de cuenta (muestra UID y email)
          const DebugAccountBanner(),
          const SizedBox(height: 12),
          const ClearFavoritesButton(),

          const SizedBox(height: 16),
          _SectionHeader(icon: Icons.person, title: 'Cuenta'),
          if (user == null)
            Card(
              child: ListTile(
                leading: const Icon(Icons.person_outline),
                title: const Text('Sesión no iniciada'),
                subtitle: const Text(
                  'Inicia sesión para guardar favoritos en la nube',
                ),
                trailing: FilledButton(
                  onPressed: () => context.push('/login'),
                  child: const Text('Iniciar sesión'),
                ),
              ),
            )
          else
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.person),
                      title: Text(user.email ?? '(sin email)'),
                      subtitle: const Text('Sesión iniciada'),
                    ),
                    const SizedBox(height: 8),
                    // Botón Cerrar sesión
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.errorContainer,
                          foregroundColor: Theme.of(
                            context,
                          ).colorScheme.onErrorContainer,
                        ),
                        onPressed: () async {
                          final ok = await showDialog<bool>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('Cerrar sesión'),
                              content: const Text(
                                '¿Seguro que deseas cerrar sesión?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx, false),
                                  child: const Text('Cancelar'),
                                ),
                                FilledButton(
                                  onPressed: () => Navigator.pop(ctx, true),
                                  child: const Text('Cerrar sesión'),
                                ),
                              ],
                            ),
                          );
                          if (ok == true) {
                            await ref.read(authRepoProvider).signOut();
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Sesión cerrada')),
                              );
                              // El guard del router te llevará a /login automáticamente,
                              // pero por si acaso:
                              context.go('/login');
                            }
                          }
                        },
                        child: const Text('Cerrar sesión'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
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

class DebugAccountBanner extends ConsumerWidget {
  const DebugAccountBanner({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).valueOrNull;
    if (user == null) return const SizedBox.shrink();
    return Card(
      margin: const EdgeInsets.only(top: 12),
      child: ListTile(
        leading: const Icon(Icons.verified_user),
        title: Text('UID: ${user.uid}'),
        subtitle: Text('Email: ${user.email ?? "(sin email)"}'),
      ),
    );
  }
}
