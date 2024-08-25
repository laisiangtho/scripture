part of 'main.dart';

abstract class _State<T extends StatefulWidget> extends SearchViews<T> {
  @override
  late final Core app = App.core;

  @override
  String? get labelSearchHint => preference.text.aWordOrTwo;

  @override
  String? get labelSearchCancel => preference.text.cancel;

  @override
  String? get labelSearchClear => preference.text.clear;

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
