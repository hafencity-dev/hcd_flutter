import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Callback function type for locale changes.
typedef LocaleChangeCallback = void Function(Locale locale);

/// Function type for loading translations.
typedef TranslationsLoader = Future<Map<String, dynamic>> Function(
    Locale locale);

/// Function type for persisting the selected locale.
typedef LocalePersister = Future<void> Function(String languageCode);

/// Function type for retrieving the stored locale.
typedef LocaleRetriever = Future<String?> Function();

/// A class that handles localization for the application.
///
/// This class manages the loading and retrieval of localized strings,
/// and provides methods for translating keys into the current locale.
///
/// # Simple Example
///
/// Here's a basic setup for using AppLocalizations with language switching:
///
/// ```dart
/// import 'package:flutter/material.dart';
/// import 'package:your_package_name/app_localizations.dart';
///
/// void main() {
///   runApp(MyApp());
/// }
///
/// class MyApp extends StatefulWidget {
///   @override
///   _MyAppState createState() => _MyAppState();
/// }
///
/// class _MyAppState extends State<MyApp> {
///   Locale _locale = Locale('en');
///   late AppLocalizationsDelegate _localizationsDelegate;
///
///   @override
///   void initState() {
///     super.initState();
///     _localizationsDelegate = AppLocalizations.delegate(
///       supportedLocales: [Locale('en'), Locale('es')],
///     );
///   }
///
///   void _changeLanguage(Locale newLocale) {
///     setState(() {
///       _locale = newLocale;
///     });
///   }
///
///   @override
///   Widget build(BuildContext context) {
///     return MaterialApp(
///       locale: _locale,
///       localizationsDelegates: [
///         _localizationsDelegate,
///         GlobalMaterialLocalizations.delegate,
///         GlobalWidgetsLocalizations.delegate,
///       ],
///       supportedLocales: _localizationsDelegate.supportedLocales,
///       home: MyHomePage(changeLanguage: _changeLanguage),
///     );
///   }
/// }
///
/// class MyHomePage extends StatelessWidget {
///   final Function(Locale) changeLanguage;
///
///   MyHomePage({required this.changeLanguage});
///
///   @override
///   Widget build(BuildContext context) {
///     final localizations = AppLocalizations.of(context);
///     return Scaffold(
///       appBar: AppBar(
///         title: Text(localizations.translate('app_title')),
///       ),
///       body: Center(
///         child: Column(
///           mainAxisAlignment: MainAxisAlignment.center,
///           children: [
///             Text(localizations.translate('hello_world')),
///             SizedBox(height: 20),
///             ElevatedButton(
///               onPressed: () => changeLanguage(Locale('en')),
///               child: Text('English'),
///             ),
///             ElevatedButton(
///               onPressed: () => changeLanguage(Locale('es')),
///               child: Text('Español'),
///             ),
///           ],
///         ),
///       ),
///     );
///   }
/// }
/// ```
///
/// # Complex Example
///
/// For more advanced usage, including custom loaders, locale persistence, and language switching:
///
/// ```dart
/// import 'package:flutter/material.dart';
/// import 'package:your_package_name/app_localizations.dart';
/// import 'package:shared_preferences/shared_preferences.dart';
///
/// void main() {
///   runApp(MyApp());
/// }
///
/// class MyApp extends StatefulWidget {
///   @override
///   _MyAppState createState() => _MyAppState();
/// }
///
/// class _MyAppState extends State<MyApp> {
///   Locale _locale = Locale('en');
///   late AppLocalizationsDelegate _localizationsDelegate;
///
///   @override
///   void initState() {
///     super.initState();
///     _initializeLocalizations();
///   }
///
///   Future<void> _initializeLocalizations() async {
///     _localizationsDelegate = AppLocalizations.delegate(
///       supportedLocales: [Locale('en'), Locale('es'), Locale('fr')],
///       customLoader: (locale) async {
///         // Load translations from a remote API
///         final response = await fetchTranslations(locale.languageCode);
///         return response.data;
///       },
///       localePersister: (languageCode) async {
///         final prefs = await SharedPreferences.getInstance();
///         await prefs.setString('language', languageCode);
///       },
///       localeRetriever: () async {
///         final prefs = await SharedPreferences.getInstance();
///         return prefs.getString('language');
///       },
///     );
///
///     final storedLocale = await _localizationsDelegate.getStoredLocale();
///     if (storedLocale != null) {
///       setState(() {
///         _locale = storedLocale;
///       });
///     }
///   }
///
///   Future<void> _changeLocale(Locale newLocale) async {
///     await _localizationsDelegate.setLocale(newLocale);
///     setState(() {
///       _locale = newLocale;
///     });
///   }
///
///   @override
///   Widget build(BuildContext context) {
///     return MaterialApp(
///       locale: _locale,
///       localizationsDelegates: [
///         _localizationsDelegate,
///         GlobalMaterialLocalizations.delegate,
///         GlobalWidgetsLocalizations.delegate,
///         GlobalCupertinoLocalizations.delegate,
///       ],
///       supportedLocales: _localizationsDelegate.supportedLocales,
///       home: MyHomePage(onLocaleChange: _changeLocale),
///     );
///   }
/// }
///
/// class MyHomePage extends StatelessWidget {
///   final Function(Locale) onLocaleChange;
///
///   MyHomePage({required this.onLocaleChange});
///
///   @override
///   Widget build(BuildContext context) {
///     final localizations = AppLocalizations.of(context);
///     return Scaffold(
///       appBar: AppBar(
///         title: Text(localizations.translate('app_title')),
///       ),
///       body: Center(
///         child: Column(
///           mainAxisAlignment: MainAxisAlignment.center,
///           children: [
///             Text(localizations.translate('welcome_message')),
///             Text(localizations.plural('item_count', 3)),
///             SizedBox(height: 20),
///             DropdownButton<String>(
///               value: Localizations.localeOf(context).languageCode,
///               items: [
///                 DropdownMenuItem(value: 'en', child: Text('English')),
///                 DropdownMenuItem(value: 'es', child: Text('Español')),
///                 DropdownMenuItem(value: 'fr', child: Text('Français')),
///               ],
///               onChanged: (String? languageCode) {
///                 if (languageCode != null) {
///                   onLocaleChange(Locale(languageCode));
///                 }
///               },
///             ),
///           ],
///         ),
///       ),
///     );
///   }
/// }
/// ```
///
/// This complex example demonstrates:
/// - Custom translation loading from a remote API
/// - Locale persistence using SharedPreferences
/// - Dynamic locale changing with a dropdown menu
/// - Usage of plural translations
///
/// Remember to add necessary dependencies like `shared_preferences` to your
/// `pubspec.yaml` file when using the complex example.

class AppLocalizations {
  /// The current locale for the app.
  final Locale locale;

  /// A map containing the localized strings.
  late Map<String, dynamic> _localizedStrings;

  /// Creates a new instance of [AppLocalizations].
  ///
  /// The [locale] parameter specifies the locale for this instance.
  AppLocalizations(this.locale);

  /// Returns the instance of [AppLocalizations] for the given context.
  ///
  /// This method should be used to access translations throughout the app.
  ///
  /// Example:
  /// ```dart
  /// final localizations = AppLocalizations.of(context);
  /// print(localizations.translate('greeting'));
  /// ```
  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  /// Creates a new [AppLocalizationsDelegate] with the specified parameters.
  ///
  /// This method is used to create a delegate for the [AppLocalizations] class,
  /// which can be used in the [MaterialApp] widget.
  ///
  /// Parameters:
  /// - [supportedLocales]: A list of locales supported by the app.
  /// - [customLoader]: An optional function to load translations from a custom source.
  /// - [localePersister]: An optional function to persist the selected locale.
  /// - [localeRetriever]: An optional function to retrieve the stored locale.
  static AppLocalizationsDelegate delegate({
    required List<Locale> supportedLocales,
    TranslationsLoader? customLoader,
    LocalePersister? localePersister,
    LocaleRetriever? localeRetriever,
  }) {
    return AppLocalizationsDelegate(
      supportedLocales: supportedLocales,
      customLoader: customLoader,
      localePersister: localePersister,
      localeRetriever: localeRetriever,
    );
  }

  /// Loads the localized strings for the current locale.
  ///
  /// If [customLoader] is provided, it will be used to load the translations.
  /// Otherwise, the translations will be loaded from a JSON file in the assets.
  ///
  /// Returns `true` if the loading was successful.
  Future<bool> load({TranslationsLoader? customLoader}) async {
    if (customLoader != null) {
      _localizedStrings = await customLoader(locale);
    } else {
      final jsonString = await rootBundle
          .loadString('assets/lang/${locale.languageCode}.json');
      _localizedStrings = json.decode(jsonString);
    }
    return true;
  }

  /// Translates a given [key] into the current locale.
  ///
  /// Supports nested keys using dot notation (e.g., 'menu.file.open').
  /// If [args] is provided, it will be used for string interpolation.
  ///
  /// Returns the translated string, or the original [key] if not found.
  String translate(String key, {Map<String, dynamic>? args}) {
    final parts = key.split('.');
    dynamic translation = _localizedStrings;
    for (final part in parts) {
      if (translation is! Map) return key;
      translation = translation[part];
    }
    if (translation == null) return key;
    return _interpolate(translation.toString(), args);
  }

  /// Handles plural translations for a given [key] and [count].
  ///
  /// Attempts to find a specific plural form (e.g., 'key_1' for count == 1).
  /// Falls back to the base key if no specific form is found.
  ///
  /// Parameters:
  /// - [key]: The base key for the plural string.
  /// - [count]: The quantity to determine which plural form to use.
  /// - [args]: Optional arguments for string interpolation.
  String plural(String key, int count, {Map<String, dynamic>? args}) {
    final pluralKey = '${key}_$count';
    if (_localizedStrings.containsKey(pluralKey)) {
      return translate(pluralKey, args: args);
    }
    return translate(key, args: {...?args, 'count': count});
  }

  /// Interpolates values into a translated string.
  ///
  /// Replaces placeholders in the format {key} with corresponding values from [args].
  String _interpolate(String message, Map<String, dynamic>? args) {
    if (args == null) return message;
    return message.replaceAllMapped(RegExp(r'\{(\w+)\}'), (match) {
      final key = match.group(1)!;
      return args[key]?.toString() ?? match.group(0)!;
    });
  }
}

/// A delegate class for [AppLocalizations] that handles locale loading and changes.
class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  /// The list of supported locales for the app.
  final List<Locale> supportedLocales;

  /// An optional function to load translations from a custom source.
  final TranslationsLoader? customLoader;

  /// An optional function to persist the selected locale.
  final LocalePersister? localePersister;

  /// An optional function to retrieve the stored locale.
  final LocaleRetriever? localeRetriever;

  /// Creates a new instance of [AppLocalizationsDelegate].
  const AppLocalizationsDelegate({
    required this.supportedLocales,
    this.customLoader,
    this.localePersister,
    this.localeRetriever,
  });

  /// Checks if the given [locale] is supported by the app.
  @override
  bool isSupported(Locale locale) => supportedLocales.contains(locale);

  /// Loads the localized strings for the given [locale].
  @override
  Future<AppLocalizations> load(Locale locale) async {
    final localizations = AppLocalizations(locale);
    await localizations.load(customLoader: customLoader);
    return localizations;
  }

  /// Determines whether the delegate should be reloaded.
  ///
  /// Always returns false in this implementation.
  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;

  /// Persists the selected [locale] using the provided [localePersister].
  Future<void> setLocale(Locale locale) async {
    if (localePersister != null) {
      await localePersister!(locale.languageCode);
    }
  }

  /// Retrieves the stored locale using the provided [localeRetriever].
  ///
  /// Returns null if no locale is stored or if [localeRetriever] is not provided.
  Future<Locale?> getStoredLocale() async {
    if (localeRetriever != null) {
      final languageCode = await localeRetriever!();
      if (languageCode != null) {
        return Locale(languageCode);
      }
    }
    return null;
  }
}
