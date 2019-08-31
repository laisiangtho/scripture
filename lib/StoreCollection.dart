import 'dart:async';
// import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';

import 'StoreModel.dart';
import 'StoreConfiguration.dart';

Collection parseCollectionBookCompute(dynamic response) {
  Map<String, dynamic> parsed = (response is String)?decodeJSON(response):response;
  return Collection.fromJSON(parsed);
}

mixin StoreCollection on StoreConfiguration {

  String _assetsBookJSON = 'assets/book.json';
  Collection _collection;

  Future _parseCollection(dynamic response) async{
    await compute(parseCollectionBookCompute,response).then((e) => _collection = e);
    _collection.book.sort((a, b) => a.order.compareTo(b.order));
  }

  Future<bool> writeCollection() async{
    return await docsWrite(basename(_assetsBookJSON),encodeJSON(_collection.toJSON()).toString()).catchError((e)=>false).then((s)=>true);
  }

  Future<Collection> updateCollection() async{
    return await requestHTTP('nosj.koob/retsam/elbib/ohtgnaisial/moc.tnetnocresubuhtig.war//:sptth'.split('').reversed.join()).then((response) async{
      Map<String, dynamic> parsed = decodeJSON(response.body);
      await parsed['book'].forEach((e){
        int index = _collection.book.indexWhere((o)=>o.identify==e['identify']);
        if (index >= 0){
          CollectionBook book = _collection.book.elementAt(index);
          book.order = index;
          e.addAll(book.userSetting());
        } else {
          _collection.book.add(CollectionBook.fromJSON(e));
        }
      });
      parsed['keyword'] = _collection.keyword.map((e)=>e.toJSON()).toList();
      parsed['bookmark'] = _collection.bookmark.map((e)=>e.toJSON()).toList();
      await _parseCollection(parsed);
      await writeCollection();
      return _collection;
    });
  }

  Future deleteCollection() async {
    String fileName = basename(_assetsBookJSON);
    return await docsExists(fileName).then((bool yes) async{
      return (yes)?await docsDelete(fileName):false;
    });
  }
  Future<Collection> getCollection() async {
    if (_collection == null) {
      String fileName = basename(_assetsBookJSON);
      await docsExists(fileName).then((bool yes) async{
        if (yes){
          await docsRead(fileName).then((response) => _parseCollection(response));
        } else {
          await loadBundleAsString(_assetsBookJSON).then((response)=>_parseCollection(response));
          await writeCollection();
        }
      });
    }
    if (this.identify.isEmpty){
     this.identify = _collection.book.firstWhere((i) => i.available > 0,orElse: () => _collection.book.first).identify;
    }
    return _collection;
  }
  Future<CollectionBook> getCollectionBookIdentify() async {
    // return _collectionBook.singleWhere((i)=>i.identify == this.identify);
    // return await getCollection().then((o)=>o.where((CollectionBook e)=>e.identify == this.identify).single);
    return await getCollection().then((o)=>o.book.singleWhere((CollectionBook e)=>e.identify == this.identify));
  }
  Future<List<CollectionKeyword>> getCollectionKeyword(String query,{bool add=false}) async {
    return await getCollection().then((o) async{
      if (query.isEmpty){
        return o.keyword;
      } else {
        List<CollectionKeyword> w = o.keyword.where((e)=>e.word.toLowerCase().startsWith(query.toLowerCase())).toList();
        if (add && w.length == 0){
          o.keyword.insert(0, CollectionKeyword.fromJSON(query));
          await writeCollection();
        }
        return w;
      }
    });
  }

  Future<List<CollectionBookmark>> get bookmark => getCollection().then((o) => o.bookmark);

  Future<void> addCollectionBookmark() async {
    return await this.bookmark.then((bookmarks) async{
      int index = bookmarks.indexWhere((i)=>i.book == this.bookId && i.chapter==this.chapterId);
      if (index >= 0) {
        bookmarks.removeAt(index);
      } else {
        bookmarks.add(CollectionBookmark(book:this.bookId,chapter: this.chapterId));
      }
      await writeCollection();
    });
  }

  Future<void> removeCollectionBookmark(int index) async {
    return await this.bookmark.then((bookmark) async{
      if (index >= 0) bookmark.removeAt(index);

      await writeCollection();
    });
  }

  Future<bool> hasCollectionBookmark() async {
    return await this.bookmark.then((bookmark) {
      CollectionBookmark o = bookmark.singleWhere((i)=>(i.book == this.bookId && i.chapter==this.chapterId),orElse: ()=>null);
      return (o != null);
    });
  }


  /*
  static List<CollectionBook> parseCollectionBookCompute(dynamic response) {
    Map<String, dynamic> parsed = (response is String)?decodeJSON(response):response;
    return parsed['book'].map<CollectionBook>((json) => CollectionBook.fromJSON(json)).toList();
  }
  Future<List<CollectionBook>> _parseCollection(dynamic response) async{
    return _collectionBook = await compute(parseCollectionBookCompute,response)..sort((a, b) => a.order.compareTo(b.order));
  }
  Future writeCollection() async{
    List book = _collectionBook.map((e)=>e.toJSON()).toList();
    return await docsWrite(basename(_assetsBookJSON),encodeJSON({'book':book}).toString());
  }

  Future updateCollection() async{
    return await requestHTTP('nosj.koob/retsam/elbib/ohtgnaisial/moc.tnetnocresubuhtig.war//:sptth'.split('').reversed.join()).then((response) async{
      Map<String, dynamic> i = decodeJSON(response.body);
      await i['book'].forEach((e){
        int index = _collectionBook.indexWhere((o)=>o.identify==e['identify']);
        if (index >= 0){
          CollectionBook book = _collectionBook.elementAt(index);
          book.order = index;
          e.addAll(book.userSetting());
        }
      });
      await _parseCollection(i);
      await writeCollection();
    });
  }

  Future<List<CollectionBook>> getCollection() async {
    if (_collectionBook == null) {
      String fileName = basename(_assetsBookJSON);
      // await docsDelete(fileName);
      await docsExists(fileName).then((bool yes) async{
        if (yes){
          await docsRead(fileName).then((response) => _parseCollection(response));
        } else {
          await loadBundleAsString(_assetsBookJSON).then((response)=>_parseCollection(response));
          await writeCollection();
        }
      });
    }
    return _collectionBook;
  }
  Future<CollectionBook> getCollectionIdentify() async {
    // return _collectionBook.singleWhere((i)=>i.identify == this.identify);
    // return await getCollection().then((o)=>o.where((CollectionBook e)=>e.identify == this.identify).single);
    return await getCollection().then((o)=>o.singleWhere((CollectionBook e)=>e.identify == this.identify));
  }
  */
}