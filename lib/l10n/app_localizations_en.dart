// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Peru Weather';

  @override
  String get home_title => 'Weather Peru';

  @override
  String get home_updated_short => 'Upd.';

  @override
  String get home_wind => 'Wind';

  @override
  String get home_humidity => 'Humidity';

  @override
  String get home_next_days => 'Next days';

  @override
  String get search_title => 'Search city (Peru)';

  @override
  String get search_hint => 'e.g. Lima, Cusco, Piura…';

  @override
  String get search_empty_title => 'No results';

  @override
  String get search_empty_sub => 'Try another city or check suggestions.';

  @override
  String get settings_title => 'Settings';

  @override
  String get settings_preview => 'Preview';

  @override
  String get settings_units_section => 'Units';

  @override
  String get settings_units_label => 'Temperature (°C / °F)';

  @override
  String get settings_units_sub => 'Both are shown; choose your preferred one';

  @override
  String get settings_hour_section => 'Hour format';

  @override
  String get settings_hour_label => 'Format';

  @override
  String get settings_hour_sub => 'Affects how hours are displayed in the app';

  @override
  String get settings_appearance_section => 'Appearance';

  @override
  String get settings_theme_label => 'Theme';

  @override
  String get settings_theme_sub => 'Material 3 with seed color';

  @override
  String get settings_language_section => 'Language';

  @override
  String get settings_language_label => 'Interface language';

  @override
  String get settings_language_sub => 'Saved immediately (apply i18n across app)';

  @override
  String get theme_system => 'System';

  @override
  String get theme_light => 'Light';

  @override
  String get theme_dark => 'Dark';

  @override
  String get lang_es => 'Spanish';

  @override
  String get lang_en => 'English';
}
