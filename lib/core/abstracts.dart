part of 'main.dart';

abstract class _Abstracts extends UnitCore {
  @override
  late final Data data = Data(state: state);

  @override
  late final Preference preference = Preference(data);

  @override
  late final Authenticate authenticate = Authenticate(data);

  @override
  late final Analytics analytics = Analytics();

  @override
  late final RouteDelegates routeDelegate = RouteDelegates();

  @override
  late final Store store = Store(data);

  @override
  late final SQLite sql = SQLite(data);

  @override
  late final Speech speech = Speech();

  @override
  late final Audio audio = Audio(data);

  /// Individual: Store, SQLite, Speech, Audio, Poll, ISO
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
