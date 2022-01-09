part of 'main.dart';

class Preference extends UnitController {
  final Collection _collection;

  Preference(this._collection);

  /// `AppLocalizations.of(context)!`;
  AppLocalizations get text {
    return AppLocalizations.of(context)!;
  }

  List<Locale> get supportedLocales {
    return AppLocalizations.supportedLocales;
  }

  SettingType get _setting => _collection.setting;

  @override
  int get mode => _setting.mode;

  @override
  Locale get locale {
    final lang = _setting.locale;
    return Locale(lang.isEmpty ? Intl.systemLocale : lang, '');
  }

  @override
  Future<void> saveMode(ThemeMode newMode) async {
    final mode = ThemeMode.values.indexOf(newMode);
    await _collection.settingUpdate(_setting.copyWith(mode: mode));
  }

  @override
  Future<void> saveLocale(Locale newLocale) async {
    await _collection.settingUpdate(_setting.copyWith(locale: newLocale.languageCode));
  }
}
