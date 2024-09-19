part of 'main.dart';

abstract class _State<T extends StatefulWidget> extends SearchViews<T> {
  @override
  late final Core app = App.core;

  @override
  String? get labelBackButton => app.preference.of(context).back;

  @override
  String? get labelSearchHint => app.preference.of(context).aWordOrTwo;

  @override
  String? get labelSearchCancel => app.preference.of(context).cancel;

  @override
  String? get labelSearchClear => app.preference.of(context).clear;

  @override
  Widget? get iconSearchPrefix {
    return Selector<Core, BooksType>(
      selector: (_, e) => e.scripturePrimary.info,
      builder: (BuildContext _, BooksType info, Widget? child) {
        return labelSearchPrefix(label: info.langCode.toUpperCase());
      },
    );
  }

  /// ```dart
  /// Scripture get primaryScripture => app.scripturePrimary;
  /// late final Scripture primaryScripture = app.scripturePrimary;
  /// ```
  late final Scripture primaryScripture = app.scripturePrimary;

  /// ```dart
  /// late final CacheBible bible = primaryScripture.verseSearch;
  /// CacheBible get bible => primaryScripture.verseSearch;
  /// ```
  // late CacheBible bible = primaryScripture.verseSearch;
}
