part of 'core.dart';

class Scripture{
  String identify;
  int testamentId;
  int bookId;
  int chapterId;
  String searchQuery='';

  DefinitionBible bible;
  int availability = 0;

  Scripture({this.identify, this.testamentId, this.bookId, this.chapterId,this.searchQuery}){
    this.setting(identify, testamentId, bookId, chapterId, searchQuery);
    this.notReady();
  }

  String get url => 'nosj.*/nosj/retsam/elbib/ohtgnaisial/moc.tnetnocresubuhtig.war//:sptth'.split('').reversed.join().replaceAll('*', identify);
  String get fileName => basename(this.url);

  bool notReady() {
    if (isLoaded == false && userBibleList.length > 0) {
      bible = userBibleList.firstWhere((DefinitionBible e) => e.info.identify == this.identify,orElse: ()=>null);
    }
    return this.isLoaded == false;
  }

  void setting(String identify,int testamentId, int bookId,int chapterId, String searchQuery) {
    if(identify != null) this.identify = identify;
    if(testamentId != null) this.testamentId = testamentId;
    if(bookId != null) this.bookId = bookId;
    if(chapterId != null) this.chapterId = chapterId;
    if(searchQuery != null) this.searchQuery = searchQuery;
  }

  Future<DefinitionBible> get load async{
    notReady();
    if (isLoaded == false) {
      return this.loader().then((_){
        return this.bible;
      });
      // if (content == null) {
      //   // throw("still could not get bible");
      //   throw Future.error("still could not get bible");
      // }
    }
    return this.bible;
  }

  /// get scripture
  Future<DefinitionBible> get data async {
    if (this.bible == null){
      throw "Bible is not loaded";
    }
    return this.bible;
  }

  bool get isLoaded => (bible != null && bible.info.identify == this.identify);

  Future<void> loader() async => docsExists(this.fileName).then((String fileName) {
    if (fileName == null) {
      return download();
    } else {
      return read();
    }
  });

  Future<void> _parseDefinitionBible(String response) async{
    bible = await compute(parseBibleCompute,response);
    await _prepareName();
    userBibleList.add(bible);
    this.availability = (bible.info.version < 1)?1:bible.info.version;
  }

  Future<void> download() => requestHTTP(this.url).then((body) async{
    await _parseDefinitionBible(body);
    await docsWrite(this.fileName,encodeJSON(bible.toJSON()));
    // this.identify = id;
    // this.analyticsShare('download', id);
  });

  Future<void> read() => docsRead(this.fileName).then((e) async{
    await _parseDefinitionBible(e);
  }).catchError((e){
    // NOTE: Future.error
    throw e;
  });

  Future<void> delete() => docsDelete(this.fileName).then((_) async {
    this.availability = 0;
    // NOTE: since its deleted from storage, have to remove it from session
    int index = userBibleList.indexWhere((DefinitionBible e) => e.info.identify == this.identify);
    if (index >= 0) userBibleList.removeAt(index);
    // this.analyticsShare('delete', id);
  });

  Future<void> updateAvailability() => docsExists(this.fileName).then((String e) {
    if (e == null) {
      // NOTE: bible not Available, therefore download it
      return download();
    } else {
      // NOTE: bible Available, therefore delete it
      return delete();
    }
  }).catchError((e){
    // NOTE: Future.error
    throw e;
  });

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
    new RegExp(r'[0-9]'), (i) => bible == null?i.group(0):bible.digit[int.parse(i.group(0))]
  );

  List<DefinitionBook> get bookList => bible.bookInfo;
  DefinitionBook bookById(int bookId) => this.bookList?.firstWhere(
    (DefinitionBook e) => e.id == bookId, orElse: () => null
  );
  DefinitionBook get bookCurrent => this.bookById(this.bookId);

  List<DefinitionTestament> get testamentList => bible.testamentInfo;
  DefinitionTestament testamentById(int testamentId) => this.testamentList.firstWhere(
    (DefinitionTestament e) => e.id == testamentId, orElse: () => null
  );
  DefinitionTestament get testamentCurrent => this.testamentById(this.testamentId);

  String get bookName => this.bookCurrent.name;
  String get chapterName => this.digit(chapterId);

  BIBLE verseSearchData;
  // Future<BIBLE> verseSearch() => this.load.then((_) => verseSearchDispatch()).catchError((e){
  //   throw e;
  // });

  bool verseSearchDataIsEmpty({String id, int testament, int book, int chapter, String query}) {
    this.setting(id, testament, book, chapter, query);
    return (this.searchQuery.isNotEmpty) && (
      // searchQuery != null ||
      // searchQuery.isNotEmpty &&
      verseSearchData == null ||
      verseSearchData.info == null ||
      // _verseSearchData.query != null ||
      verseSearchData.query != searchQuery ||
      verseSearchData.info.identify != this.identify
    );
  }

  BIBLE get verseSearch {
    if (verseSearchDataIsEmpty()){
      verseSearchData = new BIBLE(
        query:searchQuery,
        bookCount:0,
        chapterCount:0,
        verseCount:0,

        info: bible.info,
        book: []
      );

      bible.book.forEach((bId, bO) {
        List<CHAPTER> chapterBlock = [];
        bO['chapter'].forEach((cId, cO) {
          List<VERSE> verseBlock = [];
          cO['verse'].forEach((vId, v) {
            if (new RegExp(searchQuery,caseSensitive: false).hasMatch(v['text'])){
              verseSearchData.verseCount++;
              verseBlock.add(new VERSE.fromJSON(new GlobalKey(),int.parse(vId), this.digit(vId), v));
            }
          });

          if (verseBlock.length > 0) {
            verseSearchData.chapterCount++;
            chapterBlock.add(new CHAPTER(
              id:int.parse(cId),
              name:this.digit(cId),
              verse: verseBlock
            ));
          }
        });

        if (chapterBlock.length > 0) {
          verseSearchData.bookCount++;
          verseSearchData.book.add(new BOOK(
            info: bookById(int.parse(bId)),
            chapter: chapterBlock
          ));
        }
      });
      // print('+ verseSearch: Ok ($searchQuery)');
    }
    // print('- verseSearch: log ($searchQuery) book:${verseSearchData.bookCount} chapter:${verseSearchData.chapterCount} verse:${verseSearchData.verseCount}');
    return verseSearchData;
  }

  BIBLE verseChapterData;

  bool verseChapterDataIsEmpty({String id, int testament, int book, int chapter, String query}) {
    this.setting(id, testament, book, chapter, query);
    return (
      verseChapterData == null ||
      verseChapterData.info == null ||
      verseChapterData.info.identify != this.identify ||
      verseChapterData.book.first.info.id  != this.bookId ||
      verseChapterData.book.first.chapter.first.id  != this.chapterId
    );
  }

  BIBLE get verseChapter {
    if (verseChapterDataIsEmpty()){
      verseChapterData = new BIBLE(
        info: bible.info,
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

      bible.book[bId]['chapter'][cId]['verse'].forEach((vId, v) {
        chapterBlock.verse.add(new VERSE.fromJSON(new GlobalKey(),int.parse(vId), this.digit(vId), v));
      });

      BOOK bookBlock = new BOOK(
        info: bookCurrent,
        chapter: [
          chapterBlock
        ]
      );
      verseChapterData.book.add(bookBlock);
      // print('+ verseChapter: Ok');
    }
    // print('- verseChapter: log');
    return verseChapterData;
  }

}