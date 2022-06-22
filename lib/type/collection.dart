part of data.type;

class Collection extends ClusterDocket {
  late final boxOfBookmarks = BoxOfBookmarks<BookmarksType>();
  late final boxOfBooks = BoxOfBooks<BooksType>();

  List<DefinitionBible> cacheBible = [];

  // retrieve the instance through the app
  // Collection.internal();
  // Collection.internal() : super.internal();

  Collection() : super();

  @override
  Future<void> ensureInitialized() async {
    await super.ensureInitialized();
    boxOfBookmarks.registerAdapter(BookmarksAdapter());
    boxOfBooks.registerAdapter(BooksAdapter());
  }

  @override
  Future<void> prepareInitialized() async {
    await super.prepareInitialized();

    await boxOfBookmarks.open('bookmark');
    await boxOfBooks.open('book');
  }

  String get primaryId => boxOfSettings.identify().asString;
  set primaryId(String id) {
    boxOfSettings.identify(value: id);
  }

  String get parallelId => boxOfSettings.parallel().asString;
  set parallelId(String id) {
    boxOfSettings.parallel(value: id);
  }

  int get testamentId => bookId > 39 ? 2 : 1;

  int get bookId => boxOfSettings.bookId().asInt;
  set bookId(int id) {
    boxOfSettings.bookId(value: id);
  }

  int get chapterId => boxOfSettings.chapterId().asInt;
  set chapterId(int id) {
    boxOfSettings.chapterId(value: id);
  }

  // NOTE: Bookmark
  int get bookmarkIndex => boxOfBookmarks.index(bookId, chapterId);
}
