part of 'main.dart';

abstract class _Search extends _Mock {
  // SuggestionType? _cacheSuggestion;
  // SuggestionType _cacheSuggestion = const SuggestionType<Map<String, String>>();
  // ConclusionType _cacheConclusion = const ConclusionType();

  // SuggestionType get cacheSuggestion => const SuggestionType();
  // ConclusionType get cacheConclusion => const ConclusionType();
  /// ```dart
  /// [query: String, raw: List<Map<String, Object?>>]
  /// ```
  /// typeof [SuggestionType]
  // Future<void> suggestionGenerate() async {}
  Future<void> suggestionGenerate() async {
    // _cacheSuggestion = SuggestionType(
    //   query: data.suggestQuery,
    // );

    // Stopwatch suggestionWatch = Stopwatch()..start();
    // int randomNumber = data.random().nextInt(100);
    // _cacheSuggestion = SuggestionType(
    //   query: data.suggestQuery,
    //   // raw: await _sql.suggestion()
    //   raw:
    //       List.generate(randomNumber, (_) => {'word': 'random $randomNumber ${data.suggestQuery}'}),
    // );
    // notify();
    // debugPrint('suggestionGenerate in ${suggestionWatch.elapsedMilliseconds} ms');
    // await scripturePrimary.init();
    // cacheSearch = scripturePrimary.verseSearch(query: searchQuery);
    // debugPrint('verseCount in ${abc.verseCount}');
    // scripturePrimary.searchQuery = searchQuery;
    // notify();
  }

  // SuggestionType get cacheSuggestion {
  //   return _cacheSuggestion;
  // }

  Future<void> conclusionGenerate() async {
    // _cacheConclusion = ConclusionType(
    //   query: data.searchQuery,
    // );
    // scripturePrimary.bible.info.langCode
    debugPrint('cacheConclusion');
    // data.boxOfRecentSearch.update(data.searchQuery);
    data.boxOfRecentSearch.update(data.searchQuery, scripturePrimary.bible.info.langCode);
  }

  // ConclusionType get cacheConclusion {
  //   debugPrint('cacheConclusion');
  //   return _cacheConclusion;
  // }
}
