import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

export 'package:flutter_localizations/flutter_localizations.dart';
export 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:lidea/notify.dart';

import 'service.dart';

class SettingsController extends Notify {
  SettingsController(this._service);

  final SettingsService _service;
  late ThemeMode _themeMode;

  ThemeMode get themeMode => _themeMode;

  Future<void> ensureInitialized() async {
    _themeMode = ThemeMode.values.firstWhere(
      (e) => e == ThemeMode.values.elementAt(_service.setting.mode),
      orElse: () => ThemeMode.system,
    );

    _locale = await _service.locale();

    notifyListeners();
  }

  Future<void> updateThemeMode(ThemeMode? mode) async {
    if (mode == null) return;

    // Dot not perform any work if new and old ThemeMode are identical
    if (mode == _themeMode) return;

    // Otherwise, store the new theme mode in memory
    _themeMode = mode;

    // Important! Inform listeners a change has occurred.
    notifyListeners();

    // Persist the changes to a local database or the internet using the
    await _service.updateTheme(mode);
  }

  bool get isDarkMode => themeMode == ThemeMode.dark;

  /// Returns the active [Brightness].
  Brightness get systemBrightness {
    Brightness brightness;
    switch (themeMode) {
      case ThemeMode.light:
        brightness = Brightness.light;
        break;
      case ThemeMode.dark:
        brightness = Brightness.dark;
        break;
      default:
        brightness = WidgetsBinding.instance!.window.platformBrightness;
    }
    return brightness;
  }

  /// Returns opposite of active [Brightness].
  Brightness get resolvedSystemBrightness {
    return systemBrightness == Brightness.dark ? Brightness.light : Brightness.dark;
  }

  late Locale _locale;

  Future<void> updateLocale(Locale? newLocale) async {
    if (newLocale == null) return;

    // Dot not perform any work if new and old ThemeMode are identical
    if (newLocale == _locale) return;

    // Otherwise, store the new theme mode in memory
    _locale = newLocale;

    // Important! Inform listeners a change has occurred.
    notifyListeners();
    await _service.updateLocale(newLocale);
  }

  Locale get locale => _locale;
}

class NavigatorNotifyObserver extends NavigatorObserver {
  NavigatorNotifyObserver(this._changeNotifier);

  final NavigatorNotify _changeNotifier;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    Future.microtask(() {
      _changeNotifier.push(route, previousRoute);
    });
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _changeNotifier.pop(route, previousRoute);
  }
}

class NavigatorNotify extends Notify {
  String name = '/';
  int _index = 0;

  int get index => _index;
  set index(int value) {
    if (value != _index) {
      _index = value;
      notify();
    }
  }

  //  route.settings.name
  void push(Route<dynamic> current, Route<dynamic>? previous) {
    if (current.settings.name != null) {
      name = current.settings.name!;
      debugPrint('push current ${current.settings.name}');
      notify();
    }
    if (previous != null) {
      debugPrint('push previous ${previous.settings.name}');
    }
  }

  void pop(Route<dynamic> current, Route<dynamic>? previous) {
    name = previous!.settings.name!;
    debugPrint('pop current ${current.settings.name} previous ${previous.settings.name}');
    notify();
  }
}
