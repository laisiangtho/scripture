part of 'main.dart';

abstract class _Searches extends _Engines {
  @override
  Future<void> suggestionGenerate({String ord = ''}) async {
    data.suggestQuery = ord;
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

  @override
  Future<void> conclusionGenerate({String ord = ''}) async {
    data.searchQuery = ord;
    // _cacheConclusion = ConclusionType(
    //   query: data.searchQuery,
    // );
    // scripturePrimary.bible.info.langCode

    data.boxOfRecentSearch.update(ord, scripturePrimary.bible.info.langCode);
  }

  // ConclusionType get cacheConclusion {
  //   debugPrint('cacheConclusion');
  //   return _cacheConclusion;
  // }
}
