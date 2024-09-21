part of 'main.dart';

abstract class _State<T extends StatefulWidget> extends SearchEngineStates<T> {
  @override
  String? get labelBackButton => lang.back;

  @override
  String? get labelSearchHint => lang.aWordOrTwo;

  @override
  String? get labelSearchCancel => lang.cancel;

  @override
  String? get labelSearchClear => lang.clear;

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
