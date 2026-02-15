import 'package:app_clima/features/weather/settings/application/settings_providers.dart';
import 'package:app_clima/features/weather/settings/application/settings_state.dart';
import 'package:app_clima/l10n/app_localizations.dart';
import 'package:flutter/material.dart' hide HourFormat;
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsHourTile extends ConsumerWidget {
  const SettingsHourTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(settingsProvider);
    final c = ref.read(settingsProvider.notifier);
    final t = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(icon: Icons.access_time, title: t.settings_hour_section),
        Card(
          child: ListTile(
            title: Text(t.settings_hour_label),
            subtitle: Text(t.settings_hour_sub),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            trailing: SegmentedButton<HourFormat>(
              segments: const [
                ButtonSegment(value: HourFormat.h12, label: Text('12h')),
                ButtonSegment(value: HourFormat.h24, label: Text('24h')),
              ],
              selected: {s.hourFormat},
              onSelectionChanged: (v) => c.setHourFormat(v.first),
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
