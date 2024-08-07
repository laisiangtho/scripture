part of 'main.dart';

class Preference extends PreferenceNest<Data> {
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
  //       Locale('my', 'MM'),
  //     ];

  /// ThemeData for light using ThemeNest and ColorNest
  @override
  ThemeData? light(BuildContext context) {
    return ThemeNest.theme(
      text: Theme.of(context).textTheme.merge(
            ThemeNest.textTheme(),
          ),
      color: const ColorNest.light(),
    );
  }

  @override
  ThemeData? dark(BuildContext context) {
    return ThemeNest.theme(
      text: Theme.of(context).textTheme.merge(
            ThemeNest.textTheme(),
          ),
      color: const ColorNest.dark(),
    );
  }
}
