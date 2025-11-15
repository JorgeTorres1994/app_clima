// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Clima Perú';

  @override
  String get home_title => 'Clima Perú';

  @override
  String get home_updated_short => 'Act.';

  @override
  String get home_wind => 'Viento';

  @override
  String get home_humidity => 'Humedad';

  @override
  String get home_next_days => 'Próximos días';

  @override
  String get search_title => 'Buscar ciudad (Perú)';

  @override
  String get search_hint => 'Ej. Lima, Cusco, Piura…';

  @override
  String get search_empty_title => 'Sin resultados';

  @override
  String get search_empty_sub => 'Prueba con otra ciudad o revisa las sugerencias.';

  @override
  String get settings_title => 'Ajustes';

  @override
  String get settings_preview => 'Vista previa';

  @override
  String get settings_units_section => 'Unidades';

  @override
  String get settings_units_label => 'Temperatura (°C / °F)';

  @override
  String get settings_units_sub => 'Se muestran ambas; selecciona la preferida';

  @override
  String get settings_hour_section => 'Formato de hora';

  @override
  String get settings_hour_label => 'Formato';

  @override
  String get settings_hour_sub => 'Afecta cómo se muestran horas en la app';

  @override
  String get settings_appearance_section => 'Apariencia';

  @override
  String get settings_theme_label => 'Tema';

  @override
  String get settings_theme_sub => 'Material 3 con color semilla';

  @override
  String get settings_language_section => 'Idioma';

  @override
  String get settings_language_label => 'Idioma de la interfaz';

  @override
  String get settings_language_sub => 'Guardado inmediato (aplicar i18n en toda la app)';

  @override
  String get theme_system => 'Sistema';

  @override
  String get theme_light => 'Claro';

  @override
  String get theme_dark => 'Oscuro';

  @override
  String get lang_es => 'Español';

  @override
  String get lang_en => 'English';
}
