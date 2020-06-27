import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';

import 'configuration.dart';
// import 'utility.dart';
import 'engine.dart';
// import 'mock.dart';
import 'model/collection.dart';

mixin Bible on Configuration, Engine {

  BIBLE currentBible; //_currentBible
  List<BIBLE> userBible = new List(); //_bibleCollection

  String get _url => 'nosj.*/nosj/retsam/elbib/ohtgnaisial/moc.tnetnocresubuhtig.war//:sptth'.split('').reversed.join().replaceAll('*', this.identify);

  Future<BIBLE> _parseBible(String response) async{
    return currentBible = await compute(computeParseBible,response);
  }

  String digit(dynamic e) => e.toString().replaceAllMapped(new RegExp(r'[0-9]'), (i) => currentBible.digit[int.parse(i.group(0))]);

  Future _requestBible() async {
    return await requestHTTP(this._url).then((response) async {
      await _parseBible(response.body);
      return await docsWrite(basename(this._url),encodeJSON(currentBible.toJSON()).toString());
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
      userBible.add(currentBible);
    });

    return currentBible;
  }

  Future<BIBLE> get bible async{
    if (userBible.isEmpty || currentBible == null) {
      await this._getBible();
    } else if (currentBible.info.identify != this.identify){
      currentBible = userBible.singleWhere((e) => e.info.identify == this.identify,orElse: ()=>null);
      if (currentBible == null) await this._getBible();
    }
    return currentBible;
  }

  Future<List<NAME>> get getNames async{
    await this.bible;
    List<NAME> list = [];
    currentBible.book.forEach((id, v) {
      int bookId = int.parse(id);
      String testament = (bookId >= 40)?'2':'1';

      String testamentName = currentBible.testament[testament]['info']['name'];
      String testamentShortname = currentBible.testament[testament]['info']['shortname'];
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

 // getVerseChapter, getVerseSearch, getVerseBookmark
  Future<List<VERSE>> get getVerseChapter async{
    await this.bible;
    List<VERSE> list = [];
    String cId = this.chapterId.toString();
    String bId = this.bookId.toString();
    currentBible.book[bId]['chapter'][cId]['verse'].forEach((vId, v) {
      list.add(VERSE(
        testament: this.testamentId.toString(),
        book: bId,
        chapter: cId,
        verse: vId,
        verseText: v['text'],
        verseTitle: v['title']??''
      ));
    });
    return list;
  }

  Future<List> getVerseSearchAllInOne(String query) async{
    await this.bible;
    List list = [];
    if (query.isEmpty) return list;
    currentBible.book.forEach((bId, bO) {
      // 'id':this.digit(bId),
      Map bookBlock={'id':int.parse(bId),'name':bO['info']['name'],'child':[]};
      bO['chapter'].forEach((cId, cO) {
        Map chapterBlock={'id':int.parse(cId),'child':[]};
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
            // Map verseBlock={'bid':bId,'cid':cId,'id':vId,'text': v['text']};
            Map verseBlock={'id':vId,'text': v['text']};
            chapterBlock['child'].add(verseBlock);
          }
        });
        if (chapterBlock['child'].length > 0) bookBlock['child'].add(chapterBlock);
      });
      if (bookBlock['child'].length > 0) list.add(bookBlock);
    });
    return list;
  }

  Future<List<BOOK>> get bookTitle async{
    await this.bible;
    List<BOOK> list = [];
    currentBible.book.forEach((id, v) {
      if (id == '1'){
        list.add(BOOK(
          id: 1,
          type:true,
          name: currentBible.testament['1']['info']['name'],
          itemCount: 39,
          shortname: currentBible.testament['1']['info']['shortname']
        ));
      } else if (id == '40') {
        list.add(BOOK(
          id: 2,
          type:true,
          name: currentBible.testament['2']['info']['name'],
          itemCount: 26,
          shortname: currentBible.testament['2']['info']['shortname']
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
    int totalBook = currentBible.book.keys.length;
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
      int totalChapter = currentBible.book[this.bookId.toString()]['chapter'].keys.length;
      this.chapterId = totalChapter;
    }
  }

  Future get chapterNext async {
    await this.bible;
    int totalBook = currentBible.book.keys.length;
    int totalChapter = currentBible.book[this.bookId.toString()]['chapter'].keys.length;
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
    int totalChapter = currentBible.book[bId.toString()]['chapter'].keys.length;
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