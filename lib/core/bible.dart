part of 'core.dart';

mixin _Bible on _Collection {
  String _url(String id) => 'nosj.*/nosj/retsam/elbib/ohtgnaisial/moc.tnetnocresubuhtig.war//:sptth'.split('').reversed.join().replaceAll('*', id??identify);

  Future<DefinitionBible> get getBibleCurrent async{
    if (userBibleList.length > 0 && userBible != null && userBible.info.identify != this.identify) {
      userBible = userBibleList.firstWhere((DefinitionBible e) => e.info.identify == this.identify,orElse: ()=>null);
    }
    if (userBible == null) {
      // print('getBibleCurrent $identify');
      return this.loadDefinitionBible(this.identify).then((_){
        return userBible;
      }).catchError((e){
        throw e;
      });
      // if (userBible == null) {
      //   // throw("still could not get bible");
      //   throw Future.error("still could not get bible");
      // }
    }
    return userBible;
  }

  Future<void> _parseDefinitionBible(String response) async{
    userBible = await compute(parseBibleCompute,response);
    await _prepareName();
    userBibleList.add(userBible);
  }

  Future<void> loadDefinitionBible(String id) => docsExists(basename(this._url(id))).then((String fileName){
    if (fileName == null) {
      return _downloadBible(id).catchError((e){
        // NOTE: Future.error
        throw e;
      });
    } else {
      return docsRead(fileName).then(
        (e) {
          _parseDefinitionBible(e);
        }
      ).catchError((e){
        // NOTE: Future.error
        throw e;
      });
    }
  });

  Future<void> _downloadBible(String id) => requestHTTP(this._url(id)).then((body) async{
    await _parseDefinitionBible(body);
    await docsWrite(basename(this._url(id)),encodeJSON(userBible.toJSON()));
    await updateCollectionBookAvailability(id, 1);
    this.identify = id;
    this.analyticsShare('download', id);
  });


  Future<void> _deleteBible(String id) => docsDelete(basename(this._url(id))).then((_) async {
    await updateCollectionBookAvailability(id, 0);
    await switchCollectionIdentify(id == this.identify);
    // NOTE: since its deleted from storage, have to remove it from session
    int index = userBibleList.indexWhere((DefinitionBible e) => e.info.identify == id);
    if (index >= 0) userBibleList.removeAt(index);
    this.analyticsShare('delete', id);
    // int isAvailable = collection.book.singleWhere((CollectionBible e)=>e.identify == this.identify).available;
    // print('$id is deleted $isAvailable and currentID $identify');
  });

  Future<void> updateBibleAvailability(String id) => docsExists(basename(this._url(id))).then((String e) {
    if (e == null) {
      // NOTE: bible not Available, therefore download it
      return _downloadBible(id);
    } else {
      // NOTE: bible Available, therefore delete it
      return _deleteBible(id);
    }
  }).catchError((e){
    // NOTE: Future.error
    throw e;
  });

  Future<void> _prepareName() async{
    userBible.book.forEach((id, v) {
      int bookId = int.parse(id);
      int testamentId = (bookId >= 40)?2:1;

      userBible.bookInfo.add(DefinitionBook(
        id: bookId,
        testamentId: testamentId,
        name: v['info']['name'],
        shortName: v['info']['shortname'],
        chapterCount: v['chapter'].keys.length,
      ));
    });

    userBible.testament.forEach((id, o) {
      userBible.testamentInfo.add(DefinitionTestament(
        id: int.parse(id),
        name: o['info']['name'],
        shortName:o['info']['shortname'],
      ));
    });
  }

  // String digit(int e) => e.toString().replaceAllMapped(new RegExp(r'[0-9]'), (i) => bible?.digit[int.parse(i.group(0))]);
  String digit(int e) => e.toString().replaceAllMapped(
    new RegExp(r'[0-9]'), (i) => userBible == null?i.group(0):userBible.digit[int.parse(i.group(0))]
  );

  List<DefinitionBook> get getDefinitionBookList => userBible.bookInfo;
  DefinitionBook getDefinitionBookById(int bookId) => getDefinitionBookList.firstWhere((DefinitionBook e) => e.id == bookId);
  DefinitionBook get getDefinitionBookCurrent => getDefinitionBookById(this.bookId);

  List<DefinitionTestament> get getDefinitionTestamentList => userBible.testamentInfo;
  DefinitionTestament getDefinitionTestamentById(int testamentId) => getDefinitionTestamentList.firstWhere((DefinitionTestament e) => e.id == testamentId);
  DefinitionTestament get getDefinitionTestamentCurrent => getDefinitionTestamentById(this.testamentId);

  int get testamentId => this.bookId > 39?2:1;
  String get bookName => getDefinitionBookCurrent.name;
  String get chapterName => this.digit(chapterId);

  BIBLE verseSearchBible;
  Future<BIBLE> verseSearch() => this.getBibleCurrent.then((_) => verseSearchDispatch).catchError((e){
    // print(e);
  });

  bool verseSearchBibleIsEmpty() {
    return (searchQuery.isNotEmpty) && (
      // searchQuery != null ||
      // searchQuery.isNotEmpty &&
      verseSearchBible == null ||
      verseSearchBible.info == null ||
      // _verseSearchBible.query != null ||
      verseSearchBible.query != searchQuery ||
      verseSearchBible.info.identify != this.identify
    );
  }

  BIBLE get verseSearchDispatch {
    if (verseSearchBibleIsEmpty()){
      verseSearchBible = new BIBLE(
        query:searchQuery,
        bookCount:0,
        chapterCount:0,
        verseCount:0,

        info: userBible.info,
        book: []
      );
      userBible.book.forEach((bId, bO) {
        BOOK bookBlock = new BOOK(
          info: userBible.bookInfo.firstWhere((e) => e.id == int.parse(bId),orElse: ()=>null),
          chapter: []
        );
        bO['chapter'].forEach((chapterId, cO) {
          chapterId = int.parse(chapterId);
          CHAPTER chapterBlock = new CHAPTER(
            id:chapterId,
            name:this.digit(chapterId),
            verse: []
          );
          cO['verse'].forEach((verseId, v) {
            if (new RegExp(searchQuery,caseSensitive: false).hasMatch(v['text'])){
              verseId = int.parse(verseId);
              chapterBlock.verse.add(new VERSE.fromJSON(verseId, this.digit(verseId), v));
              verseSearchBible.verseCount++;
            }
          });
          if (chapterBlock.verse.length > 0) {
            bookBlock.chapter.add(chapterBlock);
            verseSearchBible.chapterCount++;
          }
        });
        if (bookBlock.chapter.length > 0) {
          verseSearchBible.book.add(bookBlock);
          verseSearchBible.bookCount++;
        }
      });
      // print('+ verseSearch: Ok ($searchQuery)');
    } else {
      // print('- verseSearch from log for $searchQuery');
    }
    return verseSearchBible;
  }

  BIBLE verseChapterBible;
  Future<BIBLE> verseChapter() => this.getBibleCurrent.then((_) => verseChapterDispatch).catchError((e){
    // print(e);
  });

  bool verseChapterBibleIsEmpty() {
    return (
      verseChapterBible == null ||
      verseChapterBible.info == null ||
      verseChapterBible.info.identify != this.identify ||
      verseChapterBible.book.first.info.id  != this.bookId ||
      verseChapterBible.book.first.chapter.first.id  != this.chapterId
    );
  }

  BIBLE get verseChapterDispatch {
    if (verseChapterBibleIsEmpty()){
      verseChapterBible = new BIBLE(
        info: userBible.info,
        book: []
      );
      // final tId = this.testamentId.toString();
      final bId = this.bookId.toString();
      final cId = this.chapterId.toString();

      CHAPTER chapterBlock = new CHAPTER(
        id: this.chapterId,
        name: this.chapterName,
        verse: []
      );

      userBible.book[bId]['chapter'][cId]['verse'].forEach((vId, v) {
        int verseId = int.parse(vId);
        chapterBlock.verse.add(new VERSE.fromJSON(verseId, this.digit(verseId), v));
      });

      BOOK bookBlock = new BOOK(
        info: userBible.bookInfo.firstWhere((e) => e.id == this.bookId,orElse: ()=>null),
        chapter: [
          chapterBlock
        ]
      );
      verseChapterBible.book.add(bookBlock);
      // print('+ verseChapter: Ok');
    } else {
      // print('- verseChapter from log');
    }
    return verseChapterBible;
  }

  /// Generate previous chapterId, if require its update bookId too
  Future<void> get chapterPrevious => this.getBibleCurrent.then((o){
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
  }).catchError((e){
    throw e;
  });

  /// Generate next chapterId, if require its update bookId too
  Future<void> get chapterNext => this.getBibleCurrent.then((o){
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
  }).catchError((e){
    throw e;
  });

  /// Update chapterId, if Not in available chapter range set to First or Last
  Future<void> chapterBook(int id) => this.getBibleCurrent.then((o){
    int totalChapter = o.book[id.toString()]['chapter'].keys.length;
    if (totalChapter < this.chapterId) {
      if (this.bookId < id) {
        this.chapterId = totalChapter;
      } else {
        this.chapterId = 1;
      }
    }
    this.bookId = id;
  }).catchError((e){
    throw e;
  });
}
