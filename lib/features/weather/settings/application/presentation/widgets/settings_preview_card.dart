import 'package:app_clima/features/weather/settings/application/settings_providers.dart';
import 'package:app_clima/features/weather/settings/application/settings_state.dart';
import 'package:app_clima/l10n/app_localizations.dart';
import 'package:flutter/material.dart' hide HourFormat;
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsPreviewCard extends ConsumerWidget {
  const SettingsPreviewCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(settingsProvider);
    final t = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;

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

    return Card(
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
                  Text(t.settings_preview,
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(
                    '${t.settings_preview}: $temp • '
                    '${t.settings_hour_label}: $hour • '
                    '${t.settings_theme_label}: $themeText • '
                    '${t.settings_language_label}: $langText',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: cs.onSurfaceVariant),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
