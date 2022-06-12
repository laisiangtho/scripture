part of data.core;

class Scripture {
  late Collection collection;
  // NOTE [0: primary, 1: parallel]
  final int collectionType;
  ValueNotifier<List<int>> verseSelection = ValueNotifier<List<int>>([]);

  BIBLE? cacheVerseChapter;
  BIBLE? cacheVerseSearch;
  // String searchQuery = '';
  int? _identifyIndexPrevious;

  Scripture({
    required this.collection,
    this.collectionType = 0,
  });

  String get identify {
    switch (collectionType) {
      case (0):
        return collection.primaryId;
      default:
        return collection.parallelId;
    }
  }

  APIType get api => collection.env.url('bible');
  Uri get url => api.uri(identify);
  String get file => api.cache(identify);

  int get _identifyIndex {
    return collection.cacheBible.indexWhere((DefinitionBible e) => e.info.identify == identify);
  }

  int get _bookIndex {
    return collection.boxOfBooks.values
        .toList()
        .indexWhere((BooksType e) => e.identify == identify);
  }

  BooksType? get _bookMeta {
    return collection.boxOfBooks.box.getAt(_bookIndex);
  }

  bool get isReady {
    return _identifyIndex >= 0;
  }

  // NOTE: Null check operator used on a null value -> _identifyIndexPrevious
  DefinitionBible get bible {
    return collection.cacheBible.elementAt(isReady ? _identifyIndex : _identifyIndexPrevious!);
  }

  Future<DefinitionBible> init() async {
    // searchQuery = collection.searchQuery;
    // debugPrint('scripture: $identify');
    if (isReady) {
      return bible;
    }
    await switchAvailability();
    _identifyIndexPrevious = _identifyIndex;
    if (isReady) {
      return bible;
    }
    // throw "Bible is not loaded";
    return Future.error('Bible is not loaded');
  }

  Future<void> switchAvailability({bool deleteIfExists = false}) {
    return UtilDocument.exists(file).then((String e) {
      if (e.isEmpty) {
        // NOTE: Not Available, therefore download it
        debugPrint('Unavailable, therefore download it');
        return _download();
      } else if (deleteIfExists && _bookMeta != null && _bookMeta!.available == 1) {
        // NOTE: Available, therefore delete it
        debugPrint('Available, therefore delete it');
        return _delete();
      } else {
        // NOTE: Available, and meta need to update
        debugPrint('Available, and meta need to update');
        return _read();
      }
    }).catchError((e) {
      // NOTE: Future.error
      throw e;
    });
  }

  Future<void> switchAvailabilityOfBox(int available) async {
    final box = _bookMeta;
    if (box != null && available != box.available) {
      box.available = available;
      await collection.boxOfBooks.box.putAt(_bookIndex, box);
    }
  }

  Future<void> _download() {
    return UtilAsk(url).get<String>().then((body) async {
      await _parseDefinitionBible(body);
      await UtilDocument.writeAsString(file, body);
      await switchAvailabilityOfBox(1);
    }).catchError((e) {
      throw e;
    });
  }

  Future<void> _read() {
    return UtilDocument.readAsString(file).then((e) async {
      await _parseDefinitionBible(e);
      await switchAvailabilityOfBox(1);
    }).catchError((e) {
      // NOTE: Future.error
      throw e;
    });
  }

  Future<void> _delete() {
    return UtilDocument.delete(file).then((_) async {
      // NOTE: since its deleted from storage, have to remove it from session/cache
      if (isReady) {
        collection.cacheBible.removeAt(_identifyIndex);
      }
      return switchAvailabilityOfBox(0);
    });
  }

  Future<void> _parseDefinitionBible(String response) async {
    DefinitionBible parsed = await compute(parseDefinitionBibleCompute, response);
    collection.cacheBible.add(parsed);
    await _prepareName();
  }

  Future<void> _prepareName() async {
    bible.book.forEach((id, v) {
      int bookId = int.parse(id);
      int testamentId = (bookId >= 40) ? 2 : 1;

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
        shortName: o['info']['shortname'],
      ));
    });
  }

  /// convert (Int or Number of String), chapterId, verseId into it's written language
  String digit(dynamic e) {
    return (e is String ? e : e.toString()).replaceAllMapped(RegExp(r'[0-9]'), (i) {
      if (isReady) {
        return bible.digit[int.parse(i.group(0)!)];
      }
      return i.group(0)!;
    });
  }

  BooksType get info {
    return bible.info;
  }

  List<DefinitionBook> get bookList {
    return bible.bookInfo;
  }

  DefinitionBook bookById(int bookId) {
    return bookList.firstWhere(
      (DefinitionBook e) => e.id == bookId,
      orElse: () => bookList.first,
    );
  }

  DefinitionBook get bookCurrent {
    return bookById(collection.bookId);
  }

  List<DefinitionTestament> get testamentList {
    return bible.testamentInfo;
  }

  DefinitionTestament testamentById(int testamentId) {
    return testamentList.firstWhere(
      (DefinitionTestament e) => e.id == testamentId,
      orElse: () => testamentList.first,
    );
  }

  DefinitionTestament get testamentCurrent {
    return testamentById(collection.testamentId);
  }

  String get bookName {
    return bookCurrent.name;
  }

  int get chapterCount {
    return bookCurrent.chapterCount;
  }

  String get chapterName {
    return digit(collection.chapterId);
  }

  bool isCurrentChapter(int id) {
    return (collection.chapterId == id);
  }

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
  void chapterPrevious() {
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

  bool get bookmarked {
    return collection.bookmarkIndex >= 0;
  }

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
    return (cacheVerseSearch == null ||
            cacheVerseSearch!.info.identify != identify ||
            cacheVerseSearch!.query != collection.suggestQuery.asString
        // cacheVerseSearch!.book.first.info.id  != collection.bookId ||
        // cacheVerseSearch!.book.first.chapter.first.id  != collection.chapterId
        );
  }

  BIBLE get verseSearch {
    // final searchQuery = (query == null) ? collection.searchQuery : query;
    if (verseSearchCacheIsEmpty()) {
      cacheVerseSearch = BIBLE(
        info: bible.info,
        book: [],
        query: collection.suggestQuery.asString,
        bookCount: 0,
        chapterCount: 0,
        verseCount: 0,
      );
      if (collection.suggestQuery.asString.isEmpty) {
        return cacheVerseSearch!;
      }

      bible.book.forEach((bId, bO) {
        List<CHAPTER> chapterBlock = [];
        bO['chapter'].forEach((cId, cO) {
          List<VERSE> verseBlock = [];
          cO['verse'].forEach((vId, v) {
            if (RegExp(collection.suggestQuery.asString, caseSensitive: false)
                .hasMatch(v['text'])) {
              cacheVerseSearch!.verseCount++;
              verseBlock.add(
                VERSE.fromJSON(GlobalKey(), int.parse(vId), digit(vId), v),
              );
            }
          });

          if (verseBlock.isNotEmpty) {
            cacheVerseSearch!.chapterCount++;
            chapterBlock.add(
              CHAPTER(
                id: int.parse(cId),
                name: digit(cId),
                verse: verseBlock,
              ),
            );
          }
        });

        if (chapterBlock.isNotEmpty) {
          cacheVerseSearch!.bookCount++;
          cacheVerseSearch!.book.add(
            BOOK(
              info: bookById(int.parse(bId)),
              chapter: chapterBlock,
            ),
          );
        }
      });

      debugPrint('+ verseSearch: (${collection.suggestQuery})');
    }
    // debugPrint('- verseSearch: log ($searchQuery) book:${verseSearchCache.bookCount} chapter:${verseSearchCache.chapterCount} verse:${verseSearchCache.verseCount}');
    return cacheVerseSearch!;
  }

  bool get verseChapterCacheIsEmpty {
    return (cacheVerseChapter == null ||
        cacheVerseChapter!.info.identify != identify ||
        cacheVerseChapter!.book.first.info.id != collection.bookId ||
        cacheVerseChapter!.book.first.chapter.first.id != collection.chapterId);
  }

  BIBLE get verseChapter {
    if (verseChapterCacheIsEmpty) {
      cacheVerseChapter = BIBLE(
        info: bible.info,
        book: [],
        query: collection.searchQuery.asString,
        bookCount: 0,
        chapterCount: 0,
        verseCount: 0,
      );
      // final tId = this.testamentId.toString();
      final bId = collection.bookId.toString();
      final cId = collection.chapterId.toString();

      CHAPTER chapterBlock = CHAPTER(id: collection.chapterId, name: chapterName, verse: []);

      bible.book[bId]['chapter'][cId]['verse'].forEach((vId, v) {
        cacheVerseChapter!.verseCount++;
        chapterBlock.verse.add(
          VERSE.fromJSON(GlobalKey(), int.parse(vId), digit(vId), v),
        );
      });

      BOOK bookBlock = BOOK(
        info: bookCurrent,
        chapter: [chapterBlock],
      );
      cacheVerseChapter!.book.add(bookBlock);
      // debugPrint('+ verseChapter: Ok');
    }
    return cacheVerseChapter!;
  }
}
