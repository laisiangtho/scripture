part of data.core;

class Preference extends ClusterController {
  Preference(Collection docket) : super(docket);

  /// `AppLocalizations.of(context)!`;
  AppLocalizations get text => AppLocalizations.of(context)!;

  List<Locale> get supportedLocales => AppLocalizations.supportedLocales;

  late final Iterable<LocalizationsDelegate<dynamic>> localeDelegates = const [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  /// English, Norwegian, Myanmar
  late final Iterable<Locale> localeSupports = const [
    Locale('en', 'GB'),
    Locale('no', 'NO'),
    Locale('my', '')
  ];
}
