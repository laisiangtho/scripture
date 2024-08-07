part of 'main.dart';

class Data extends DataNest {
  /// retrieve the instance through the app
  /// ```dart
  /// Data.internal();
  /// Data.internal() : super.internal();
  /// Data() : super();
  /// ```
  Data({required super.state});

  late final boxOfBooks = BoxOfBooks<BooksType>();
  late final boxOfBookmarks = BoxOfBookmarks<BookmarksType>();

  List<OfBible> cacheBible = [];

  @override
  Future<void> ensureInitialized() async {
    await super.ensureInitialized();

    boxOfBooks.registerAdapter(BooksAdapter());
    boxOfBookmarks.registerAdapter(BookmarksAdapter());
  }

  @override
  Future<void> prepareInitialized() async {
    await super.prepareInitialized();

    await boxOfBooks.open('bible-list');
    await boxOfBookmarks.open('bible-bookmark');
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
