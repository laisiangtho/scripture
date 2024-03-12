part of 'main.dart';

abstract class _Abstract extends UnitCore {
  /// API
  // final Data data = Data.internal();
  late final Data data = Data(notify: notify);

  /// Scroll notifier
  late final ViewData viewData = ViewData();
  // late ScrollNotifier scrollNotifier;

  /// Route delegate
  late final RouteDelegate routeDelegate = RouteDelegate();

  /// Theme and locales
  late final Preference preference = Preference(data);

  /// Firebase Authentication
  late final Authenticate authenticate = Authenticate(data: data);

  /// Analytics
  late final Analytics analytics = Analytics();

  /// Store
  // late final store = Store(data: data);

  /// Poll
  late final poll = Poll(data: data, authenticate: authenticate);

  /// Audio
  // late final audio = Audio(data: data);

  /// Scripture
  late final scripture = Scripture(data);

  /// ensure and prepare initialization
  Future<void> ensureInitialized() async {
    Stopwatch initWatch = Stopwatch()..start();

    await data.ensureInitialized();
    await data.prepareInitialized();
    await preference.ensureInitialized();
    await authenticate.ensureInitialized();

    // if (authentication.id.isNotEmpty && authentication.id != data.setting.userId) {
    //   final ou = data.setting.copyWith(userId: authentication.id);
    //   await data.settingUpdate(ou);
    // }

    debugPrint('ensureInitialized in ${initWatch.elapsedMilliseconds} ms');
  }
}
