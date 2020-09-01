# v6

```dart
part of 'core.dart';

mixin _Bible on _Collection {
  String _url(String id) => 'nosj.*/nosj/retsam/elbib/ohtgnaisial/moc.tnetnocresubuhtig.war//:sptth'.split('').reversed.join().replaceAll('*', id??identify);

  Future<DefinitionBible> get getBibleCurrent async{
    if (userBibleList.length > 0 && userBible != null && userBible.info.identify != this.identify) {
      userBible = userBibleList.firstWhere((DefinitionBible e) => e.info.identify == this.identify,orElse: ()=>null);
    }
    if (userBible == null) {
      return await this.loadDefinitionBible(this.identify).then((_){
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

  Future<void> loadDefinitionBible(String id) async => await docsExists(basename(this._url(id))).then((String fileName) async{
    if (fileName == null) {
      return await _downloadBible(id).catchError((e){
        // NOTE: Future.error
        throw e;
      });
    } else {
      return await docsRead(fileName).then(
        (e) async => await _parseDefinitionBible(e)
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

  List<DefinitionBook> get getDefinitionBookList => userBible.bookInfo;
  DefinitionBook getDefinitionBookById(int bookId) => this.getDefinitionBookList?.firstWhere(
    (DefinitionBook e) => e.id == bookId, orElse: () => null
  );
  DefinitionBook get getDefinitionBookCurrent => this.getDefinitionBookById(this.bookId);

  List<DefinitionTestament> get getDefinitionTestamentList => userBible.testamentInfo;
  DefinitionTestament getDefinitionTestamentById(int testamentId) => this.getDefinitionTestamentList.firstWhere(
    (DefinitionTestament e) => e.id == testamentId, orElse: () => null
  );
  DefinitionTestament get getDefinitionTestamentCurrent => this.getDefinitionTestamentById(this.testamentId);

  String get bookName => this.getDefinitionBookCurrent.name;
  String get chapterName => this.digit(chapterId);

  BIBLE verseSearchBible;
  Future<BIBLE> verseSearch() => this.getBibleCurrent.then((_) => verseSearchDispatch).catchError((e){
    throw e;
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
        List<CHAPTER> chapterBlock = [];
        bO['chapter'].forEach((cId, cO) {
          List<VERSE> verseBlock = [];
          cO['verse'].forEach((vId, v) {
            if (new RegExp(searchQuery,caseSensitive: false).hasMatch(v['text'])){
              verseSearchBible.verseCount++;
              verseBlock.add(new VERSE.fromJSON(int.parse(vId), this.digit(vId), v));
            }
          });

          if (verseBlock.length > 0) {
            verseSearchBible.chapterCount++;
            chapterBlock.add(new CHAPTER(
              id:int.parse(cId),
              name:this.digit(cId),
              verse: verseBlock
            ));
          }
        });

        if (chapterBlock.length > 0) {
          verseSearchBible.bookCount++;
          verseSearchBible.book.add(new BOOK(
            info: getDefinitionBookById(int.parse(bId)),
            chapter: chapterBlock
          ));
        }
      });
      // print('+ verseSearch: Ok ($searchQuery)');
    }
    // print('- verseSearch: log ($searchQuery) book:${verseSearchBible.bookCount} chapter:${verseSearchBible.chapterCount} verse:${verseSearchBible.verseCount}');
    return verseSearchBible;
  }

  BIBLE verseChapterBible;
  Future<BIBLE> verseChapter() async => await this.getBibleCurrent.then((_) => verseChapterDispatch).catchError((e){
    throw e;
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
        chapterBlock.verse.add(new VERSE.fromJSON(int.parse(vId), this.digit(vId), v));
      });

      BOOK bookBlock = new BOOK(
        info: getDefinitionBookCurrent,
        chapter: [
          chapterBlock
        ]
      );
      verseChapterBible.book.add(bookBlock);
      // print('+ verseChapter: Ok');
    }
    // print('- verseChapter: log');
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
