part of 'main.dart';

mixin _Data on _State {
  Future<bool> _dataResult;
  Future<bool> get getResult => _dataResult=hasNotResult?_newResult():_dataResult;
  Future<bool> _newResult() async{
    await core.versePrimarySearch();
    return hasNotResult == false;
  }

  // Future<BIBLE> getResult() => core.verseSearch();
  // bool get hasNotResult => core.scripturePrimary.verseSearchDataIsEmpty();

  bool get hasNotResult => core.scripturePrimary.verseSearchDataIsEmpty(
    id: core.primaryId,
    testament: core.testamentId,
    book: core.bookId,
    chapter: core.chapterId,
    query: core.searchQuery
  );

  BIBLE get bible => core.scripturePrimary.verseSearchData;
  bool get shrinkResult => bible.verseCount > 300;

  CollectionBible get bibleInfo => core.collectionPrimary;
  List<CollectionKeyword> get keywords => core.collection.keyword;

  List<CollectionKeyword> get keywordSuggestion {
    if (searchQuery.isEmpty){
      return this.keywords;
    } else {
      return this.keywords.where((e)=>e.word.toLowerCase().startsWith(searchQuery.toLowerCase())).toList();
    }
  }

  void toBible(int bookId, int chapterId) {
    core.bookId = bookId;
    core.chapterId = chapterId;
    controller.master.bottom.pageChange(1);
  }
}
