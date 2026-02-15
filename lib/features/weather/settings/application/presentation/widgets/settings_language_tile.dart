import 'package:app_clima/features/weather/settings/application/settings_providers.dart';
import 'package:app_clima/features/weather/settings/application/settings_state.dart';
import 'package:app_clima/l10n/app_localizations.dart';
import 'package:flutter/material.dart' hide HourFormat;
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsLanguageTile extends ConsumerWidget {
  const SettingsLanguageTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(settingsProvider);
    final c = ref.read(settingsProvider.notifier);
    final t = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(icon: Icons.language, title: t.settings_language_section),
        Card(
          child: ListTile(
            title: Text(t.settings_language_label),
            subtitle: Text(t.settings_language_sub),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            trailing: DropdownButton<AppLanguage>(
              value: s.language,
              onChanged: (v) => c.setLanguage(v ?? AppLanguage.es),
              items: [
                DropdownMenuItem(value: AppLanguage.es, child: Text(t.lang_es)),
                DropdownMenuItem(value: AppLanguage.en, child: Text(t.lang_en)),
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
