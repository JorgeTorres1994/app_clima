import 'package:app_clima/l10n/app_localizations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/profile_action_button.dart';
import '../widgets/settings_preview_card.dart';
import '../widgets/settings_units_tile.dart';
import '../widgets/settings_hour_tile.dart';
import '../widgets/settings_theme_tile.dart';
import '../widgets/settings_language_tile.dart';
import '../widgets/settings_account_section.dart';
import '../widgets/settings_debug_section.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.settings_title),
        actions: const [
          ProfileActionButton(), // ✅ perfil arriba derecha
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SettingsPreviewCard(),
          const SizedBox(height: 16),

          const SettingsUnitsTile(),
          const SizedBox(height: 16),

          const SettingsHourTile(),
          const SizedBox(height: 16),

          const SettingsThemeTile(),
          const SizedBox(height: 16),

          const SettingsLanguageTile(),
          const SizedBox(height: 16),

          const SettingsAccountSection(),

          if (kDebugMode) ...[
            const SizedBox(height: 16),
            const SettingsDebugSection(),
          ],
        ],
      ),
    );
  }
}
