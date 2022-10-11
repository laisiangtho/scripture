part of data.core;

class Scripture extends _ScriptureInterface {
  final Data data;

  // NOTE [0: primary, 1: parallel]
  final int dataType;

  BIBLE? cacheRead;
  BIBLE? cacheVerseSearch;
  // String searchQuery = '';
  int? _identifyIndexPrevious;

  Scripture(
    this.data, {
    this.dataType = 0,
  });

  String get identify {
    switch (dataType) {
      case (0):
        return data.primaryId;
      default:
        return data.parallelId;
    }
  }

  APIType get api => data.env.url('bible');
  Uri get url => api.uri(name: identify);
  String get file => api.cache(identify);

  int get _identifyIndex {
    return data.cacheBible.indexWhere((DefinitionBible e) => e.info.identify == identify);
  }

  int get _bookIndex {
    return data.boxOfBooks.values.toList().indexWhere((BooksType e) => e.identify == identify);
  }

  BooksType? get _bookMeta {
    return data.boxOfBooks.box.getAt(_bookIndex);
  }

  bool get isReady {
    return _identifyIndex >= 0;
  }

  // NOTE: Null check operator used on a null value -> _identifyIndexPrevious
  DefinitionBible get bible {
    return data.cacheBible.elementAt(isReady ? _identifyIndex : _identifyIndexPrevious!);
  }

  Future<DefinitionBible> init() async {
    // searchQuery = data.searchQuery;
    // final check = _identifyIndexPrevious == _identifyIndex;
    debugPrint('scripture: $identify $isReady');
    // _identifyIndexPrevious = _identifyIndex;
    if (isReady) {
      if (dataType == 0) {
        data.notify();
      }

      return bible;
    }
    await switchAvailability();
    _identifyIndexPrevious = _identifyIndex;
    debugPrint('scripture switching: ???');
    if (isReady) {
      return bible;
    }
    debugPrint('Bible is not loaded');
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
      debugPrint('switchAvailability, $e');
      throw e;
    });
  }

  Future<void> switchAvailabilityOfBox(int available) async {
    final box = _bookMeta;
    if (box != null && available != box.available) {
      box.available = available;
      await data.boxOfBooks.box.putAt(_bookIndex, box);
    }
  }

  Future<void> _download() {
    return AskNest(url).get<String>().then((body) async {
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
        data.cacheBible.removeAt(_identifyIndex);
      }
      return switchAvailabilityOfBox(0);
    });
  }

  Future<void> _parseDefinitionBible(String response) async {
    DefinitionBible parsed = await compute(parseDefinitionBibleCompute, response);
    data.cacheBible.add(parsed);
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
    return bookById(data.bookId);
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
    return testamentById(data.testamentId);
  }

  String get bookName {
    return bookCurrent.name;
  }

  int get chapterCount {
    return bookCurrent.chapterCount;
  }

  String get chapterName {
    return digit(data.chapterId);
  }

  bool isCurrentChapter(int id) {
    return (data.chapterId == id);
  }

  /// Update previous chapterId, if require its update bookId too
  // Future<void> get chapterPrevious => init().then((o){
  //   int totalBook = o.book.keys.length;
  //   int cId = data.chapterId - 1;
  //   if (cId > 0) {
  //     data.chapterId = cId;
  //   } else {
  //     int bId = data.bookId - 1;
  //     if (bId > 0) {
  //       data.bookId = bId;
  //     } else {
  //       data.bookId = totalBook;
  //     }
  //     int totalChapter = o.book[data.bookId.toString()]['chapter'].keys.length;
  //     data.chapterId = totalChapter;
  //   }
  // });
  void chapterPrevious() {
    int totalBook = bible.book.keys.length;
    int cId = data.chapterId - 1;
    if (cId > 0) {
      data.chapterId = cId;
    } else {
      int bId = data.bookId - 1;
      if (bId > 0) {
        data.bookId = bId;
      } else {
        data.bookId = totalBook;
      }
      int totalChapter = bible.book[data.bookId.toString()]['chapter'].keys.length;
      data.chapterId = totalChapter;
    }
  }

  /// Update next chapterId, if require its update bookId too
  // Future<void> get chapterNext => init().then((o){
  //   int totalBook = o.book.keys.length;
  //   int totalChapter = o.book[data.bookId.toString()]['chapter'].keys.length;
  //   int cId = data.chapterId + 1;
  //   if (totalChapter >= cId) {
  //     data.chapterId = cId;
  //   } else {
  //     int bId = data.bookId + 1;
  //     if (bId <= totalBook) {
  //       data.bookId = bId;
  //     } else {
  //       data.bookId = 1;
  //     }
  //     data.chapterId = 1;
  //   }
  // });
  void chapterNext() {
    int totalBook = bible.book.keys.length;
    int totalChapter = bible.book[data.bookId.toString()]['chapter'].keys.length;
    int cId = data.chapterId + 1;
    if (totalChapter >= cId) {
      data.chapterId = cId;
    } else {
      int bId = data.bookId + 1;
      if (bId <= totalBook) {
        data.bookId = bId;
      } else {
        data.bookId = 1;
      }
      data.chapterId = 1;
    }
  }

  /// Update chapterId, if Not in available chapter range set to First or Last
  // Future<void> chapterBook({int? bId, int? cId}) => init().then((o){
  //   if (cId != null) {
  //     data.chapterId = cId;
  //   }
  //   if (bId != null) {
  //     int totalChapter = o.book[bId.toString()]['chapter'].keys.length;
  //     if (totalChapter < data.chapterId) {
  //       if (data.bookId < bId) {
  //         data.chapterId = totalChapter;
  //       } else {
  //         data.chapterId = 1;
  //       }
  //     }
  //     data.bookId = bId;
  //   }
  // });
  void chapterBook({int? bId, int? cId}) {
    if (cId != null) {
      data.chapterId = cId;
    }
    if (bId != null) {
      int totalChapter = bible.book[bId.toString()]['chapter'].keys.length;
      if (totalChapter < data.chapterId) {
        if (data.bookId < bId) {
          data.chapterId = totalChapter;
        } else {
          data.chapterId = 1;
        }
      }
      data.bookId = bId;
    }
  }

  bool get bookmarked {
    return data.bookmarkIndex >= 0;
  }

  bool get verseSearchCacheIsEmpty {
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
            cacheVerseSearch!.query != data.suggestQuery
        // cacheVerseSearch!.book.first.info.id  != data.bookId ||
        // cacheVerseSearch!.book.first.chapter.first.id  != data.chapterId
        );
  }

  BIBLE get verseSearch {
    // final searchQuery = (query == null) ? data.searchQuery : query;
    if (verseSearchCacheIsEmpty) {
      cacheVerseSearch = BIBLE(
        info: bible.info,
        book: [],
        query: data.suggestQuery,
        bookCount: 0,
        chapterCount: 0,
        verseCount: 0,
      );
      if (data.suggestQuery.isEmpty) {
        return cacheVerseSearch!;
      }

      bible.book.forEach((bId, bO) {
        List<CHAPTER> chapterBlock = [];
        bO['chapter'].forEach((cId, cO) {
          List<VERSE> verseBlock = [];
          cO['verse'].forEach((vId, v) {
            if (RegExp(data.suggestQuery, caseSensitive: false).hasMatch(v['text'])) {
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

      debugPrint('+ verseSearch: (${data.suggestQuery})');
    }
    // debugPrint('- verseSearch: log ($searchQuery) book:${verseSearchCache.bookCount} chapter:${verseSearchCache.chapterCount} verse:${verseSearchCache.verseCount}');
    return cacheVerseSearch!;
  }

  bool get readCacheIsEmpty {
    return (cacheRead == null ||
        cacheRead!.info.identify != identify ||
        cacheRead!.book.first.info.id != data.bookId ||
        cacheRead!.book.first.chapter.first.id != data.chapterId);
  }

  /// bible from current read
  BIBLE get read {
    if (readCacheIsEmpty) {
      cacheRead = BIBLE(
        info: bible.info,
        book: [],
        query: data.searchQuery,
        bookCount: 0,
        chapterCount: 0,
        verseCount: 0,
      );
      // final tId = this.testamentId.toString();
      final bId = data.bookId.toString();
      final cId = data.chapterId.toString();

      CHAPTER chapterBlock = CHAPTER(id: data.chapterId, name: chapterName, verse: []);

      bible.book[bId]['chapter'][cId]['verse'].forEach((vId, v) {
        cacheRead!.verseCount++;
        chapterBlock.verse.add(
          VERSE.fromJSON(GlobalKey(), int.parse(vId), digit(vId), v),
        );
      });

      BOOK bookBlock = BOOK(
        info: bookCurrent,
        chapter: [chapterBlock],
      );
      cacheRead!.book.add(bookBlock);
      // debugPrint('+ verseChapter: Ok');
    }
    return cacheRead!;
  }

  // BIBLE get bible => verseChapter;
  // // BooksType get tmpbible => bible.info;
  // // DefinitionBook get tmpbook => bible.book.first.info;
  // CHAPTER get tmpchapter => bible.book.first.chapter.first;
  // List<VERSE> get tmpverse => tmpchapter.verse
  // BooksType get currentInfo => verseChapter.info;
  // searchVerse
  // viewVerse
  // searchBible viewBible

  /// list of book from current read
  List<BOOK> get book => read.book;

  /// list of chapter from current reading book
  List<CHAPTER> get chapter => book.first.chapter;

  /// list of verses from current reading chapter
  List<VERSE> get verse => chapter.first.verse;
}

class _ScriptureInterface {
  ValueNotifier<List<int>> verseSelection = ValueNotifier<List<int>>([]);
  // late BuildContext context;
  late ScrollController scroll;

  void scrollToPosition(double pos) {
    scroll.animateTo(
      pos,
      duration: const Duration(milliseconds: 700),
      curve: Curves.ease,
    );
  }
}

extension ScriptureExtension on Scripture {
  Future scrollToIndex(int id, {bool isId = true}) async {
    double scrollTo = 0.0;
    if (id > 0) {
      final offsetList = verse.where((e) {
        return isId ? e.id < id : verse.indexOf(e) < id;
      }).map<double>((e) {
        final key = e.key as GlobalKey;
        if (key.currentContext != null) {
          final render = key.currentContext!.findRenderObject() as RenderBox;
          return render.size.height;
        }
        return 0.0;
      });
      if (offsetList.isNotEmpty) {
        scrollTo = offsetList.reduce((a, b) => a + b) + 19;
      }
      scrollToPosition(scrollTo);
    }
  }

  Future<String> getSelection() async {
    List<String> list = ['$bookName $chapterName'];
    // String subject = '$bookName $chapterName';
    // list.add(subject);
    // verseSelection.value
    //   ..sort((a, b) => a.compareTo(b))
    //   ..forEach((id) {
    //     VERSE o = verse.where((i) => i.id == id).single;
    //     list.add('${o.name}: ${o.text}');
    //   });

    final sel = verseSelection.value..sort((a, b) => a.compareTo(b));
    for (var id in sel) {
      VERSE o = verse.where((i) => i.id == id).single;
      list.add('${o.name}: ${o.text}');
    }

    return list.join("\n");
  }

  /// current book or chapter have been changed
  /// notify then scroll to top
  void changeNotify() {
    Future.microtask(data.notify).whenComplete(() {
      scrollToPosition(0);
    });
  }
}

DefinitionBible parseDefinitionBibleCompute(String response) {
  Map<String, dynamic> parsed = UtilDocument.decodeJSON(response);
  return DefinitionBible.fromJSON(parsed);
}
