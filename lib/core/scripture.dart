part of 'main.dart';

class Scripture{
  late Collection collection;
  // NOTE 0: primary, 1: parallel :2
  final int collectionType;

  BIBLE? cacheVerseChapter;
  BIBLE? cacheVerseSearch;
  int? _identifyIndexPrevious;

  Scripture({
    required this.collection,
    this.collectionType:0
  });

  String get identify {
    switch (collectionType) {
      case(0) :
        return collection.primaryId;
      default:
        return collection.parallelId;
    }
  }
  APIType get api => collection.env.bibleAPI;
  String get url => api.url.replaceAll('?', this.identify);
  String get file => api.file.replaceAll('?', this.identify);

  int get _identifyIndex => collection.cacheBible.indexWhere((DefinitionBible e) => e.info.identify == this.identify);
  int get _bookIndex => collection.boxOfBook.values.toList().indexWhere((BookType e) => e.identify == this.identify);
  BookType? get _bookMeta => collection.boxOfBook.getAt(_bookIndex);
  bool get isReady => _identifyIndex >= 0;
  DefinitionBible get bible => collection.cacheBible.elementAt(isReady?_identifyIndex:_identifyIndexPrevious!);

  Future<DefinitionBible> init() async{
    if (isReady) {
      return this.bible;
    }
    await switchAvailability();
    _identifyIndexPrevious = _identifyIndex;
    if (isReady){
      return this.bible;
    }
    throw "Bible is not loaded";
  }

  Future<void> switchAvailability({bool deleteIfExists = false}) => UtilDocument.exists(file).then((String e) {
    if (e.isEmpty) {
      // NOTE: Not Available, therefore download it
      debugPrint('not Available, therefore download it');
      return _download();
    } else if (deleteIfExists && _bookMeta != null && _bookMeta!.available == 1){
      // NOTE: Available, therefore delete it
      debugPrint('Available, therefore delete it');
      return _delete();
    } else {
      // NOTE: Available, and meta need to update
      debugPrint('Available, and meta need to update');
      return _read();
    }
  }).catchError((e){
    // NOTE: Future.error
    throw e;
  });

  Future<void> switchAvailabilityOfBox(int available) async{
    final box = _bookMeta;
    if (box != null && available != box.available){
      box.available=available;
      await collection.boxOfBook.putAt(_bookIndex, box);
    }
  }

  Future<void> _download() => UtilClient(url).get<String>().then((body) async{
    await _parseDefinitionBible(body);
    await UtilDocument.writeAsString(file,body);
    await switchAvailabilityOfBox(1);
  }).catchError((e) {
    throw e;
  });

  Future<void> _read() => UtilDocument.readAsString(file).then((e) async{
    await _parseDefinitionBible(e);
    await switchAvailabilityOfBox(1);
  }).catchError((e){
    // NOTE: Future.error
    throw e;
  });

  Future<void> _delete() => UtilDocument.delete(file).then((_) async {
    // NOTE: since its deleted from storage, have to remove it from session/cache
    if (isReady){
      collection.cacheBible.removeAt(_identifyIndex);
    }
    return switchAvailabilityOfBox(0);
  });

  Future<void> _parseDefinitionBible(String response) async{
    DefinitionBible parsed = await compute(parseDefinitionBibleCompute,response);
    collection.cacheBible.add(parsed);
    await _prepareName();
  }

  Future<void> _prepareName() async{
    bible.book.forEach((id, v) {
      int bookId = int.parse(id);
      int testamentId = (bookId >= 40)?2:1;

      bible.bookInfo.add(DefinitionBook(
        id: bookId,
        testamentId: testamentId,
        name: v['info']['name'],
        shortName: v['info']['shortname'],
        chapterCount: v['chapter'].keys.length,
      ));
    });

    bible.testament.forEach((id, o) {
      bible.testamentInfo.add(DefinitionTestament(
        id: int.parse(id),
        name: o['info']['name'],
        shortName:o['info']['shortname'],
      ));
    });
  }

  /// convert (Int or Number of String), chapterId, verseId into it's written language
  String digit(dynamic e) => (e is String?e:e.toString()).replaceAllMapped(
    new RegExp(r'[0-9]'), (i) {
      if (isReady) {
        return bible.digit[int.parse(i.group(0)!)];
      }
      return i.group(0)!;
    }
  );

  BookType get info => bible.info;
  List<DefinitionBook> get bookList => bible.bookInfo;
  DefinitionBook bookById(int bookId) => bookList.firstWhere(
    (DefinitionBook e) => e.id == bookId, orElse: () => bookList.first
  );
  DefinitionBook get bookCurrent => bookById(collection.bookId);

  List<DefinitionTestament> get testamentList => bible.testamentInfo;
  DefinitionTestament testamentById(int testamentId) => testamentList.firstWhere(
    (DefinitionTestament e) => e.id == testamentId, orElse: () => testamentList.first
  );
  DefinitionTestament get testamentCurrent => this.testamentById(collection.testamentId);

  String get bookName => bookCurrent.name;
  int get chapterCount => bookCurrent.chapterCount;
  String get chapterName => digit(collection.chapterId);
  bool isCurrentChapter(int id) => (collection.chapterId == id);

  /// Update previous chapterId, if require its update bookId too
  // Future<void> get chapterPrevious => init().then((o){
  //   int totalBook = o.book.keys.length;
  //   int cId = collection.chapterId - 1;
  //   if (cId > 0) {
  //     collection.chapterId = cId;
  //   } else {
  //     int bId = collection.bookId - 1;
  //     if (bId > 0) {
  //       collection.bookId = bId;
  //     } else {
  //       collection.bookId = totalBook;
  //     }
  //     int totalChapter = o.book[collection.bookId.toString()]['chapter'].keys.length;
  //     collection.chapterId = totalChapter;
  //   }
  // });
  void chapterPrevious(){
    int totalBook = bible.book.keys.length;
    int cId = collection.chapterId - 1;
    if (cId > 0) {
      collection.chapterId = cId;
    } else {
      int bId = collection.bookId - 1;
      if (bId > 0) {
        collection.bookId = bId;
      } else {
        collection.bookId = totalBook;
      }
      int totalChapter = bible.book[collection.bookId.toString()]['chapter'].keys.length;
      collection.chapterId = totalChapter;
    }
  }

  /// Update next chapterId, if require its update bookId too
  // Future<void> get chapterNext => init().then((o){
  //   int totalBook = o.book.keys.length;
  //   int totalChapter = o.book[collection.bookId.toString()]['chapter'].keys.length;
  //   int cId = collection.chapterId + 1;
  //   if (totalChapter >= cId) {
  //     collection.chapterId = cId;
  //   } else {
  //     int bId = collection.bookId + 1;
  //     if (bId <= totalBook) {
  //       collection.bookId = bId;
  //     } else {
  //       collection.bookId = 1;
  //     }
  //     collection.chapterId = 1;
  //   }
  // });
  void chapterNext() {
    int totalBook = bible.book.keys.length;
    int totalChapter = bible.book[collection.bookId.toString()]['chapter'].keys.length;
    int cId = collection.chapterId + 1;
    if (totalChapter >= cId) {
      collection.chapterId = cId;
    } else {
      int bId = collection.bookId + 1;
      if (bId <= totalBook) {
        collection.bookId = bId;
      } else {
        collection.bookId = 1;
      }
      collection.chapterId = 1;
    }
  }

  /// Update chapterId, if Not in available chapter range set to First or Last
  // Future<void> chapterBook({int? bId, int? cId}) => init().then((o){
  //   if (cId != null) {
  //     collection.chapterId = cId;
  //   }
  //   if (bId != null) {
  //     int totalChapter = o.book[bId.toString()]['chapter'].keys.length;
  //     if (totalChapter < collection.chapterId) {
  //       if (collection.bookId < bId) {
  //         collection.chapterId = totalChapter;
  //       } else {
  //         collection.chapterId = 1;
  //       }
  //     }
  //     collection.bookId = bId;
  //   }
  // });
  void chapterBook({int? bId, int? cId}) {
    if (cId != null) {
      collection.chapterId = cId;
    }
    if (bId != null) {
      int totalChapter = bible.book[bId.toString()]['chapter'].keys.length;
      if (totalChapter < collection.chapterId) {
        if (collection.bookId < bId) {
          collection.chapterId = totalChapter;
        } else {
          collection.chapterId = 1;
        }
      }
      collection.bookId = bId;
    }
  }

  bool get bookmarked => collection.bookmarkIndex >= 0;

  bool verseSearchCacheIsEmpty() {
    // {String id, int testament, int book, int chapter, String query}
    // this.setting(id, testament, book, chapter, query);
    // return (this.searchQuery.isNotEmpty) && (
    //   // searchQuery != null ||
    //   // searchQuery.isNotEmpty &&
    //   verseSearchCache == null ||
    //   verseSearchCache.info == null ||
    //   // _verseSearchCache.query != null ||
    //   verseSearchCache.query != searchQuery ||
    //   verseSearchCache.info.identify != this.identify
    // );
    return (
      cacheVerseSearch == null ||
      cacheVerseSearch!.info.identify != this.identify ||
      cacheVerseSearch!.query != collection.searchQuery
      // cacheVerseSearch!.book.first.info.id  != collection.bookId ||
      // cacheVerseSearch!.book.first.chapter.first.id  != collection.chapterId
    );
  }

  BIBLE get verseSearch {
    if (verseSearchCacheIsEmpty()){
      cacheVerseSearch = new BIBLE(
        info: bible.info,
        book: [],

        query:collection.searchQuery,

        bookCount:0,
        chapterCount:0,
        verseCount:0
      );

      bible.book.forEach((bId, bO) {
        List<CHAPTER> chapterBlock = [];
        bO['chapter'].forEach((cId, cO) {
          List<VERSE> verseBlock = [];
          cO['verse'].forEach((vId, v) {
            if (new RegExp(collection.searchQuery,caseSensitive: false).hasMatch(v['text'])){
              cacheVerseSearch!.verseCount++;
              verseBlock.add(new VERSE.fromJSON(new GlobalKey(),int.parse(vId), this.digit(vId), v));
            }
          });

          if (verseBlock.length > 0) {
            cacheVerseSearch!.chapterCount++;
            chapterBlock.add(new CHAPTER(
              id:int.parse(cId),
              name:this.digit(cId),
              verse: verseBlock
            ));
          }
        });

        if (chapterBlock.length > 0) {
          cacheVerseSearch!.bookCount++;
          cacheVerseSearch!.book.add(new BOOK(
            info: bookById(int.parse(bId)),
            chapter: chapterBlock
          ));
        }
      });

      // debugPrint('+ verseSearch: Ok (${collection.searchQuery})');
    }
    // debugPrint('- verseSearch: log ($searchQuery) book:${verseSearchCache.bookCount} chapter:${verseSearchCache.chapterCount} verse:${verseSearchCache.verseCount}');
    return cacheVerseSearch!;
  }

  bool get verseChapterCacheIsEmpty {
    return (
      cacheVerseChapter == null ||
      cacheVerseChapter!.info.identify != this.identify ||
      cacheVerseChapter!.book.first.info.id  != collection.bookId ||
      cacheVerseChapter!.book.first.chapter.first.id  != collection.chapterId
    );
  }

  BIBLE get verseChapter {
    if (verseChapterCacheIsEmpty){
      cacheVerseChapter = new BIBLE(
        info: bible.info,
        book: [],

        query:collection.searchQuery,

        bookCount:0,
        chapterCount:0,
        verseCount:0
      );
      // final tId = this.testamentId.toString();
      final bId = collection.bookId.toString();
      final cId = collection.chapterId.toString();

      CHAPTER chapterBlock = new CHAPTER(
        id: collection.chapterId,
        name: this.chapterName,
        verse: []
      );

      bible.book[bId]['chapter'][cId]['verse'].forEach((vId, v) {
        cacheVerseChapter!.verseCount++;
        chapterBlock.verse.add(new VERSE.fromJSON(new GlobalKey(),int.parse(vId), this.digit(vId), v));
      });

      BOOK bookBlock = new BOOK(
        info: bookCurrent,
        chapter: [
          chapterBlock
        ]
      );
      cacheVerseChapter!.book.add(bookBlock);
      // debugPrint('+ verseChapter: Ok');
    }
    return cacheVerseChapter!;
  }

}