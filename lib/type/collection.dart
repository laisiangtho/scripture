part of "main.dart";

class Collection extends ClusterDocket {
  late Box<BookmarkType> boxOfBookmark;
  late Box<BookType> boxOfBook;
  List<DefinitionBible> cacheBible = [];

  // retrieve the instance through the app
  Collection.internal();

  @override
  Future<void> ensureInitialized() async {
    await super.ensureInitialized();
    Hive.registerAdapter(BookmarkAdapter());
    Hive.registerAdapter(BookAdapter());
  }

  @override
  Future<void> prepareInitialized() async {
    await super.prepareInitialized();
    boxOfBookmark = await Hive.openBox<BookmarkType>('bookmark');
    boxOfBook = await Hive.openBox<BookType>('book');
  }

  String get primaryId => setting.identify;
  set primaryId(String id) {
    if (setting.identify != id) {
      settingUpdate(setting.copyWith(identify: id));
    }
  }

  String get parallelId => setting.parallel;
  set parallelId(String id) {
    if (setting.parallel != id) {
      settingUpdate(setting.copyWith(parallel: id));
    }
  }

  int get testamentId => bookId > 39 ? 2 : 1;

  int get bookId => setting.bookId;
  set bookId(int id) {
    if (setting.bookId != id) {
      settingUpdate(setting.copyWith(bookId: id));
    }
  }

  int get chapterId => setting.chapterId;
  set chapterId(int id) {
    if (setting.chapterId != id) {
      settingUpdate(setting.copyWith(chapterId: id));
    }
  }

  // NOTE: Bookmark
  int get bookmarkIndex => boxOfBookmark
      .toMap()
      .values
      .toList()
      .indexWhere((e) => e.bookId == bookId && e.chapterId == chapterId);

  Future<void> bookmarkDelete(int index) => boxOfBookmark.deleteAt(index);

  Future<void> bookmarkSwitch() {
    if (bookmarkIndex >= 0) {
      return bookmarkDelete(bookmarkIndex);
    } else {
      return boxOfBookmark.add(
        BookmarkType(
          identify: primaryId,
          date: DateTime.now(),
          bookId: bookId,
          chapterId: chapterId,
        ),
      );
    }
  }
}
