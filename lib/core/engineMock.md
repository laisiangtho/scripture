# abc

```dart

// import 'dart:async';
// import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';

import 'configuration.dart';
// import '../avail.dart';
import 'model/collection.dart';

mixin EngineMock on Configuration {
  Collection collection; // _collection

  Future _parseCollection(dynamic response) async{
    // await compute(computeParseCollection,response).then((e) => collection = e);
    // collection.book.sort((a, b) => a.order.compareTo(b.order));
    // await compute(computeParseCollection,response).then(
    //   (_) => collection = _
    // ).then(
    //   (_) => _.book.sort((a, b) => a.order.compareTo(b.order))
    // );
    collection = await compute(computeParseCollection,response);
  }

  Future initCollection() async {
    if (collection == null) {
      String fileName = basename(this.assetsBookJSON);
      await docsExists(fileName).then((bool yes) async{
        if (yes){
          await docsRead(fileName).then((response) => _parseCollection(response));
        } else {
          await loadBundleAsString(assetsBookJSON).then((response)=>_parseCollection(response));
          await writeCollection();
        }
      });
    }
    this.isReady = collection != null;
  }

  Future<bool> writeCollection() async{
    return await docsWrite(basename(this.assetsBookJSON), encodeJSON(collection.toJSON()).toString()).catchError(
      (e)=>false
    ).then(
      (s)=>true
    );
  }

  Future<Collection> getCollection() async {
    await initCollection();
    if (this.identify.isEmpty){
      this.identify = collection.book.firstWhere((i) => i.available > 0,orElse: () => collection.book.first).identify;
    }
    return collection;
  }

  Future<Collection> updateCollection() async {
    return await requestHTTP('nosj.koob/retsam/elbib/ohtgnaisial/moc.tnetnocresubuhtig.war//:sptth'.split('').reversed.join()).then((response) async{
      Map<String, dynamic> parsed = decodeJSON(response.body);
      await parsed['book'].forEach((e){
        int index = collection.book.indexWhere((o)=>o.identify==e['identify']);
        if (index >= 0){
          CollectionBook book = collection.book.elementAt(index);
          book.order = index;
          e.addAll(book.userSetting());
        } else {
          collection.book.add(CollectionBook.fromJSON(e));
        }
      });
      parsed['keyword'] = collection.keyword.map((e)=>e.toJSON()).toList();
      parsed['bookmark'] = collection.bookmark.map((e)=>e.toJSON()).toList();
      await _parseCollection(parsed);
      await writeCollection();
      return collection;
    });
  }

  Future<CollectionBook> getCollectionBookIdentify() async {
    // return collectionBook.singleWhere((i)=>i.identify == this.identify);
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

  Future deleteCollection() async {
    String fileName = basename(this.assetsBookJSON);
    return await docsExists(fileName).then((bool yes) async{
      return (yes)?await docsDelete(fileName):false;
    });
  }
}