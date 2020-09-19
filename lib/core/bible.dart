part of 'core.dart';

mixin _Bible on _Collection {

  // Scripture abc(String id) => new Scripture(identify:id);

  Future<void> updateBibleAvailability(String id) {
    Scripture scripture = new Scripture(identify:id);
    return scripture.updateAvailability().then((_){
      updateCollectionBookAvailability(id,scripture.availability);
    });
  }

  // primaryBible parallelBible getBiblePrimary getBibleParallel
  Future<DefinitionBible> get getBiblePrimary async{
    if (scripturePrimary == null) scripturePrimary = new Scripture();
    scripturePrimary.setting(this.primaryId,this.testamentId,this.bookId,this.chapterId,this.searchQuery);
    return scripturePrimary.load.then((value) {
      updateCollectionBookAvailability(this.primaryId,scripturePrimary.availability);
      return value;
    });
  }

  Future<Scripture> get getBibleParallel async{
    if (scriptureParallel == null) scriptureParallel = new Scripture();
    scriptureParallel.setting(this.parallelId,this.testamentId,this.bookId,this.chapterId,this.searchQuery);
    return scriptureParallel.load.then((value) {
      updateCollectionBookAvailability(this.parallelId,scriptureParallel.availability);
      return scriptureParallel;
    });
  }

  List<DefinitionBook> get getDefinitionBookList => scripturePrimary.bookList;
  DefinitionBook getDefinitionBookById(int bookId) => scripturePrimary.bookById(bookId);
  DefinitionBook get getDefinitionBookCurrent => scripturePrimary.bookCurrent;

  List<DefinitionTestament> get getDefinitionTestamentList => scripturePrimary.testamentList;
  DefinitionTestament getDefinitionTestamentById(int testamentId) => scripturePrimary.testamentById(testamentId);
  DefinitionTestament get getDefinitionTestamentCurrent => scripturePrimary.testamentCurrent;

  String get bookName => scripturePrimary.bookName;
  String get chapterName => scripturePrimary.chapterName;

  // Future<BIBLE> verseSearch() => scripturePrimary.verseSearch();
  // Future<BIBLE> verseChapter() => scripturePrimary.verseChapter();
  Future<BIBLE> versePrimarySearch() => this.getBiblePrimary.then((e) => scripturePrimary.verseSearch);
  Future<BIBLE> versePrimaryChapter() => this.getBiblePrimary.then((e) => scripturePrimary.verseChapter);

  Future<BIBLE> verseParallelChapter() => this.getBibleParallel.then((e) => e.verseChapter);

  /// Update previous chapterId, if require its update bookId too
  Future<void> get chapterPrevious => scripturePrimary.data.then((o){
    int totalBook = o.book.keys.length;
    int cId = this.chapterId - 1;
    if (cId > 0) {
      this.chapterId = cId;
    } else {
      int bId = this.bookId - 1;
      if (bId > 0) {
        this.bookId = bId;
      } else {
        this.bookId = totalBook;
      }
      int totalChapter = o.book[this.bookId.toString()]['chapter'].keys.length;
      this.chapterId = totalChapter;
    }
  });

  /// Update next chapterId, if require its update bookId too
  Future<void> get chapterNext => scripturePrimary.data.then((o){
    int totalBook = o.book.keys.length;
    int totalChapter = o.book[this.bookId.toString()]['chapter'].keys.length;
    int cId = this.chapterId + 1;
    if (totalChapter >= cId) {
      this.chapterId = cId;
    } else {
      int bId = this.bookId + 1;
      if (bId <= totalBook) {
        this.bookId = bId;
      } else {
        this.bookId = 1;
      }
      this.chapterId = 1;
    }
  });

  /// Update chapterId, if Not in available chapter range set to First or Last
  Future<void> chapterBook(int id) => scripturePrimary.data.then((o){
    int totalChapter = o.book[id.toString()]['chapter'].keys.length;
    if (totalChapter < this.chapterId) {
      if (this.bookId < id) {
        this.chapterId = totalChapter;
      } else {
        this.chapterId = 1;
      }
    }
    this.bookId = id;
  });

}
