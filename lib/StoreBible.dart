import 'dart:io';
import 'dart:convert';
// import 'dart:math';
import 'package:path/path.dart';

import 'package:laisiangtho/StoreModel.dart';
import 'package:laisiangtho/StoreConfiguration.dart';

mixin StoreBible on StoreConfiguration {

  String _bibleIdentify;
  Map _bibleCollection;
  List _bibleDigit;

  get _url => 'nosj.*/nosj/retsam/elbib/ohtgnaisial/moc.tnetnocresubuhtig.war//:sptth'.split('').reversed.join().replaceAll('*', this.identify);
  get _filename => basename(this._url);

  Future<Map> get requestBibleJSON async {
    // final response = await this.requestHTTP(this._url);
    // return json.decode(response.body);
    // return json.decode(response.body).cast<Map<String, dynamic>>();
    // return json.decode(await this.requestHTTP(this._url)..body);

    return await this.requestHTTP(this._url).then((response) =>json.decode(response.body));
  }

  Future<File> get localBibleJSON async {
    // final directory = await appDirectory;
    // String filename = basename(this._url);
    // return new File('${directory.path}/$filename');
    return await appFile(_filename);
  }

  Future<File> writeBibleJSON(Map data) async {
    final file = await localBibleJSON;
    // return file.writeAsString(json.encode(_bibleCollection));
    return file.writeAsString(json.encode(data));
  }
  Future<Map> get readBibleJSON async {
    final file = await localBibleJSON;
    return json.decode(await file.readAsString());
  }
  Future<FileSystemEntity> deleteBibleJSON() async {
    // final file = await localBibleJSON;
    // return file.delete();
    return await localBibleJSON..delete();
  }

  Future<bool> existsBibleJSON() async {
    // File bookFile = await localBibleJSON;
    // return await bookFile.exists()?true:false;
    // return await localBibleJSON.then((File file) async{
    //   return await file.exists()?true:false;
    // });
    return await localBibleJSON.then((File file) async => await file.exists());
  }

  Future get initiateBible async {
    print('initiateBible');
    _bibleIdentify = this.identify;
    if (await this.existsBibleJSON()) {
      try {
        _bibleCollection = await this.readBibleJSON;
      } catch (e) {
        print(e);
      }
    } else {
      // _bibleCollection = await this.requestBibleJSON;
      // await this.writeBibleJSON;
      await this.requestBibleJSON.then((response) async {
        // await this.bookAvailability(book.available.toString()).then((int count) => count>0);
        _bibleCollection = response;
        return await this.writeBibleJSON(response);
      });
    }
    _bibleDigit  = _bibleCollection['digit'];
  }
  Future<Map> get bible async {
    // if (_bibleCollection == null) await initiateBible;
    // return _bibleCollection;
    // _bibleIdentify = this.identify
    if (_bibleCollection == null || _bibleIdentify != this.identify) await initiateBible;
    return _bibleCollection;
  }

  digit(dynamic e) => e.toString().replaceAllMapped(new RegExp(r'[0-9]'), (i) => _bibleDigit[int.parse(i.group(0))]);


  Future<ModelChapter> get titleName async{
    print('titleName');
    Map _bible = await this.bible;
    Map _book = _bible['book'][this.bookId.toString()];
    this.chapterCount = _book['chapter'].keys.length;
    this.testamentId = this.bookId > 39?2:1;
    Map _testament = _bible['testament'][this.testamentId.toString()];
    // String chapterName = await this.digit(this.chapterId).then((e) => e);
    String chapterName = this.digit(this.chapterId);
    return ModelChapter(
      testament:_testament['info']['name'],
      book:_book['info']['name'],
      chapter:chapterName,
      chapterCount:this.chapterCount
    );
  }
  Future<List<ModelBook>> get nameList async{
    List<ModelBook> list = [];
    final tmp = await this.bible;
    tmp['book'].forEach((id, v) {
      if (id == '1'){
        list.add(ModelBook(
          id: 1,
          type:true,
          name: tmp['testament']['1']['info']['name'],
          itemCount: 39,
          shortname: tmp['testament']['1']['info']['shortname']
        ));
      } else if (id == '40') {
        list.add(ModelBook(
          id: 2,
          type:true,
          name: tmp['testament']['2']['info']['name'],
          itemCount: 26,
          shortname: tmp['testament']['2']['info']['shortname']
        ));
      }
      int chapters = v['chapter'].keys.length;
      list.add(ModelBook(
        id: int.parse(id),
        type:false,
        name: v['info']['name'],
        itemCount: chapters,
        shortname: v['info']['shortname']
      ));
    });
    return list;
  }
  // verseChapter, verseSearch, verseBookmark
  Future<List<ModelVerse>> get verseChapter async{
    final tmp = await this.bible;
    List<ModelVerse> list = [];
    Map o = tmp['book'][this.bookId.toString()]['chapter'][this.chapterId.toString()]['verse'];
    o.forEach((vId, v) {
      list.add(ModelVerse(
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
  Future get chapterPrevious async {
    final src = await this.bible;
    int totalBook = src['book'].keys.length;
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
      int totalChapter = src['book'][this.bookId.toString()]['chapter'].keys.length;
      this.chapterId = totalChapter;
    }
    // return [this.bookId,this.chapterId];
    // print('book: $bookId, chapter: $chapterId');
  }
  // chapterNext,chapterPrevious, chapterBook
  Future get chapterNext async {
    final src = await this.bible;
    int totalBook = src['book'].keys.length;
    int totalChapter = src['book'][this.bookId.toString()]['chapter'].keys.length;
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
    // <List<String>>
    // return [this.bookId,this.chapterId];
  }
  Future chapterBook(int bId) async {
    final src = await this.bible;
    int totalChapter = src['book'][bId.toString()]['chapter'].keys.length;
    if (totalChapter < this.chapterId) {
      if (this.bookId < bId) {
        this.chapterId = totalChapter;
      } else {
        this.chapterId = 1;
      }
    }
    this.bookId = bId;
    // return [bId,this.chapterId];
  }
}