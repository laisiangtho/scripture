import 'package:flutter/material.dart';
import 'package:lidea/intl.dart';

// import 'package:bible/core.dart';
import 'package:bible/type.dart';

/// A service that stores and retrieves user settings.
///
/// By default, this class does not persist user settings. If you'd like to
/// persist the user settings locally, use the shared_preferences package. If
/// you'd like to store settings on a web server, use the http package.
class SettingsService {
  SettingsService(this._collection);
  final Collection _collection;

  /// Loads the User's preferred ThemeMode from local or remote storage.
  // Future<ThemeMode> themeMode() async => ThemeMode.system;
  // Future<ThemeMode> theme() async {
  //   final mode = ThemeMode.values.elementAt(0);
  //   return ThemeMode.values.firstWhere((e) => e == mode, orElse: () => ThemeMode.system);
  // }

  SettingType get setting => _collection.setting;

  /// Persists the user's preferred ThemeMode to local or remote storage.
  // Use the shared_preferences package to persist settings locally or the
  // http package to persist settings over the network.
  Future<void> updateTheme(ThemeMode theme) async {
    final mode = ThemeMode.values.indexOf(theme);
    await _collection.settingUpdate(setting.copyWith(mode: mode));
  }

  // Future<Locale> locale() async => Intl.systemLocale;
  // Future<Locale> locale() async => Locale(Intl.getCurrentLocale(),'');
  Future<Locale> locale() async {
    final lang = setting.locale;
    return Locale(lang.isEmpty ? Intl.systemLocale : lang, '');
  }

  Future<void> updateLocale(Locale locale) async {
    await _collection.settingUpdate(setting.copyWith(locale: locale.languageCode));
  }
}
