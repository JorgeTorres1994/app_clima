import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Peru Weather'**
  String get appTitle;

  /// No description provided for @home_title.
  ///
  /// In en, this message translates to:
  /// **'Weather Peru'**
  String get home_title;

  /// No description provided for @home_updated_short.
  ///
  /// In en, this message translates to:
  /// **'Upd.'**
  String get home_updated_short;

  /// No description provided for @home_wind.
  ///
  /// In en, this message translates to:
  /// **'Wind'**
  String get home_wind;

  /// No description provided for @home_humidity.
  ///
  /// In en, this message translates to:
  /// **'Humidity'**
  String get home_humidity;

  /// No description provided for @home_next_days.
  ///
  /// In en, this message translates to:
  /// **'Next days'**
  String get home_next_days;

  /// No description provided for @search_title.
  ///
  /// In en, this message translates to:
  /// **'Search city (Peru)'**
  String get search_title;

  /// No description provided for @search_hint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Lima, Cusco, Piura…'**
  String get search_hint;

  /// No description provided for @search_empty_title.
  ///
  /// In en, this message translates to:
  /// **'No results'**
  String get search_empty_title;

  /// No description provided for @search_empty_sub.
  ///
  /// In en, this message translates to:
  /// **'Try another city or check suggestions.'**
  String get search_empty_sub;

  /// No description provided for @settings_title.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings_title;

  /// No description provided for @settings_preview.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get settings_preview;

  /// No description provided for @settings_units_section.
  ///
  /// In en, this message translates to:
  /// **'Units'**
  String get settings_units_section;

  /// No description provided for @settings_units_label.
  ///
  /// In en, this message translates to:
  /// **'Temperature (°C / °F)'**
  String get settings_units_label;

  /// No description provided for @settings_units_sub.
  ///
  /// In en, this message translates to:
  /// **'Both are shown; choose your preferred one'**
  String get settings_units_sub;

  /// No description provided for @settings_hour_section.
  ///
  /// In en, this message translates to:
  /// **'Hour format'**
  String get settings_hour_section;

  /// No description provided for @settings_hour_label.
  ///
  /// In en, this message translates to:
  /// **'Format'**
  String get settings_hour_label;

  /// No description provided for @settings_hour_sub.
  ///
  /// In en, this message translates to:
  /// **'Affects how hours are displayed in the app'**
  String get settings_hour_sub;

  /// No description provided for @settings_appearance_section.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settings_appearance_section;

  /// No description provided for @settings_theme_label.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settings_theme_label;

  /// No description provided for @settings_theme_sub.
  ///
  /// In en, this message translates to:
  /// **'Material 3 with seed color'**
  String get settings_theme_sub;

  /// No description provided for @settings_language_section.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settings_language_section;

  /// No description provided for @settings_language_label.
  ///
  /// In en, this message translates to:
  /// **'Interface language'**
  String get settings_language_label;

  /// No description provided for @settings_language_sub.
  ///
  /// In en, this message translates to:
  /// **'Saved immediately (apply i18n across app)'**
  String get settings_language_sub;

  /// No description provided for @theme_system.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get theme_system;

  /// No description provided for @theme_light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get theme_light;

  /// No description provided for @theme_dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get theme_dark;

  /// No description provided for @lang_es.
  ///
  /// In en, this message translates to:
  /// **'Spanish'**
  String get lang_es;

  /// No description provided for @lang_en.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get lang_en;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
