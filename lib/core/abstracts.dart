part of 'main.dart';

abstract class _Abstracts extends UnitCore {
  /// API
  /// ```dart
  /// final Data data = Data.internal();
  /// late final Data data = Data(state: state);
  /// ```
  late final Data data = Data(state: state);

  /// Scroll notifier, ScrollNotifier
  late final ViewData viewData = ViewData();

  /// Theme and locales
  late final Preference preference = Preference(data);

  /// Firebase Authentication
  late final Authenticate authenticate = Authenticate(data);

  /// Analytics
  late final Analytics analytics = Analytics();

  /// Individual: Store, SQLite, Speech, Audio, Poll, ISO
  late final store = Store(data);
  late final sql = SQLite(data);
  late final speech = Speech();
  late final audio = Audio(data);
  late final poll = Poll(data: data, authenticate: authenticate);
  late final iso = ISOFilter();

  @override
  Future<void> ensureInitialized() async {
    Stopwatch initWatch = Stopwatch()..start();

    await super.ensureInitialized();
    await data.ensureInitialized();
    await data.prepareInitialized();
    await preference.ensureInitialized();
    await authenticate.ensureInitialized();

    debugPrint('ensureInitialized in ${initWatch.elapsedMilliseconds} ms');
  }
}
