// lib/app/app.dart
import 'package:app_clima/features/weather/settings/application/settings_providers.dart';
import 'package:app_clima/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


import 'router.dart';

class WeatherApp extends ConsumerWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode   = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);

    final ThemeData lightTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorSchemeSeed: const Color(0xFF0EA5E9),
    );
    final ThemeData darkTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorSchemeSeed: const Color(0xFF0EA5E9),
    );

    final router = createRouter();

    return MaterialApp.router(
      // Título según idioma
      onGenerateTitle: (ctx) => AppLocalizations.of(ctx)!.appTitle,

      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: mode,

      // 🌎 i18n
      locale: locale, // cambia en vivo con Ajustes
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
