part of 'main.dart';

class Preference extends PreferenceNest {
  // Preference(Collection docket) : super(docket);
  Preference(super.data);

  @override
  AppLocalizations get text => AppLocalizations.of(context)!;

  // @override
  // List<Locale> get supportedLocales => AppLocalizations.supportedLocales;

  late final Iterable<LocalizationsDelegate<dynamic>> localeDelegates = const [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  /// English, Norwegian, Myanmar
  // @override
  // Iterable<Locale> get listOfLocale => const [
  //       Locale('en', 'GB'),
  //       Locale('no', 'NO'),
  //       Locale('my', ''),
  //     ];
}
