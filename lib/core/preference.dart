part of data.core;

class Preference extends ClusterController {
  Preference(Collection docket) : super(docket);

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
