// import 'dart:io';
// import 'dart:convert';
// import 'dart:math';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';

import 'StoreModel.dart';
import 'StoreConfiguration.dart';


mixin StoreBible on StoreConfiguration {

  BIBLE _bible;
  List<BIBLE> _bibleCollection = new List();


  String get _url => 'nosj.*/nosj/retsam/elbib/ohtgnaisial/moc.tnetnocresubuhtig.war//:sptth'.split('').reversed.join().replaceAll('*', this.identify);


  Future<BIBLE> _parseBible(String response) async{
    return _bible = await compute(computeParseBible,response);
  }

  Future _requestBible() async {
    return await requestHTTP(this._url).then((response) async {
      await _parseBible(response.body);
      return await docsWrite(basename(this._url),encodeJSON(_bible.toJSON()).toString());
    });
  }

  Future<int> updateBible(bool toDelete) async {
    String fileName = basename(this._url);
    return await docsExists(fileName).then((bool yes) async{
      if (yes) {
        // NOTE bible Available, therefore delete it
        return toDelete?await docsDelete(fileName).then((e) => 0):1;
      } else {
        // NOTE bible not Available, therefore download it
        return toDelete?0:await this._requestBible().then((e) => 1);
      }
    });
  }

  Future<BIBLE> _getBible() async{
    String fileName = basename(this._url);
    await docsExists(fileName).then((bool yes) async{
      if (yes) {
        await docsRead(fileName).then((response) => _parseBible(response));
      } else {
        await _requestBible();
      }
      _bibleCollection.add(_bible);
    });
    return _bible;
  }

  Future<BIBLE> get bible async{
    if (_bibleCollection.isEmpty) await this._getBible();
    if (_bible.info.identify != this.identify){
      _bible = _bibleCollection.singleWhere((e) => e.info.identify == this.identify,orElse: ()=>null);
      if (_bible == null) await this._getBible();
    }
    return _bible;
  }

  // new RegExp(k, "gi").test(s)
  // String verse = "Thah dinga a kikaikhia mipa honkhia in la, sihna ding mun a zuan mipa lehkaih kik in.";
  // String keyword = "honkhia";
  // RegExp exp = new RegExp(keyword,caseSensitive: false);
  // bool matches = exp.hasMatch(verse);
  // print(matches);
  String digit(dynamic e) => e.toString().replaceAllMapped(new RegExp(r'[0-9]'), (i) => _bible.digit[int.parse(i.group(0))]);

  // Future<BIBLE> activeName() async{
  //   await this.bible;
  //   Map book = _bible.book[this.bookId.toString()];
  //   // this.bookName = book['info']['name'];
  //   this.chapterCount = book['chapter'].keys.length;

  //   this.testamentId = this.bookId > 39?2:1;
  //   // this.testamentName = _bible.testament[this.testamentId.toString()]['info']['name'];

  //   return _bible;
  // }
  Future<NAME> activeName() async{
    await this.bible;
    this.testamentId = this.bookId > 39?2:1;
    return await this.getNames.then((e){
      return e.singleWhere((i)=>i.book == this.bookId,orElse: ()=>null);
    });
  }

  Future<List<NAME>> get getNames async{
    await this.bible;
    List<NAME> list = [];
    _bible.book.forEach((id, v) {
      int bookId = int.parse(id);
      String testament = (bookId >= 40)?'2':'1';

      String testamentName = _bible.testament[testament]['info']['name'];
      String testamentShortname = _bible.testament[testament]['info']['shortname'];
      list.add(NAME(
        testament: int.parse(testament),
        testamentName: testamentName,
        testamentShortname:testamentShortname,
        book: bookId,
        bookName: v['info']['name'],
        bookShortname: v['info']['shortname'],
        chapterCount: v['chapter'].keys.length
      ));
    });
    return list;
  }
    // verseChapter, verseSearch, verseBookmark
  Future<List<VERSE>> get verseChapter async{
    await this.bible;
    List<VERSE> list = [];
    Map o = _bible.book[this.bookId.toString()]['chapter'][this.chapterId.toString()]['verse'];
    o.forEach((vId, v) {
      list.add(VERSE(
        testament: this.testamentId.toString(),
        book: this.bookId.toString(),
        chapter: this.chapterId.toString(),
        verse: vId,
        verseText: v['text'],
        verseTitle: v['title']
      ));
    });
    return list;
  }

  Future<List> verseSearchTesting(String query) async{
    await this.bible;
    List list = [];
    if (query.isEmpty) return list;
    _bible.book.forEach((bId, bO) {
      // 'id':this.digit(bId),
      Map bookBlock={'name':bO['info']['name'],'child':[]};
      bO['chapter'].forEach((cId, cO) {
        Map chapterBlock={'id':cId,'child':[]};
        cO['verse'].forEach((vId, v) {
          if (new RegExp(query,caseSensitive: false).hasMatch(v['text'])){
            // list.add(VERSE(
            //   testament: '0',
            //   book: bId,
            //   chapter: cId,
            //   verse: vId,
            //   verseText: v['text'],
            //   verseTitle: v['title']
            // ));
            Map verseBlock={'bid':bId,'cid':cId,'id':vId,'text': v['text']};
            chapterBlock['child'].add(verseBlock);
          }
        });
        if (chapterBlock['child'].length > 0) bookBlock['child'].add(chapterBlock);
      });
      if (bookBlock['child'].length > 0) list.add(bookBlock);
    });
    return list;
  }

  // getbookName, getTestamentName

  // Future<BOOK> getBookName(int bookId) async {
  //   return await bookTitle.then((e){
  //     return e.singleWhere((i)=>i.id == bookId && i.type == false,orElse: ()=>null);
  //   });
  // }
  // Future<BOOK> getTestamentName(int testamentId) async {
  //   return await bookTitle.then((e){
  //     return e.singleWhere((i)=>i.id == testamentId && i.type == true,orElse: ()=>null);
  //   });
  // }

  Future<List<BOOK>> get bookTitle async{
    await this.bible;
    List<BOOK> list = [];
    _bible.book.forEach((id, v) {
      if (id == '1'){
        list.add(BOOK(
          id: 1,
          type:true,
          name: _bible.testament['1']['info']['name'],
          itemCount: 39,
          shortname: _bible.testament['1']['info']['shortname']
        ));
      } else if (id == '40') {
        list.add(BOOK(
          id: 2,
          type:true,
          name: _bible.testament['2']['info']['name'],
          itemCount: 26,
          shortname: _bible.testament['2']['info']['shortname']
        ));
      }

      list.add(BOOK(
        id: int.parse(id),
        type:false,
        name: v['info']['name'],
        itemCount: v['chapter'].keys.length,
        shortname: v['info']['shortname']
      ));
    });
    return list;
  }
  Future get chapterPrevious async {
    await this.bible;
    int totalBook = _bible.book.keys.length;
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
      int totalChapter = _bible.book[this.bookId.toString()]['chapter'].keys.length;
      this.chapterId = totalChapter;
    }
  }
  Future get chapterNext async {
    await this.bible;
    int totalBook = _bible.book.keys.length;
    int totalChapter = _bible.book[this.bookId.toString()]['chapter'].keys.length;
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
  }
  Future chapterBook(int bId) async {
    await this.bible;
    int totalChapter = _bible.book[bId.toString()]['chapter'].keys.length;
    if (totalChapter < this.chapterId) {
      if (this.bookId < bId) {
        this.chapterId = totalChapter;
      } else {
        this.chapterId = 1;
      }
    }
    this.bookId = bId;
  }
}