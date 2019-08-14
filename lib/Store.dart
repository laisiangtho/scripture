import 'StoreModel.dart';
import 'StoreCollection.dart';
import 'StoreBible.dart';
import 'StoreConfiguration.dart';

import 'package:usage/usage_io.dart';
import 'dart:io';
import 'package:path/path.dart';

class Store extends StoreConfiguration with StoreCollection, StoreBible {
  static final Store _instance = new Store.internal();
  factory Store() => _instance;
  Store.internal();

   Future<Analytics> get googleAnalytics async{
    return appDirectory.then((FileSystemEntity e){
      return new AnalyticsIO(appAnalytics, join(e.path, 'analytics'), appVersion);
    });
  }
  Future<bool> updateCollectionAvailable() async{
    return await getCollectionBookIdentify().then((CollectionBook book) async{
      return await updateBible(book.available > 0).then((int e) async{
        book.available = e;
        return await writeCollection();
      });
    });
  }
  Future<NAME> activeName() async{
    await this.bible.then((bible) async{
      await getCollectionBookIdentify().then((CollectionBook book) async{
        if (book.available < 1) {
          book.available++;
          await writeCollection();
        }
      });
    });
    this.testamentId = this.bookId > 39?2:1;
    return await this.getNames.then((e){
      return e.singleWhere((i)=>i.book == this.bookId,orElse: ()=>null);
    });
  }

  Future<List<Map<String, dynamic>>>  testingBookmark() async {
    return await this.bookmark.then((e) async{
     List<NAME> bookNames = await this.getNames;
    //  List<Map<String, dynamic>> list = [];
    //  for (var bookmark in e) {
    //    NAME book = bookNames.singleWhere((i)=>i.book == bookmark.book,orElse: ()=>null);
    //   //  int index = bookName.indexWhere((i)=>i.id == bookmark.bookId && i.type == false);
    //    list.add(bookmark.toView(book.bookName));
    //  }
    //  return list;
     return e.map((bookmark){
       NAME book = bookNames.singleWhere((i)=>i.book == bookmark.book,orElse: ()=>null);
      return bookmark.toView(this.digit(bookmark.chapter),book.bookName,book.testamentName);
     }).toList();
    });
  }
}