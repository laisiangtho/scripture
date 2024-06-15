part of 'main.dart';

class Scripture extends _ScriptureInterface {
  final Data data;

  // NOTE [0: primary, 1: parallel]
  final int dataType;

  late final Marks marks = Marks(data);

  late CacheBible cacheRead = CacheBible(
    result: bible.prototype(),
    suggest: bible.prototype(),
  );
  late CacheBible cacheSearch = CacheBible(
    result: bible.prototype(),
    suggest: bible.prototype(),
  );
  late CacheTitle cacheTitle = CacheTitle(
    result: bible.prototype(),
  );

  int? _identifyIndexPrevious;

  Scripture(
    this.data, {
    this.dataType = 0,
  });

  // ValueNotifier<List<int>> get verseSelection => data.verseSelection;
  // ValueNotifier<List<int>> get verseColor => data.verseColor;

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
    return data.cacheBible.indexWhere((OfBible e) => e.info.identify == identify);
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
  OfBible get bible {
    return data.cacheBible.elementAt(isReady ? _identifyIndex : _identifyIndexPrevious!);
  }

  Future<OfBible> init() async {
    // searchQuery = data.searchQuery;
    // final check = _identifyIndexPrevious == _identifyIndex;
    // _identifyIndexPrevious = _identifyIndex;

    await marks.init();

    if (isReady) {
      if (dataType == 0) {
        data.notify();
      }
      return bible;
    }
    await switchAvailability();
    _identifyIndexPrevious = _identifyIndex;
    if (isReady) {
      if (dataType == 0) {
        data.notify();
      }
      return bible;
    }
    debugPrint('??? Bible is not loaded');
    // throw "Bible is not loaded";
    return Future.error('Bible is not loaded');
  }

  Future<void> switchAvailability({bool deleteIfExists = false}) {
    return Docs.app.exists(file).then((String e) {
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
      await Docs.app.writeAsString(file, body);
      await switchAvailabilityOfBox(1);
    }).catchError((e) {
      throw e;
    });
  }

  Future<void> _read() {
    return Docs.app.readAsString(file).then((e) async {
      await _parseDefinitionBible(e);
      await switchAvailabilityOfBox(1);
    }).catchError((e) {
      // NOTE: Future.error
      throw e;
    });
  }

  Future<void> _delete() {
    return Docs.app.delete(file).then((_) async {
      // NOTE: since its deleted from storage, have to remove it from session/cache
      if (isReady) {
        data.cacheBible.removeAt(_identifyIndex);
      }
      return switchAvailabilityOfBox(0);
    });
  }

  Future<void> _parseDefinitionBible(String response) async {
    OfBible parsed = await compute(parseDefinitionBibleCompute, response);
    data.cacheBible.add(parsed);
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

  List<OfBook> get bookList {
    return bible.book;
  }

  OfBook bookById(int bookId) {
    return bookList.firstWhere(
      (e) => e.info.id == bookId,
      orElse: () => bookList.first,
    );
  }

  OfBook get bookCurrent {
    return bookById(data.bookId);
  }

  List<OfTestament> get testamentList {
    return bible.testament;
  }

  OfTestament testamentById(int testamentId) {
    return testamentList.firstWhere(
      (e) => e.id == testamentId,
      orElse: () => testamentList.first,
    );
  }

  OfTestament get testamentCurrent {
    return testamentById(data.testamentId);
  }

  String get bookName {
    return bookCurrent.info.name;
    // return bookCurrent.info.shortName;
  }

  int get chapterCount {
    return bookCurrent.totalChapter;
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
    int totalBook = bible.book.length;
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

      int totalChapter = bookById(data.bookId).totalChapter;
      data.chapterId = totalChapter;
    }
  }

  void chapterSnapPreviousTmp() {
    int bookId = data.bookId;
    int chapterId = data.chapterId;

    int totalBook = bible.book.length;
    int cId = chapterId - 1;

    if (cId > 0) {
      // data.chapterId = cId;
      chapterId = cId;
    } else {
      int bId = data.bookId - 1;
      if (bId > 0) {
        // data.bookId = bId;
        bookId = bId;
      } else {
        // data.bookId = totalBook;
        bookId = totalBook;
      }

      int totalChapter = bookById(bookId).totalChapter;
      // data.chapterId = totalChapter;
      chapterId = totalChapter;
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
    int totalBook = bible.book.length;
    int totalChapter = bookById(data.bookId).totalChapter;
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
      int totalChapter = bookById(bId).totalChapter;
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
    final e = cacheSearch.result;
    // if (e.book.isNotEmpty) {
    //   return e.info.identify != identify || cacheSearch.query != data.suggestQuery;
    // }
    // return false;
    return e.info.identify != identify || cacheSearch.query != data.suggestQuery;
  }

  /// Bible search
  CacheBible get verseSearch {
    if (verseSearchCacheIsEmpty) {
      cacheSearch.query = data.suggestQuery;
      if (data.suggestQuery.isEmpty) {
        return cacheSearch;
      }

      final keyword = data.suggestQuery.toLowerCase();

      final contain = bible.wordContains(keyword);
      final suggest = contain.wordStarts(keyword);
      final result = suggest.wordEnds(keyword);
      debugPrint(
          'search contains ${contain.totalBook} ${contain.totalChapter} ${contain.totalVerse}');
      debugPrint(
          'search suggest ${suggest.totalBook} ${suggest.totalChapter} ${suggest.totalVerse}');
      debugPrint('search result ${result.totalBook} ${result.totalChapter} ${result.totalVerse}');

      Set<String> words = {};
      if (result.book.isEmpty) {
        if (suggest.book.isNotEmpty) {
          words = suggest.wordExtracts(data.suggestQuery);
          debugPrint('search b word:${words.length}');
          debugPrint('search word:$words');
        } else if (contain.book.isNotEmpty) {
          words = contain.wordExtracts(data.suggestQuery);
          debugPrint('search a word:${words.length}');
          debugPrint('search word:$words');
        }
      }

      cacheSearch = cacheSearch.update(
        result: result,
        suggest: suggest,
        words: words,
        query: data.suggestQuery,
      );
    }
    return cacheSearch;
  }

  // Bible titles
  bool get readCacheIsEmpty {
    final e = cacheRead.result;
    if (e.book.isNotEmpty) {
      return (e.info.identify != identify ||
          e.book.first.info.id != data.bookId ||
          e.book.first.chapter.first.id != data.chapterId);
    }
    return true;
  }

  /// bible from current read
  CacheBible get read {
    if (readCacheIsEmpty) {
      cacheRead = cacheRead.update(
        query: data.suggestQuery,
        result: bible.getChapter(data.bookId, data.chapterId),
      );
    }
    return cacheRead;
  }

  /// list of book from current read
  List<OfBook> get book => read.result.book;

  /// list of chapter from current reading book
  List<OfChapter> get chapter => book.first.chapter;

  /// list of verses from current reading chapter
  List<OfVerse> get verse => chapter.first.verse;

  bool get cacheTitleIsEmpty {
    final e = cacheTitle.result;
    if (e.book.isNotEmpty) {
      return (e.ready == false || e.info.identify != identify);
    }
    return true;
  }

  /// Chapter titles
  CacheTitle get title {
    if (cacheTitleIsEmpty) {
      cacheTitle = cacheTitle.update(
        result: bible.getTitle(),
        ready: true,
      );
    }

    return cacheTitle;
  }
}

class _ScriptureInterface {
  // ValueNotifier<List<int>> verseSelection = ValueNotifier<List<int>>([]);
  // ValueNotifier<List<int>> verseColor = ValueNotifier<List<int>>([]);

  ScrollController? scroll;

  void scrollToPosition(double pos) {
    scroll?.animateTo(
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
        // return e.id < id;
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

    final sel = marks.verseSelection..sort((a, b) => a.compareTo(b));
    for (var id in sel) {
      OfVerse o = verse.where((i) => i.id == id).single;

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

OfBible parseDefinitionBibleCompute(String response) {
  Map<String, dynamic> parsed = Docs.raw.decodeJSON(response);
  return OfBible.fromJSON(parsed);
}
