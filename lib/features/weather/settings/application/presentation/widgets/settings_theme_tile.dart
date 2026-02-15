import 'package:app_clima/features/weather/settings/application/settings_providers.dart';
import 'package:app_clima/features/weather/settings/application/settings_state.dart';
import 'package:app_clima/l10n/app_localizations.dart';
import 'package:flutter/material.dart' hide HourFormat;
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsThemeTile extends ConsumerWidget {
  const SettingsThemeTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(settingsProvider);
    final c = ref.read(settingsProvider.notifier);
    final t = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(icon: Icons.palette_outlined, title: t.settings_appearance_section),
        Card(
          child: ListTile(
            title: Text(t.settings_theme_label),
            subtitle: Text(t.settings_theme_sub),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            trailing: DropdownButton<AppTheme>(
              value: s.theme,
              onChanged: (v) => c.setTheme(v ?? AppTheme.system),
              items: [
                DropdownMenuItem(value: AppTheme.system, child: Text(t.theme_system)),
                DropdownMenuItem(value: AppTheme.light, child: Text(t.theme_light)),
                DropdownMenuItem(value: AppTheme.dark, child: Text(t.theme_dark)),
              ],
            ),
          ),
        ),
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
